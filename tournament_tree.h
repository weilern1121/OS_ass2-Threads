//#include "proc.h"
#include "spinlock.h"

struct trnmnt_tree{
    struct spinlock lock;           //spinlock
    int depth;                      //tree depth
    int trnmntMutex[MAX_MUTEXES];    // mutex array
    //TODO - maybe need to add boolean array
};
