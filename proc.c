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

struct {
    struct spinlock lock;
    struct kthread_mutex_t kthread_mutex_t[MAX_MUTEXES];
} mtable;

static struct proc *initproc;

int nextpid = 1;

int tidCounter = 1;

int mutexCounter = 1;

int DEBUGMODE = 0; //0-off , 1- without SLEEP & WAKEUP & SCHED , 2-all commands

extern void forkret(void);

extern void trapret(void);

static void wakeup1(void *chan);

extern void cleanProcOneThread(struct thread *curthread, struct proc *p);

void
pinit(void) {
    if (DEBUGMODE > 0)
        cprintf(" PINIT ");
    initlock(&ptable.lock, "ptable");
    initlock(&mtable.lock, "mtable");
}

//must be called under acquire(&ptable.lock); !!
void
cleanThread(struct thread *t) {
    if( t->tkstack != 0){
        kfree(t->tkstack);
        t->tkstack = 0;
    }
    t->state = UNUSED;
    t->tid = 0;
    t->name[0] = 0;
//    t->killed = 0;
    //clean trap frame and context
    memset(t->tf, 0, sizeof(*t->tf));
    memset(t->context, 0, sizeof(*t->context));
}

void
cleanProcOneThread(struct thread *curthread, struct proc *p) {

    struct thread *t;
    // Remove threads (except of the exec thread)
    ptable.lock.name = "CLEANPROCONETHREAD";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t != curthread && t->state != UNUSED) {
            if (t->state == RUNNING)
                sleep(t, &ptable.lock);

            cleanThread(t);

        }
    }
    p->mainThread = curthread;
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


    //TODO - from here- thread alloc

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

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        p->pid = 0;
        p->state = UNUSED;
        t->tid = 0;
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
        cprintf("DONE USERINIT");

}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n) {
    uint sz;
    struct proc *curproc = myproc();
    if (DEBUGMODE > 0)
        cprintf(" GROWPROC APPLYED ");

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
        cprintf(" \n GROWPROC DONE ");
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

    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
    //TODO
    safestrcpy(np->mainThread->name, curthread->name, sizeof(curthread->name));

    pid = np->pid;

    ptable.lock.name = "FORK";
    acquire(&ptable.lock);

    np->state = RUNNABLE;
    //TODO
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
    //struct thread *t;
    struct thread *curthread = mythread();
    int fd;
    if (DEBUGMODE > 0)
        cprintf("EXIT");
    if (curproc == initproc)
        panic("init exiting");


    cleanProcOneThread(curthread, curproc);



    //When got here - the only thread that is RUNNINNg is curThread
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

    ptable.lock.name = "EXIT";
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

    //TODO- where to unlock
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
                    if (t->state != UNUSED)
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

        // Loop over process table looking for process to run.

        ptable.lock.name = "SCHEDUALER";
        acquire(&ptable.lock);

        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if (p->state != RUNNABLE)
                continue;

            // Switch to chosen process.  It is the process's job
            // to release ptable.lock and then reacquire it
            // before jumping back to us.

            //cprintf("\n  FOUND PROC TO RUN %d in cpu %d" , p->pid , c->apicid);
            c->proc = p;
//TODO            switchuvm(p);
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->state != RUNNABLE)
                    continue;

                //cprintf("\n  FOUND TRED TO RUN %d" , t->tid);
                t->state = RUNNING;
                c->currThread = t;
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
    //TODO - maybe need to change to mainThread->context
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
    // TODO sych problemss!!!

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
    ptable.lock.name = "WAKEUP";
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
            //turn on killed flags of the proc threads
