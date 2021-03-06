#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
    struct spinlock lock;
    struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;

int tidCounter = 1;

int mutexCounter = 0;

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

void sleep(void *chan, struct spinlock *lk);

void cleanThread(struct thread *t);

void cleanProcOneThread(struct thread *curthread, struct proc *p);

void
pinit(void) {
    if (DEBUGMODE > 0)
        cprintf(" PINIT ");
    initlock(&ptable.lock, "ptable");
}

//used to lock ptable.lock from exec only!
void
exec_acquire(void) {
    acquire(&ptable.lock);
}

//used to unlock ptable.lock from exec only!
void
exec_release(void) {
    release(&ptable.lock);
}

//must be called under acquire(&ptable.lock)!
void
cleanThread(struct thread *t) {
    if (DEBUGMODE > 0)
        cprintf(" CLEAN_THREAD ");
    if (t->tkstack != 0) {
        kfree(t->tkstack);
        t->tkstack = 0;
    }
    t->state = UNUSED;
    t->tid = 0;
    t->name[0] = 0;
    t->tkilled = 0;
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

// Remove threads (except of the exec thread)
void
cleanProcOneThread(struct thread *curthread, struct proc *p) {
    if (DEBUGMODE > 0) {
        cprintf(" CLEAN_PROC_ONE_THREAD ");
    }
    struct thread *t;
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
    p->mainThread = curthread;
    for (t = p->thread; t < &p->thread[NTHREADS];t++) {
        if (t != curthread && t->state != UNUSED) {
                if (t->state == RUNNING)
                    sleep(t, &ptable.lock);
                wakeup1(t);
                cleanThread(t);
        }
    }
    release(&ptable.lock);
}


// Must be called with interrupts disabled
int
cpuid() {
    return mycpu() - cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu *
mycpu(void) {
    int apicid, i;

    if (readeflags() & FL_IF)
        panic("mycpu called with interrupts enabled\n");

    apicid = lapicid();
    // APIC IDs are not guaranteed to be contiguous. Maybe we should have
    // a reverse map, or reserve a register to store &cpus[i].
    for (i = 0; i < ncpu; ++i) {
        if (cpus[i].apicid == apicid)
            return &cpus[i];
    }
    panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc *
myproc(void) {
    struct cpu *c;
    struct proc *p;
    pushcli();
    c = mycpu();
    p = c->proc;
    popcli();
    return p;
}


// Disable interrupts so that we are not rescheduled
// while reading thread from the cpu structure
struct thread *
mythread(void) {
    struct cpu *c;
    struct thread *t;
    pushcli();
    c = mycpu();
    t = c->currThread;
    popcli();
    return t;
}


//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void) {
    if (DEBUGMODE > 0)
        cprintf(" ALLOCPROC ");
    struct proc *p;
    struct thread *t;
    struct kthread_mutex_t *m;
    char *sp;
    ptable.lock.name = "ALLOC";
    acquire(&ptable.lock);


    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
        if (p->state == UNUSED)
            goto found;

    release(&ptable.lock);
    return 0;

    found:
    p->state = EMBRYO;
    p->pid = nextpid++;


    //from here- thread alloc
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state == UNUSED)
            goto foundThread;
    }

    p->pid = 0;
    p->state = UNUSED;
    release(&ptable.lock);
    return 0;

    foundThread:
    t->state = EMBRYO;
    t->tid = tidCounter++;
    p->mainThread = t;
    t->tkilled = 0;

    for (m = p->kthread_mutex_t; m < &p->kthread_mutex_t[MAX_MUTEXES]; m++)
        m->active = 0;

        // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->pid = -1;
        p->state = UNUSED;
        t->tid = -1;
        t->tkilled = 0;
        t->state = UNUSED;
        release(&ptable.lock);
        return 0;
    }
    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
    t->tf = (struct trapframe *) sp;

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    release(&ptable.lock);

    return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void) {
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    p = allocproc();
    initproc = p;
    if ((p->pgdir = setupkvm()) == 0)
        panic("userinit: out of memory?");
    inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
    p->sz = PGSIZE;
    memset(p->mainThread->tf, 0, sizeof(*p->mainThread->tf));
    p->mainThread->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    p->mainThread->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    p->mainThread->tf->es = p->mainThread->tf->ds;
    p->mainThread->tf->ss = p->mainThread->tf->ds;
    p->mainThread->tf->eflags = FL_IF;
    p->mainThread->tf->esp = PGSIZE;
    p->mainThread->tf->eip = 0;  // beginning of initcode.S

    safestrcpy(p->name, "initcode", sizeof(p->name));
    safestrcpy(p->mainThread->name, "initThread", sizeof(p->mainThread->name));
    p->cwd = namei("/");

    // this assignment to p->state lets other cores
    // run this process. the acquire forces the above
    // writes to be visible, and the lock is also needed
    // because the assignment might not be atomic.

    ptable.lock.name = "INIT";
    acquire(&ptable.lock);

    p->state = RUNNABLE;
    p->mainThread->state = RUNNABLE;

    release(&ptable.lock);
    if (DEBUGMODE > 0)
        cprintf("->DONE_USERINIT");
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
        cprintf(" GROWPROC");

    sz = curproc->sz;
    if (n > 0) {
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    } else if (n < 0) {
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
            return -1;
    }
    curproc->sz = sz;
    if (DEBUGMODE > 0)
        cprintf("->GROWPROC_DONE ");
    switchuvm(curproc, mythread());
    return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void) {
    if (DEBUGMODE > 0)
        cprintf(" FORK ");
    int i, pid;
    struct proc *np;
    struct proc *curproc = myproc();
    struct thread *curthread = mythread();

    // Allocate process.
    if ((np = allocproc()) == 0) {
        return -1;
    }

    // Copy process state from proc.
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0) {
        kfree(np->mainThread->tkstack);
        np->mainThread->tkstack = 0;
        np->state = UNUSED;
        np->mainThread->state = UNUSED;
        return -1;
    }
    np->sz = curproc->sz;
    np->parent = curproc;
    *np->mainThread->tf = *curthread->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->mainThread->tf->eax = 0;

    for (i = 0; i < NOFILE; i++)
        if (curproc->ofile[i])
            np->ofile[i] = filedup(curproc->ofile[i]);

    np->cwd = idup(curproc->cwd);
    //copy names
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));

    pid = np->pid;

    ptable.lock.name = "FORK";
    acquire(&ptable.lock);

    np->state = RUNNABLE;
    np->mainThread->state = RUNNABLE;

    release(&ptable.lock);

    return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void) {
    struct proc *curproc = myproc();
    struct proc *p;
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
        cprintf("EXIT");
    if (curproc == initproc)
        panic("init exiting");

    cleanProcOneThread(curthread, curproc);
    //When got here - the only thread that is RUNNINNG is curThread
    //all other threads are ZOMBIE

    // Close all open files.
    for (fd = 0; fd < NOFILE; fd++) {
        if (curproc->ofile[fd]) {
            fileclose(curproc->ofile[fd]);
            curproc->ofile[fd] = 0;
        }
    }
    begin_op();
    iput(curproc->cwd);
    end_op();
    curproc->cwd = 0;
    ptable.lock.name = "EXIT"; //for debugging
    acquire(&ptable.lock);
    // Parent might be sleeping in wait().
    wakeup1(curproc->parent->mainThread);

    // Pass abandoned children to init.
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->parent == curproc) {
            p->parent = initproc;
            if (p->state == ZOMBIE)
                wakeup1(initproc->mainThread);
        }
    }
    curthread->state = ZOMBIE;
    // Jump into the scheduler, never to return.
    curproc->state = ZOMBIE;
    sched();
    panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void) {
    if (DEBUGMODE > 1)
        cprintf(" WAIT ");
    struct proc *p;
    int havekids, pid;
    struct proc *curproc = myproc();
    struct thread *t;

    ptable.lock.name = "WAIT";
    acquire(&ptable.lock);
    for (;;) {
        // Scan through table looking for exited children.
        havekids = 0;
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->parent != curproc)
                continue;
            havekids = 1;
            if (p->state == ZOMBIE) {
                // Found one.
                pid = p->pid;
                //kfree for the stacks od the proc's threads
                for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                    if (t->state == ZOMBIE)
                        cleanThread(t);
                }
                freevm(p->pgdir);
                p->pid = 0;
                p->parent = 0;
                p->name[0] = 0;
                p->killed = 0;
                p->state = UNUSED;
                release(&ptable.lock);
                return pid;
            }
        }
        // No point waiting if we don't have any children.
        if (!havekids || myproc()->killed) {
            release(&ptable.lock);
            return -1;
        }
        if (mythread()->tkilled) {
            if (DEBUGMODE > 0)
                cprintf(" WAIT-mythread() ->tkilled ");
            release(&ptable.lock);
            kthread_exit();
            return -1;
        }
        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(mythread(), &ptable.lock);  //DOC: wait-sleep
    }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void) {
    if (DEBUGMODE > 0)
        cprintf(" SCHEDULER ");
    struct proc *p;
    struct cpu *c = mycpu();
    struct thread *t;
    c->proc = 0;

    for (;;) {
        // Enable interrupts on this processor.
        sti();

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);
        // Loop over process table looking for process to run.
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state != RUNNABLE)
                continue;

            c->proc = p;
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->state != RUNNABLE)
                    continue;

                t->state = RUNNING;
                c->currThread = t;

                // Switch to chosen process.  It is the process's job
                // to release ptable.lock and then reacquire it
                // before jumping back to us.
                switchuvm(p, t);

                swtch(&(c->scheduler), t->context);
                c->currThread = 0;

            }
            switchkvm();

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
            c->currThread = 0;
        }
        release(&ptable.lock);
    }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void) {
    if (DEBUGMODE > 1)
        cprintf(" SCHED ");
    int intena;
    struct thread *t = mythread();
    if (!holding(&ptable.lock))
        panic("sched ptable.lock");
    if (mycpu()->ncli != 1)
        panic("sched locks");
    if (t->state == RUNNING)
        panic("sched running");
    if (readeflags() & FL_IF)
        panic("sched interruptible");
    intena = mycpu()->intena;
    swtch(&t->context, mycpu()->scheduler);
    mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void) {
    ptable.lock.name = "YIELD";
    acquire(&ptable.lock);
    mythread()->state = RUNNABLE;
    sched();
    release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void) {
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);

    if (first) {
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot
        // be run from main().
        first = 0;
        iinit(ROOTDEV);
        initlog(ROOTDEV);
    }

    // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk) {
    if (DEBUGMODE > 1)
        cprintf(" SLEEP ");
    struct proc *p = myproc();
    struct thread *t = mythread();
    if (p == 0)
        panic("sleep");
    if (lk == 0)
        panic("sleep without lk");

    // Must acquire ptable.lock in order to
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if (lk != &ptable.lock) {
        ptable.lock.name = "SLEEP";
        acquire(&ptable.lock);
        release(lk);
    }
    // Go to sleep.
    t->chan = chan;
    t->state = SLEEPING;

    sched();

    // Tidy up.
    if(t->tkilled)
    {
        release(&ptable.lock);
        kthread_exit();
    }
    t->chan = 0;

    // Reacquire original lock.
    if (lk != &ptable.lock) {  //DOC: sleeplock2
        release(&ptable.lock);
        lk->name = "SLEEP2";
        acquire(lk);
    }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan) {
    struct proc *p;
    struct thread *t;
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != RUNNABLE)
            continue;
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
            if (t->state == SLEEPING && t->chan == chan)
                t->state = RUNNABLE;
        }
    }
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan) {
    if (DEBUGMODE > 1)
        cprintf(" WAKEUP ");
    char *aa = ptable.lock.name;
    ptable.lock.name = "WAKEUP"; //used for debugging
    ptable.lock.namee = aa;
    acquire(&ptable.lock);
    wakeup1(chan);
    release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid) {
    if (DEBUGMODE > 0)
        cprintf(" KILL ");
    struct proc *p;

    ptable.lock.name = "KILL";
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->pid == pid) {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING) {
                p->state = RUNNABLE;
                if (p->mainThread->state == SLEEPING)
                    p->mainThread->state = RUNNABLE;
            }
            release(&ptable.lock);
            return 0;
        }
    }
    release(&ptable.lock);
    return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void) {
    static char *states[] = {
            [UNUSED]    "unused",
            [EMBRYO]    "embryo",
            [SLEEPING]  "sleep ",
            [RUNNABLE]  "runble",
            [RUNNING]   "run   ",
            [ZOMBIE]    "zombie"
    };
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d %s %s", p->pid, state, p->name);
        if (p->mainThread->state == SLEEPING) {
            getcallerpcs((uint *) p->mainThread->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
    }
}


/********************************
        kthread
 ********************************/

int kthread_create(void (*start_func)(), void *stack) {
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_CREATE ");
    struct thread *t;
    struct thread *curthread = mythread();
    struct proc *p = myproc();
    char *sp;
    int i;

    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock); //find UNUSED thread in curproc
    for (t = p->thread, i = 0; t < &p->thread[NTHREADS]; i++, t++) {
        if( t->state == ZOMBIE && t->tkilled && t != p->mainThread && t != curthread ) {
            cleanThread(t);
        }
        if (t->state == UNUSED) {
            if (DEBUGMODE > 0)
                cprintf(" CLEAND THREAD NUM %d  \t\n" , i);
            goto foundThread2;
        }
    }
    //got here- didn't have a room for new thread
    if (DEBUGMODE > 0) { //debugging ->print all proc's thread states
        cprintf("Error - t->state == UNUSED)\n");
        for (t = p->thread; t < &p->thread[NTHREADS]; t++)
            cprintf("%d \t", t->state);
        cprintf("\n");
    }
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;
    t->tkilled = 0;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
        if (DEBUGMODE > 0)
            cprintf("Error - t->tkstack = kalloc()\n");
        release(&ptable.lock);
        return -1;
    }
    sp = t->tkstack + KSTACKSIZE;

    // Leave room for trap frame.
    sp -= sizeof *t->tf;
    t->tf = (struct trapframe *) sp;
    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
    *(uint *) sp = (uint) trapret;

    sp -= sizeof *t->context;
    t->context = (struct context *) sp;
    memset(t->context, 0, sizeof *t->context);
    t->context->eip = (uint) forkret;
    //copy trapframe from the current thread (like fork)
    memset(t->tf, 0, sizeof(*t->tf));
    //copy all fields except eip, esp
    t->tf->gs = curthread->tf->gs;
    t->tf->fs = curthread->tf->fs;
    t->tf->ss = curthread->tf->ss;
    t->tf->trapno = curthread->tf->trapno;
    t->tf->err = curthread->tf->err;
    t->tf->eflags = curthread->tf->eflags;
    t->tf->edx = curthread->tf->edx;
    t->tf->edi = curthread->tf->edi;
    t->tf->ebx = curthread->tf->ebx;
    t->tf->ecx = curthread->tf->ecx;
    t->tf->ebp = curthread->tf->ebp;
    t->tf->eax = curthread->tf->eax;
    t->tf->ds = curthread->tf->ds;
    t->tf->cs = curthread->tf->cs;
    t->tf->es = curthread->tf->es;
    t->tf->esi = curthread->tf->esi;
    t->tf->oesp = curthread->tf->oesp;
    t->tf->padding1 = curthread->tf->padding1;
    t->tf->padding2 = curthread->tf->padding2;
    t->tf->padding3 = curthread->tf->padding3;
    t->tf->padding4 = curthread->tf->padding4;
    t->tf->padding5 = curthread->tf->padding5;
    t->tf->padding6 = curthread->tf->padding6;

    t->tf->eip = (uint) start_func;  // beginning of run func
    t->tf->esp = (uint) stack; //beginning of user stack

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
    t->chan = 0;
    t->state = RUNNABLE;

    release(&ptable.lock);
    return t->tid;
}

