#include "tournament_tree.h"
#include "defs.h"
#include "proc.c"

extern struct trnmnt_tree* trnmnt_tree_alloc(int depth);
extern int trnmnt_tree_dealloc(struct trnmnt_tree* tree);
extern int trnmnt_tree_acquire(struct trnmnt_tree* tree,int ID);
extern int trnmnt_tree_release(struct trnmnt_tree* tree,int ID);

struct
trnmnt_tree* trnmnt_tree_alloc(int depth){
    struct trnmnt_tree *t;
    initlock(&t->lock,"treeLock");
    t->depth=depth;
    for(int i=0; i<((2^depth)-1); i++)
        t->trnmntMutex[i] = kthread_mutex_alloc();
}

int
trnmnt_tree_dealloc(struct trnmnt_tree* tree){
    for(int i=0; i<((2^tree->depth)-1); i++){
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) ==-1)
            return -1;
    }
    tree->depth=0;
    return 0;
}

int
trnmnt_tree_acquire(struct trnmnt_tree* tree,int ID){
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
        localID= localID/2;     //wich lock try to lock in current level
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((2^tree->depth)/(2^lvl)); //move x to point to the next level for localID
    }
    return 0;
}

int
trnmnt_tree_release(struct trnmnt_tree* tree,int ID){
    int x=(2^tree->depth)-2, localID=1;
    for(int lvl=tree->depth; lvl>=1; lvl--){
        localID= ID/(2^lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x-=((2^tree->depth)/((2^lvl)-1)); //move x to point to the next level for localID
    }
    return 0;
}
