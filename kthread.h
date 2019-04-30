#define MAX_STACK_SIZE 4000
#define MAX_MUTEXES 64

/********************************
        The API of the KLT package
 ********************************/

int kthread_create(void (*start_func)(), void* stack);
int kthread_id();
void kthread_exit();
int kthread_join(int thread_id);
int kthread_mutex_alloc();
int kthread_mutex_dealloc(int mutex_id);
int kthread_mutex_lock(int mutex_id);
int kthread_mutex_unlock(int mutex_id);

struct trnmnt_tree* trnmnt_tree_alloc(int depth);
int trnmnt_tree_dealloc(struct trnmnt_tree* tree);
int trnmnt_tree_acquire(struct trnmnt_tree* tree,int ID);
int trnmnt_tree_release(struct trnmnt_tree* tree,int ID);


//struct kthread_mutex_t {
//    uint locked;       // Is the lock held?
//    int active;        // Is the Mutex been init?
//    int mid;
//    // For debugging:
//    struct thread *thread;   // The cpu holding the lock.
//    // TODO we are not sure about this line but it doesnt affect us now;
//    uint pcs[10];      // The call stack (an array of program counters)
//    // that locked the lock.
//};