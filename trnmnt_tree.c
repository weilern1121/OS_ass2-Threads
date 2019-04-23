#include "types.h"
#include "param.h"
#include "trnmnt_tree.h"
#include "defs.h"
#include "kthread.h"
/*
int power(int a, int b) {
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

    initlock(&t->lock,"treeLock");
    t->depth=depth;
    for(int i=0; i<((2^depth)-1); i++)
        t->trnmntMutex[i] = kthread_mutex_alloc();
    return t;
}

int
trnmnt_tree_dealloc(struct trnmnt_tree* tree){
    for(int i=0; i<(power(2,tree->depth)-1); i++){
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
        x+=((power(2,tree->depth))/(power(2,lvl))); //move x to point to the next level for localID
    }
    return 0;
}

int
trnmnt_tree_release(struct trnmnt_tree* tree,int ID){
    int x=power(2,tree->depth)-2, localID;
    for(int lvl=tree->depth; lvl>=1; lvl--){
        localID= ID/power(2,lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= power(2,(tree->depth-lvl+1)); //move x to point to the next level for localID
    }
    return 0;
}
*/