//            for (t = p->thread; t < &p->thread[NTHREADS]; t++)
//                t->killed = 1;
            // Wake process from sleep if necessary.

            if (p->state == SLEEPING) {
                p->state = RUNNABLE;
                if (p->mainThread->state == SLEEPING)
                    p->mainThread->state = RUNNABLE;
//                p->mainThread->killed = 0; //turn off this flag so that the main thread will exit the proc
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

//TODO - need to update stack
int kthread_create(void (*start_func)(), void *stack) {
    struct thread *t;
    struct thread *curthread=mythread();
    struct proc *p = myproc();
    char *sp;
    ptable.lock.name = "KTHREADCREATE";
    acquire(&ptable.lock); //find UNUSED thread in curproc
    for (t = p->thread; t < &p->thread[NTHREADS]; t++)
        if (t->state == UNUSED)
            goto foundThread2;
    //got here- didn't have a room for new thread
    release(&ptable.lock);
    return -1;

    foundThread2:
    t->state = EMBRYO;
    t->tid = tidCounter++;

    // Allocate kernel stack.
    if ((t->tkstack = kalloc()) == 0) {
        t->state = UNUSED;
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
    //TODO - copy trapframe from the current thread (like fork)
    memset(t->tf, 0, sizeof(*t->tf));
    //copy all fields except eip, esp
    t->tf->gs=curthread->tf->gs;
    t->tf->fs=curthread->tf->fs;
    t->tf->ss=curthread->tf->ss;
    t->tf->trapno=curthread->tf->trapno;
    t->tf->err=curthread->tf->err;
    t->tf->eflags=curthread->tf->eflags;
    t->tf->edx=curthread->tf->edx;
    t->tf->edi=curthread->tf->edi;
    t->tf->ebx=curthread->tf->ebx;
    t->tf->ecx=curthread->tf->ecx;
    t->tf->ebp=curthread->tf->ebp;
    t->tf->eax=curthread->tf->eax;
    t->tf->ds=curthread->tf->ds;
    t->tf->cs=curthread->tf->cs;
    t->tf->es=curthread->tf->es;
    t->tf->esi=curthread->tf->esi;
    t->tf->oesp=curthread->tf->oesp;
    t->tf->padding1=curthread->tf->padding1;
    t->tf->padding2=curthread->tf->padding2;
    t->tf->padding3=curthread->tf->padding3;
    t->tf->padding4=curthread->tf->padding4;
    t->tf->padding5=curthread->tf->padding5;
    t->tf->padding6=curthread->tf->padding6;

    t->tf->eip = (uint) start_func;  // beginning of run func
    t->tf->esp= (uint) stack; //beginning of user stack

/*    memset(t->tf, 0, sizeof(*t->tf));
    t->tf->cs = (SEG_UCODE << 3) | DPL_USER;
    t->tf->ds = (SEG_UDATA << 3) | DPL_USER;
    t->tf->es = t->tf->ds;
    t->tf->ss = t->tf->ds;
    t->tf->eflags = FL_IF;
    t->tf->esp = PGSIZE;
    t->tf->eip = (uint) start_func;  // beginning of run func
*/

    safestrcpy(t->name, myproc()->name, sizeof(myproc()->name));
    //t->cwd = namei("/");

//    t->killed = 0;
    t->chan = 0;
    //t->start_func=start_func; //TODO - not sure that need this line and field
    t->state = RUNNABLE;

    release(&ptable.lock);
    return 0;
}

//this func haven't been used - it's implementation is in sysproc
int kthread_id() {
    return mythread()->tid;
}

void kthread_exit() {

    struct thread *t;
    struct proc *p = myproc();
    int counter = 0;
    ptable.lock.name = "KTHREADEXIT";
    acquire(&ptable.lock);
    for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
        if (t->state != RUNNABLE && t->state != RUNNING)
            counter++;
    }

    if (counter == (NTHREADS - 1)) { //all other threads aren't available -> close proc
        release(&ptable.lock);
        exit();
    } else {   //there are other threads in the same proc - close just the specific thread
        cleanThread(t);
        t->state=ZOMBIE;
        //sched(); //TODO- need to call this func while holding ptable.lock
        release(&ptable.lock);
    }
}

int kthread_join(int thread_id) {
    struct thread *t;
    struct proc *p;
    acquire(&ptable.lock);
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
        if (p->state != UNUSED) {
            for (t = p->thread; t < &p->thread[NTHREADS]; t++) {
                if (t->tid == thread_id)
                    goto found2;
            }
        }
    }
    //if got here - exit the loop and didn't find the thread tid
    release(&ptable.lock);
    return -1;

    found2:
    if (t->state == UNUSED || t->state == ZOMBIE) {
        release(&ptable.lock);
        return -1;
    }
    sleep(t, &ptable.lock);
    //TODO - not sure about release
    if (holding(&ptable.lock))
        release(&ptable.lock);
    return 0;
}

/********************************
        kthread_mutex
 ********************************/

int
kthread_mutex_alloc() {
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (!m->active)
            goto alloc_mutex;
    }

    release(&mtable.lock);
    return -1;

    alloc_mutex:
    m->waitingCounter = 0;
    m->active = 1;
    m->mid = mutexCounter++;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
    return m->mid;


}


