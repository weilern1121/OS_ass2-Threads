#include "../../param.h"
#include "../../types.h"
#include "../../stat.h"
#include "../../user.h"
#include "../../fs.h"
#include "../../fcntl.h"
#include "../../syscall.h"
#include "../../traps.h"
#include "../../memlayout.h"
#include "../../tournament_tree.h"
#include "../../kthread.h"

#define THREAD_NUM 10
#define STACK_SIZE 500

#define THREAD_START(name, id) \
    void name(){ \
        sleep( id * 100); \
        printf(1,"thread %d entering\n", id ); \
        printf(1,"thread %d exiting\n", id ); \
        kthread_exit(); \
    }

#define THREAD_STACK(name) \
    void * name = ((char *) malloc(STACK_SIZE * sizeof(char))) + STACK_SIZE;

THREAD_START(threadStart_1, 1)
THREAD_START(threadStart_2, 2)
THREAD_START(threadStart_3, 3)
THREAD_START(threadStart_4, 4)
THREAD_START(threadStart_5, 5)
THREAD_START(threadStart_6, 6)
THREAD_START(threadStart_7, 7)
THREAD_START(threadStart_8, 8)
THREAD_START(threadStart_9, 9)
THREAD_START(threadStart_10, 10)

void (*threads_starts[])(void) = 
    {threadStart_1,
     threadStart_2,
     threadStart_3,
     threadStart_4,
     threadStart_5,
     threadStart_6,
     threadStart_7,
     threadStart_8,
     threadStart_9,
     threadStart_10};

int main(int argc, char *argv[]){
    THREAD_STACK(threadStack_1)
    THREAD_STACK(threadStack_2)
    THREAD_STACK(threadStack_3)
    THREAD_STACK(threadStack_4)
    THREAD_STACK(threadStack_5)
    THREAD_STACK(threadStack_6)
    THREAD_STACK(threadStack_7)
    THREAD_STACK(threadStack_8)
    THREAD_STACK(threadStack_9)
    THREAD_STACK(threadStack_10)

    void (*threads_stacks[])(void) = 
    {threadStack_1,
     threadStack_2,
     threadStack_3,
     threadStack_4,
     threadStack_5,
     threadStack_6,
     threadStack_7,
     threadStack_8,
     threadStack_9,
     threadStack_10};

    for(int i = 0;i < THREAD_NUM;i++){
        kthread_create(threads_starts[i], threads_stacks[i]);
    }

    sleep(2000);

    exit();
}

