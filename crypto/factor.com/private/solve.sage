from pwn import process
from Crypto.Util.number import long_to_bytes
cof = prod(primes(10**8))

mods = []
vals = []

r = process(['python3','server.py'])

while 1:
    r.recvuntil(b'N = ')
    N = int(r.recvline().strip())
    r.recvuntil(b'e = ')
    e = int(r.recvline().strip())
    r.recvuntil(b'c = ')
    c = int(r.recvline().strip())
    r.sendline(b'yes')
    newN = gcd(N, cof) # or some real factoring algorithm
    if newN > 1:
        c = Zmod(newN)(c)
        m = c.nth_root(e)
        mods.append(newN)
        vals.append(ZZ(m))
    if lcm(mods).bit_length() > 300:
        break
    print(lcm(mods).bit_length())

flag = crt(vals, mods)

print(long_to_bytes(flag))