int
kthread_mutex_dealloc(int mutex_id) {
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->mid == mutex_id) {
            if (m->locked || m->waitingCounter > 0) {
                release(&mtable.lock);
                return -1;
            } else
                goto dealloc_mutex;
        }
    }

    release(&mtable.lock);
    return -1;

    dealloc_mutex:
    m->active = 0;
    m->mid = -1;
    m->locked = 0;
    m->thread = 0;
    release(&mtable.lock);
    return 0;
}


// Record the current call stack in pcs[] by following the %ebp chain.
// TODO NOT OUR CODE MIGHT BE REMOVED
void
mgetcallerpcs(void *v, uint pcs[]) {
    uint *ebp;
    int i;

    ebp = (uint *) v - 2;
    for (i = 0; i < 10; i++) {
        if (ebp == 0 || ebp < (uint *) KERNBASE || ebp == (uint *) 0xffffffff)
            break;
        pcs[i] = ebp[1];     // saved %eip
        ebp = (uint *) ebp[0]; // saved %ebp
    }
    for (; i < 10; i++)
        pcs[i] = 0;
}

// Pushcli/popcli are like cli/sti except that they are matched:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
mpushcli(void) {
    int eflags;

    eflags = readeflags();
    cli();
    if (mycpu()->ncli == 0)
        mycpu()->intena = eflags & FL_IF;
    mycpu()->ncli += 1;
}

void
mpopcli(void) {
    if (readeflags() & FL_IF)
        panic("popcli - interruptible");
    if (--mycpu()->ncli < 0)
        panic("popcli");
    if (mycpu()->ncli == 0 && mycpu()->intena)
        sti();
}


int
kthread_mutex_lock(int mutex_id) {
    struct kthread_mutex_t *m;

    mpushcli(); // disable interrupts to avoid deadlock.  << TODO - not our line!!!

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->active && m->mid == mutex_id) {
            if (m->locked) {
                m->waitingCounter++;
                sleep(m->thread, &mtable.lock);
                m->waitingCounter--;
            }
            goto lock_mutex;
        }
    }

    release(&mtable.lock);
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
    mgetcallerpcs(&m, m->pcs);
    release(&mtable.lock);
    return 0;
}

// Release the lock.
int
kthread_mutex_unlock(int mutex_id) {
    struct kthread_mutex_t *m;

    acquire(&mtable.lock);

    for (m = mtable.kthread_mutex_t; m < &mtable.kthread_mutex_t[MAX_MUTEXES]; m++) {
        if (m->active && m->mid == mutex_id && m->locked && m->thread == mythread())
            goto unlock_mutex;
    }

    release(&mtable.lock);
    return -1;

    unlock_mutex:

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
    mpopcli();
    return 0;
}

/********************************
        trnmnt_tree
 ********************************/
/*
int pow(int a, int b) {
    //Calculating a^b
    if (a < 0 || b < 0) {
        cprintf("Illegal input: for a^b: a= %d, b= %d \n", a, b);
        return -1;
    }
    int output = 1;
    for (int i = 0; i < b; i++)
        output *= a;
    return output;
}

struct trnmnt_tree*
trnmnt_tree_alloc(int depth){
    struct trnmnt_tree *t= (struct trnmnt_tree *) kalloc();

    initlock(t->lock,"treeLock");
    t->depth=depth;
    for(int i=0; i<((2^depth)-1); i++)
        t->trnmntMutex[i] = kthread_mutex_alloc();
    return t;
}

int
trnmnt_tree_dealloc(struct trnmnt_tree* tree){
    for(int i=0; i<(pow(2,tree->depth)-1); i++){
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) ==-1)
            return -1;
    }
    tree->depth=0;
    kfree((char *) tree);
    return 0;
}

int
trnmnt_tree_acquire(struct trnmnt_tree* tree,int ID){
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
        localID= localID/2;     //wich lock try to lock in current level
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((pow(2,tree->depth))/(pow(2,lvl))); //move x to point to the next level for localID
    }
    return 0;
}

int
trnmnt_tree_release(struct trnmnt_tree* tree,int ID){
    int x=pow(2,tree->depth)-2, localID;
    for(int lvl=tree->depth; lvl>=1; lvl--){
        localID= ID/pow(2,lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= pow(2,(tree->depth-lvl+1)); //move x to point to the next level for localID
    }
    return 0;
}
*/