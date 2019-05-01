struct stat;
struct rtcdate;

// system calls
int fork(void);
int exit(void) __attribute__((noreturn));
int wait(void);
int pipe(int*);
int write(int, const void*, int);
int read(int, void*, int);
int close(int);
int kill(int);
int exec(char*, char**);
int open(const char*, int);
int mknod(const char*, short, short);
int unlink(const char*);
int fstat(int fd, struct stat*);
int link(const char*, const char*);
int mkdir(const char*);
int chdir(const char*);
int dup(int);
int getpid(void);
char* sbrk(int);
int sleep(int);
int uptime(void);

//kthread syscalls
int kthread_create(void (*start_func)(), void* );
int kthread_id();
void kthread_exit();
void kthread_exit_trap();
int kthread_join(int);

//kthread_mutex syscalls
int kthread_mutex_alloc(void);
int kthread_mutex_dealloc(int);
int kthread_mutex_lock(int);
int kthread_mutex_unlock(int);

/*//trnmnt_tree.c

trnmnt_tree* trnmnt_tree_alloc(int);
int trnmnt_tree_dealloc(trnmnt_tree*);
int trnmnt_tree_acquire(trnmnt_tree* ,int);
int trnmnt_tree_release(trnmnt_tree* ,int);*/

// ulib.c
int stat(const char*, struct stat*);
char* strcpy(char*, const char*);
void *memmove(void*, const void*, int);
char* strchr(const char*, char c);
int strcmp(const char*, const char*);
void printf(int, const char*, ...);
char* gets(char*, int max);
uint strlen(const char*);
void* memset(void*, int, uint);
void* malloc(uint);
void free(void*);
int atoi(const char*);