int kthread_id() {
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_ID ");
    return mythread()->tid;
}


void kthread_exit() {
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_EXIT ");
    struct thread *t, *t1;
    struct thread *curthread = mythread();
    struct proc *p = myproc();
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state != UNUSED && t->state != ZOMBIE && t != curthread) {
            //found other thread ->close mythread
            if (curthread == p->mainThread) { //if (curthread == p->mainThread) -> set new mainThread
                for (t1 = p->thread; t1 < &p->thread[NTHREADS]; t1++) {
                    if (t1->state == RUNNABLE && t1 != curthread)
                        p->mainThread = t1;
                }
            }
            wakeup1(curthread);
            wakeup1(p);
            wakeup1(p->parent);
            curthread->state = ZOMBIE;
            sched(); //need to call this func while holding ptable.lock
            release(&ptable.lock);
            return;
        }
    }
    //if got here- curThread is the only thread ->exit
    release(&ptable.lock);
    exit();
}


int kthread_join(int thread_id) {
    if (DEBUGMODE > 0)
        cprintf(" KTHREAD_JOIN ");
    struct thread *t;
    struct proc *p = myproc();
    int foundFlag = 0;
    acquire(&ptable.lock);
    //only way to exit loop is via tid not found or t.state=UNUSED/ZOMBIE or got killed flag
    for (;;) {
        if( mythread()->tkilled ){
            release(&ptable.lock);
            kthread_exit();
        }
        if (foundFlag) //if true- no need to search again- goto foundTid
            goto foundTid;
        for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
            if (t->tid == thread_id) {
                foundFlag = 1; //found tidflag - reduce search in next iteration
                goto foundTid;
            }
        }

        //if got here - exit the loop and didn't find the thread tid
        release(&ptable.lock);
        return -1;

        foundTid:
        switch (t->state) {
            case ZOMBIE: //clean t and return 0
                t->state = UNUSED;
                t->tkilled = 0;
                release(&ptable.lock);
                if (t->tkstack != 0) {
                    kfree(t->tkstack);
                    t->tkstack = 0;
                }
                return 0;
            case UNUSED: //error - can't wait on thread that already exited
                if (DEBUGMODE > 0)
                    cprintf("kthread_join ERROR - waiting on UNUSED kthread\n");
                release(&ptable.lock);
                return -1;
            default: //all other options- thread not exited yet
                sleep(t, &ptable.lock);

        }
    }
}

