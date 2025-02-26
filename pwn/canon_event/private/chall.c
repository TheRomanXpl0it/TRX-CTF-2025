#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <err.h>

#include <linux/filter.h>
#include <linux/seccomp.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <stddef.h>


#include <sys/mman.h>

#define CODE_ADDRESS    0xdead000
#define STACK_MAPPING   0xdeae000
#define CODE_SIZE       0x1000
#define STACK_SIZE      0x1000

// Define the target address range
#define TARGET_START 0x000000000000
#define TARGET_END   0x800000000000

#define HIGH(X) ((X >> 32) & ((1 << 32) - 1))
#define LOW(X)  (X & ((1 << 32) - 1))

void install_seccomp_filter() {
    struct sock_filter filter[] = {
        // Load rip
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, instruction_pointer) + 4),

        // Check if (addr >> 32) < TARGET_END
        BPF_JUMP(BPF_JMP | BPF_JGE | BPF_K, HIGH(TARGET_END), 4, 0),
        
        // Check if the syscall is ptrace
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_wait4, 2, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_ptrace, 1, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_fork, 0, 1),


        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_KILL_PROCESS)
        
    };

    struct sock_fprog prog = {
        .len = (unsigned short)(sizeof(filter) / sizeof(filter[0])),
        .filter = filter,
    };

    // Apply the seccomp filter
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) != 0) {
        perror("prctl(PR_SET_NO_NEW_PRIVS) failed");
        exit(EXIT_FAILURE);
    }

    if (prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog) != 0) {
        perror("prctl(PR_SET_SECCOMP) failed");
        exit(EXIT_FAILURE);
    }
}



void isolate_and_jump(void* address, void* stack){
    void (*target_address)();

    target_address = address;
    
    install_seccomp_filter();
    
    target_address();
}

unsigned int get_uint(){
    unsigned int val, r;
    r = scanf("%d", &val);

    if(r != 1)
        err(1, "scanf failed");

    return val;
}
__attribute__((constructor))
void init(){
    setbuf(stdout, NULL);
    setbuf(stdin, NULL);
    setbuf(stderr, NULL);
}

int main(){
    char* code_mapping, *stack_mapping;
    unsigned int code_size;
    ssize_t r;

    code_mapping = (char *)mmap((void *)CODE_ADDRESS, CODE_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1 ,0);
    stack_mapping = (char *)mmap((void *)STACK_MAPPING, STACK_SIZE, PROT_READ | PROT_WRITE, MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
    
    if(code_mapping == MAP_FAILED || stack_mapping == MAP_FAILED)
        err(1, "mmap failed");
    

    printf("code size: ");
    code_size = get_uint();

    if(code_size > CODE_SIZE){
        puts("invalid code size");
        exit(1);
    }
    
    printf("enter shellcode: ");
    r = read(STDIN_FILENO, code_mapping, code_size);

    if(r < 0)
        err(1, "read failed");

    r = mprotect(code_mapping, CODE_SIZE, PROT_READ | PROT_EXEC);
    if(r < 0)
        err(1, "mprotect failed");
    
    isolate_and_jump((void *)code_mapping, (void *)stack_mapping);

    return 0;
}