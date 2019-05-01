//#include "proc.h"
//#include "spinlock.h"

enum treestate { INACTIVE, ACTIVE };

struct trnmnt_tree{
    //struct spinlock lock;           //spinlock
    enum treestate active;
    int depth;                      //tree depth
    int trnmntMutex[MAX_MUTEXES];    // mutex array
    //TODO - maybe need to add boolean array
};