/********************************
        kthread_mutex
 ********************************/

int
kthread_mutex_alloc() {
    struct kthread_mutex_t *m;
    //search a not active mutex
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (!m->active)
            goto alloc_mutex;
    }
    return -1; //if not found- return -1

    alloc_mutex: //if found- alloc a mutex
    if (DEBUGMODE > 0)
        cprintf("FOUND MUTEX THAT WILL GET ID %d   \n", mutexCounter);
    m->waitingCounter = 0;
    m->active = 1;
    m->mid = mutexCounter;
    m->locked = 0;
    m->thread = 0;
    mutexCounter += 1;
    if (DEBUGMODE > 0)
        cprintf("DONE ALLOC");
    return m->mid;
}

int
safe_tree_dealloc(int mutex_id) {
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->mid == mutex_id) { //search for specific mutex_id
            if (m->locked)
                return 0;
            else
                return 1;
        }
    }
    return 0;
}

int
kthread_mutex_dealloc(int mutex_id) {
    struct kthread_mutex_t *m;
    if (DEBUGMODE > 0)
        cprintf("MUTEX THAT WILL GET DEALLOC WITH ID %d   \n",mutex_id);
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->mid == mutex_id) {
            if (m->locked  || m->waitingCounter > 0 || !m->active ) {
                return -1;
            } else
                goto dealloc_mutex;
        }
    }
    return -1; //didn't find mutex_id

    dealloc_mutex: //if ound the mutex that need to dealloc- free the mutex
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    return 0;
}

