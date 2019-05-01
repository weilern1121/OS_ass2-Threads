#include "types.h"
#include "param.h"
#include "tournament_tree.h"
//#include "defs.h"
//#include "kthread.h"
//#include "defs.h"
//#include "memlayout.h"
//#include "mmu.h"
//#include "x86.h"
//#include "proc.h"
//#include "spinlock.h"

struct {
    //struct spinlock lock;
    trnmnt_tree trnmnt_tree[NPROC];
} treetable;

int ourpower(int num) {
    //Calculating 2^b
    if (num < 0) {
        //cprintf("Illegal input: for a^b: a= %d, b= %d \n", a, b);
        return -1;
    }
    int output = 1;
    for (int i = 0; i < num; i++)
        output *= 2;
    return output;
}

struct trnmnt_tree*
trnmnt_tree_alloc(int depth){
    trnmnt_tree *t;//= (struct trnmnt_tree *) kalloc();

    for (t = treetable.trnmnt_tree ; t < &treetable.trnmnt_tree[NPROC] ; t++) {
        if (t->active == INACTIVE)
            goto found_tree;
    }
    return 0;

    found_tree:
    t->active = ACTIVE;
    t->depth = depth;

    for(int i=0; i<(ourpower(depth)-1); i++)
        t->trnmntMutex[i] = kthread_mutex_alloc();

    return t;
}

int
trnmnt_tree_dealloc(trnmnt_tree* tree){
    if(tree->active == INACTIVE )
        return -1;


    for(int i=0; i<(ourpower(tree->depth)-1); i++){
        if(kthread_mutex_dealloc(tree->trnmntMutex[i]) == -1 )
            return -1;
    }

    tree->depth=0;
    tree->active = INACTIVE;

    return 0;
}

int
trnmnt_tree_acquire(trnmnt_tree* tree,int ID){
    int x=0, localID=ID;
    for(int lvl=1; lvl<=tree->depth; lvl++){
        localID= localID/2;     //wich lock try to lock in current level
        if(kthread_mutex_lock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //lock ->if not succeed sleep (in mutex implementation)
        x+=((ourpower(tree->depth))/(ourpower(lvl))); //move x to point to the next level for localID
    }
    return 0;
}

int
trnmnt_tree_release(trnmnt_tree* tree,int ID){
    int x=ourpower(tree->depth)-2, localID;
    for(int lvl=tree->depth; lvl>=1; lvl--){
        localID= ID/ourpower(lvl);     //wich lock try to lock in current level
        if(kthread_mutex_unlock(tree->trnmntMutex[x+localID]) == -1)
            return -1; //unlock ->if not curthead holds this lock -> return -1 (in mutex implementation)
        x -= ourpower(tree->depth-lvl+1); //move x to point to the next level for localID
    }
    return 0;
}

