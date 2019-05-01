#include "user.h"

enum treestate { INACTIVE, ACTIVE };

typedef struct trnmnt_tree
{
    enum treestate active;
    int depth;                      //tree depth
    int trnmntMutex[MAX_MUTEXES];    // mutex array
    //TODO - maybe need to add boolean array
}trnmnt_tree;