int
kthread_mutex_lock(int mutex_id) {
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->active && m->mid == mutex_id) {
            while (m->locked) {
                //if curthread is the thread that try to lock -> error (deadlock)
                if(mythread() == m->thread)
                    return -1;
                m->waitingCounter++;
                acquire(&ptable.lock);
                sleep(m->thread, &ptable.lock); //go to sleep on this lock via sleep(m->thread
                release(&ptable.lock);
                m->waitingCounter--;
            }
            goto lock_mutex;
        }
    }
    return -1;

    lock_mutex:
    // The xchg is atomic.
    while (xchg(&m->locked, 1) != 0);

    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that the critical section's memory
    // references happen after the lock is acquired.
    __sync_synchronize();   // << TODO - not our line!!!

    // Record info about lock acquisition for debugging.
    m->thread = mythread();
    return 0;
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id) {
    struct kthread_mutex_t *m;
    for (m = myproc()->kthread_mutex_t; m < &myproc()->kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
            goto unlock_mutex;
    }
    return -1; //didn't find the mutex_id

    unlock_mutex://mutex_id was found

    m->pcs[0] = 0;
    m->thread = 0;

    // Tell the C compiler and the processor to not move loads or stores
    // past this point, to ensure that all the stores in the critical
    // section are visible to other cores before the lock is released.
    // Both the C compiler and the hardware may re-order loads and
    // stores; __sync_synchronize() tells them both not to.
    __sync_synchronize();

    // Release the lock, equivalent to lk->locked = 0.
    // This code can't use a C assignment, since it might
    // not be atomic. A real OS would use C atomics here.
    asm volatile("movl $0, %0" : "+m" (m->locked) : );

    wakeup(mythread());
    return 0;
}
