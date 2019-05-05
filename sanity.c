#include "types.h"
#include "stat.h"
#include "user.h"

#define NTHREADS       16  // max num of threads per proc
volatile int kthreadsRunFlag = 0; //flag for test 2.2

/********** 2.1 tests  **********/
//test fork,exit and wait
int test_21_1(void) {
    int pid, i = 0, counter = 0;
    for (; i < 50; i++) {
        pid = fork();
        if (pid < 0) {
            printf(1, "ERROR- fork\n");
            exit();
        } else if (pid == 0)
            exit();
        else counter++;
    }

    for (i = 0; i < 50; i++) {
        if (wait() < 0) {
            printf(1, "ERROR- wait\n");
            exit();
        } else
            counter--;
    }

    if (wait() != -1) { //there are not more procs to wait for
        printf(1, "ERROR- wait - can't wait without proc\n");
        counter--;
//        exit();
        return 0;
    }
    return counter == 0; //return 1 if closed well
}

//test fork, exec and exit
void test_21_2(void) {
    int pid;
    char *args[] = {"Test", "2.1", "Passed!", 0}; //final print of test 2.1
    char *command = "echo"; //command name for the exec
    if ((pid = fork()) == 0) {
        if (exec(command, args) < 0) { //exec return -1 if failed
            //should exit via exec. if got here- error
            printf(1, "ERROR- exec\n");
            exit();
        }
    } else if (pid > 0) { //wait for children to finish execution
        wait();
    } else {
        printf(1, "fork failed\n");
        exit();
    }
}

/********** 2.2 tests  **********/
#define STACK_SIZE 250
int tid_arr[6]; //used to kthread_join func
#define THREAD_FUNC1(name, tid) \
    void name(){ \
        while(kthreadsRunFlag){}  \
        sleep(80000000);\
    }\

#define THREAD_FUNC2(name, tid) \
    void name(){ \
        while(kthreadsRunFlag){}  \
        if(kthread_id()==2){ \
            sleep(100000000);\
        }\
    }\

#define THREAD_FUNC3(name, tid) \
    void name(){ \
        while(kthreadsRunFlag){}  \
            kthread_join(tid_arr[tid]);\
    }\

#define THREAD_FUNC4(name, tid) \
    void name(){ \
        while(kthreadsRunFlag){}  \
            kthread_join(tid_arr[tid]);\
    }\

#define THREAD_FUNC5(name, tid) \
    void name(){ \
            while(kthreadsRunFlag){}  \
            if( kthread_id()!=tid)\
                printf(1,"\nERROR- kthread_id()!=tid\n");\
            kthread_join(tid_arr[tid]);\
    }\

#define THREAD_FUNC6(name, tid) \
    void name(){ \
            while(kthreadsRunFlag){}  \
            kthread_join(tid_arr[2]);\
    }\

THREAD_FUNC1(kthread1, 1)
THREAD_FUNC2(kthread2, 2)
THREAD_FUNC3(kthread3, 3)
THREAD_FUNC4(kthread4, 4)
THREAD_FUNC5(kthread5, 5)
THREAD_FUNC6(kthread6, 6)

void (*threads_starts[])(void) =
        {kthread1,kthread2,kthread3,kthread4,kthread5,kthread6};

int init_kthreads(void){
    int checkFlag=0;
    kthreadsRunFlag = 1; //flag the threads funcs that they can start execute their code
    //malloc the tk_stacks for each kthread
    void *tkaddr1 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;
    void *tkaddr2 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;
    void *tkaddr3 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;
    void *tkaddr4 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;
    void *tkaddr5 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;
    void *tkaddr6 = ((char *)malloc(STACK_SIZE*sizeof(char)))+STACK_SIZE;

    void (*tk_stacks[])(void) =
            {tkaddr1,tkaddr2,tkaddr3,tkaddr4,tkaddr5,tkaddr6};

    for(int i=0; i<6; i++){
        checkFlag=kthread_create(threads_starts[i],tk_stacks[i]);
        if(checkFlag<0)
            return -1;
    }

    kthreadsRunFlag = 0; //flag the threads to not enter theirs funcs from here

    return 1;

}
void run_test(int testNum) {
    int tmp = 0;
    switch (testNum) {
        case 21:
            printf(1, "Start test 2.1\n");
            if (test_21_1())
                test_21_2();
            else
                printf(1, "Failed in test 2.1\n");
            break;
        case 22:
            printf(1, "Start test 2.2\n");
            tmp=init_kthreads();
            printf(1, tmp ? "Test 2.2 Passed!\n" :  "Test 2.2 Failed!\n");
            break;
        default:
            printf(2, "ERROR- wrong test_ID %d \n", testNum);
            return;
    }
}

int main(int argc, char *argv[]) {
    run_test(21);
    run_test(22);

    exit();
}
