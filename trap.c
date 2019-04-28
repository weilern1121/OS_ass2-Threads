#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void) {
    int i;

    for (i = 0; i < 256; i++) SETGATE(idt[i], 0, SEG_KCODE << 3, vectors[i], 0);
    SETGATE(idt[T_SYSCALL], 1, SEG_KCODE << 3, vectors[T_SYSCALL], DPL_USER);

    initlock(&tickslock, "time");
}

void
idtinit(void) {
    lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf) {
    if (tf->trapno == T_SYSCALL) {
        if (myproc()->killed)
            exit();
        if (mythread()->tkilled) {
            cprintf("TRAP EXIT0 \n");
            if(DEBUGMODE > 0)
                cprintf("mythread()->tkilled == 1 --> kthread_exit()\n");
            kthread_exit();
        }
        mythread()->tf = tf;
        syscall();
        if (myproc()->killed)
            exit();
        if (mythread()->tkilled) {
            cprintf("TRAP EXIT \n");
            if(DEBUGMODE > 0)
                cprintf("mythread()->tkilled == 1 --> kthread_exit()\n");
            kthread_exit();
        }
        return;
    }



    switch (tf->trapno) {
        case T_IRQ0 + IRQ_TIMER:
            if (cpuid() == 0) {
                acquire(&tickslock);
                ticks++;
                wakeup(&ticks);
                release(&tickslock);
            }
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE:
            ideintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_IDE + 1:
            // Bochs generates spurious IDE1 interrupts.
            break;
        case T_IRQ0 + IRQ_KBD:
            kbdintr();
            lapiceoi();
            break;
        case T_IRQ0 + IRQ_COM1:
            uartintr();
            lapiceoi();
            break;
        case T_IRQ0 + 7:
        case T_IRQ0 + IRQ_SPURIOUS:
            cprintf("cpu%d: spurious interrupt at %x:%x\n",
                    cpuid(), tf->cs, tf->eip);
            lapiceoi();
            break;

            //PAGEBREAK: 13
        default:
            /*if (mythread() && mythread()->tkilled) {
                if(DEBUGMODE > 0)
                    cprintf("mythread()->tkilled == 1 --> kthread_exit()  #2\n");
                kthread_exit();
                return;
            }*/
            if (myproc() == 0 || (tf->cs & 3) == 0) {
                // In kernel, it must be our mistake.
                cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
                        tf->trapno, cpuid(), tf->eip, rcr2());
                panic("trap");
            }
            // In user space, assume process misbehaved.
            cprintf("pid %d %s: trap %d err %d on cpu %d "
                    "eip 0x%x addr 0x%x--kill proc\n",
                    myproc()->pid, myproc()->name, tf->trapno,
                    tf->err, cpuid(), tf->eip, rcr2());
            myproc()->killed = 1;
            mythread()->tkilled=1;
    }

    // Force process exit if it has been killed and is in user space.
    // (If it is still executing in the kernel, let it keep running
    // until it gets to the regular system call return.)
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();


    // Force process to give up CPU on clock tick.
    // If interrupts were on while locks held, would need to check nlock.
    if (myproc() && myproc()->state == RUNNING &&
        tf->trapno == T_IRQ0 + IRQ_TIMER) {
        yield();
    }

    if(mythread() && mythread()->tkilled){
        //cprintf("TRAP EXIT 2\n");
        if(DEBUGMODE > 0)
            cprintf("mythread() && mythread()->tkilled)\n");
        //cleanThread( mythread() );
        kthread_exit();

    }

    // Check if the process has been killed since we yielded
    if (myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
        exit();

    // Check if the thread has been killed since we yielded
    if (mythread() && mythread()->tkilled && (tf->cs & 3) == DPL_USER){
        cprintf("TRAP EXIT 3\n");
        if(DEBUGMODE > 0)
            cprintf("the thread has been killed since we yielded -> kthread_exit()\n");
        kthread_exit();
    }
}
