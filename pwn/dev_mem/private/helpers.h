// made with love from prosti
#ifndef _HELPERS_H
#define _HELPERS_H

#define _GNU_SOURCE

#include <stdlib.h>
#include <stdint.h>
#include <stddef.h>
#include <unistd.h>

// ugly but fuck it
#undef PAGE_SIZE
#define PAGE_SIZE 0x1000

// pipe
#include <fcntl.h>
int set_pipe_pages(int* pipes_fd, int npages);

// dma_heap
#include <sys/ioctl.h>
#include <sys/mman.h>
#define DMA_HEAP_SYSTEM_DEV "/dev/dma_heap/system"
#define DMA_HEAP_IOCTL_ALLOC 0xc0184800

struct dma_heap_allocation_data {
  unsigned long long len;
  unsigned int fd;
  unsigned int fd_flags;
  unsigned long long heap_flags;
};

int open_dma_heap_system(void);
int get_dma_buf_fd(int fd, struct dma_heap_allocation_data* data);


// poll_list
#include <poll.h>
#include <pthread.h>

#define N_STACK_PPS 30
#define POLLFD_PER_PAGE 510
#define POLL_LIST_SIZE 16
#define NFDS(size) (((size - POLL_LIST_SIZE) / sizeof(struct pollfd)) + N_STACK_PPS);

struct t_args {
    int id;
    int nfds;
    int timeout;
	int fd;
};
struct poll_list {
    struct poll_list *next;
    int len;
    struct pollfd entries[];
};

static void *__alloc_poll_list(void *args);
static void create_poll_thread(int id, size_t size, int timeout, int fd);
static void join_poll_threads();

typedef struct alloc_poll_list_args {
    char* filename;
    int size; 
    int time;
    int n;
} alloc_poll_list_args_t;

void* alloc_poll_list(void* args);

// System V messages (struct msgmsg)
#include <sys/ipc.h>
#include <sys/msg.h>
#include <err.h>
#define MSG_COPY 040000
int send_msg(void* data, size_t size);
int read_msg(int msqid, void* data, size_t size);

// ROP
static void get_valid_rsp(void **user_rsp);

// shellcode
void replace(uint8_t* buffer, size_t buffer_sz, unsigned long to_find, unsigned long to_put);

// debug
#include <stdio.h>
#define INF "[*]"
#define ERR "[!]"
inline long min(long x1, long x2) { return x1 * (x1 < x2) + x2 * (x2 <= x1); }
void hlt(char* s);
void hexdump(int8_t* array, size_t sz, size_t blocksz);

// misc
#include <sched.h>
void pin_cpu(void);

#endif