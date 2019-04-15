#define MAX_STACK_SIZE 4000
#define MAX_MUTEXES 64

#include "spinlock.h"
#include "proc.h"

struct trnmnt_tree{
    struct spinlock lock;           //spinlock
    int depth;                      //tree depth
    int trnmntMutex[MAX_MUTEXES];    // mutex array
    //TODO - maybe need to add boolean array
};
