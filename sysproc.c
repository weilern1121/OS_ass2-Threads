#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void) {
    return fork();
}

int
sys_exit(void) {
    exit();
    return 0;  // not reached
}

int
sys_wait(void) {
    return wait();
}

int
sys_kill(void) {
    int pid;

    if (argint(0, &pid) < 0)
        return -1;
    return kill(pid);
}

int
sys_getpid(void) {
    return myproc()->pid;
}

int
sys_sbrk(void) {
    int addr;
    int n;

    if (argint(0, &n) < 0)
        return -1;
    addr = myproc()->sz;
    if (growproc(n) < 0)
        return -1;
    return addr;
}

int
sys_sleep(void) {
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
        return -1;
    acquire(&tickslock);
    ticks0 = ticks;
    while (ticks - ticks0 < n) {
        if (myproc()->killed) {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    }
    release(&tickslock);
    return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void) {
    uint xticks;

    acquire(&tickslock);
    xticks = ticks;
    release(&tickslock);
    return xticks;
}

//kthread syscalls
int
sys_kthread_create(void) {
    void (*start_func)() = 0;
    void *stack = 0;
//    if (argptr(0, (void *) start_func, sizeof(*start_func)) < 0)
//        return -1;
//    if (argptr(0, stack, sizeof(*stack)) < 0)
//        return -1;
    if (argint(0, (int *) &start_func) < 0)
        return -1;
    if (argint(1, (int *) &stack) < 0)
        return -1;
    return kthread_create(start_func, stack);
}

int
sys_kthread_id(void) {
    return mythread()->tid;
}

int
sys_kthread_exit(void) {
    kthread_exit();
    return 0;
}

int
sys_kthread_join(void) {
    int tid;
    if (argint(0, &tid) < 0)
        return -1;
    return kthread_join(tid);
}

//kthread_mutex syscalls
int
sys_kthread_mutex_alloc(void) {
    return kthread_mutex_alloc();
}

int
sys_kthread_mutex_dealloc(void) {
    int tid;
    if (argint(0, &tid) < 0)
        return -1;
    return kthread_mutex_dealloc(tid);
}

int
sys_kthread_mutex_lock(void) {
    int tid;
    if (argint(0, &tid) < 0)
        return -1;
    return kthread_mutex_lock(tid);
}

int
sys_kthread_mutex_unlock(void) {
    int tid;
    if (argint(0, &tid) < 0)
        return -1;
    return kthread_mutex_unlock(tid);
}

int
sys_safe_tree_dealloc(void) {
    int tid;
    if (argint(0, &tid) < 0)
        return -1;
    return safe_tree_dealloc(tid);
}

/*
//trnmnt_tree syscalls
struct trnmnt_tree *
sys_trnmnt_tree_alloc(void) {
    int depth;
    if (argint(0, &depth) < 0)
        return 0; //if 0 ->error
    return trnmnt_tree_alloc(depth);
}

int
sys_trnmnt_tree_dealloc(void) {
    struct trnmnt_tree *tree = 0;
    if (argptr(0, (char **) tree, sizeof(*tree)) < 0)
        return -1;
    return trnmnt_tree_dealloc(tree);
}

int
sys_trnmnt_tree_acquire(void) {
    struct trnmnt_tree *tree = 0;
    int ID;
    if (argptr(0, (char **) tree, sizeof(*tree)) < 0)
        return -1;
    if (argint(0, &ID) < 0)
        return -1;
    return trnmnt_tree_acquire(tree, ID);
}

int
sys_trnmnt_tree_release(void){
    struct trnmnt_tree *tree = 0;
    int ID;
    if (argptr(0, (char **) tree, sizeof(*tree)) < 0)
        return -1;
    if (argint(0, &ID) < 0)
        return -1;
    return trnmnt_tree_release(tree, ID);
}
 */
