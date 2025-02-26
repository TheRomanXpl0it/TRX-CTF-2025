from hashlib import sha256
from Crypto.Util.number import bytes_to_long
from pwn import process
rem = process(['sage', 'babydlp.sage'])


p = 0x05ab035976b887b505bfcc20df74d9ab3d4a50cb87f5cede0d
E = EllipticCurve(GF(p), [0x04ae328d15285fa70cf60749cf41cf14e1a316651fe8ce3b23, 0x03c7abc7899e550ba2eaeb5be64da31af90073a08c1d3e0215])

G = E(
    0x570f7cc8830e8cbfd1d8890fac962275f1553b11e4f3e2af7,
    0x9d18b5cee48c50824741c5f8fdf1cd8cbf9fc3dd200f2fe9
)

msgs = [f'ciao'.encode() for i in range(10)] 

hs = []
rs = []
ss = []


for msg in msgs:
    rem.sendlineafter('> ', '1')
    rem.sendlineafter(': ', msg)
    rem.recvuntil('R = (')
    rs.append(int(rem.recvuntil(', ')[:-2]))
    rem.recvuntil('s = ')
    ss.append(int(rem.recvline()))
    hs.append(int(sha256(msg).hexdigest(),16))

P = PolynomialRing(ZZ, 'd,' + ','.join([f"k{i}_1,k{i}_2" for i in range(len(hs))]))
d_sym, *ks = P.gens()
eqs = []
for i in range(len(hs)):
    eqs.append(ss[i]*ks[i*2] - hs[i]*ks[i*2+1] - d_sym*rs[i])

A,mons = Sequence(eqs).coefficients_monomials(sparse=False)
L = block_matrix(QQ, [
    [A.T, 1],
    [p, 0]
])
ws = diagonal_matrix([1]*len(eqs) + [p] + [1<<32]*2*len(eqs), sparse=False)
L /= ws
L = L.BKZ(blocksize=40, proof=False)
L *= ws
for row in L:
    if row[:len(eqs)] == 0:
        # if all negative, negate
        if all([x < 0 for x in row[len(eqs):]]):
            row *= -1
        row = row.change_ring(ZZ)
        if row[len(eqs)].bit_length() > 150 and all([32 >= x.bit_length() > 1 for x in row[len(eqs)+1:]]):
            print(row)
            break
d = row[len(eqs)]
print('found d:', d)



from Crypto.Util.number import bytes_to_long
for c in 'abcdefghijklmnopqrstuvwxyz_':
    FLAG_LEN = 44
    AVG_VALUE = 106

    known_format = 'TRX{'+c
    base = (bytes_to_long(known_format.encode()) << (8*(FLAG_LEN-len(known_format)))) + ord('}')

    m_ = (d - base) % p
    kbitlen = max(0,8*(FLAG_LEN-len(known_format)) - m_.bit_length())

    P = PolynomialRing(ZZ, ','.join(['k'] + [f'c{i}' for i in range((FLAG_LEN-(len(known_format) + 1)))]))
    k_sym = P.gen(0)
    cs = P.gens()[1:]


    eq = sum((cs[i] + AVG_VALUE)*256**(FLAG_LEN-(len(known_format) + 1)-i) for i in range((FLAG_LEN-(len(known_format) + 1))))  - m_ # c0*256^43 + c1*256^42 + ... + c15*256^1 = m_ + k*p
    M,mons = Sequence([eq]).coefficients_monomials(sparse=False)
    M = block_matrix(QQ, [
        [M.T,1],
        [-p, 0]
    ])

    ww = [1] + [16]*len(cs) + [1]
    ws = diagonal_matrix([max(ww)//x for x in ww],sparse=False)
    M *= ws
    M = M.BKZ(block_size=100,proof=False)
    M = M / ws

    green = ('\033[92m', '\033[0m')
    grey = ('\033[90m', '\033[0m')
    from string import ascii_lowercase
    for row in M:
        if abs(row[-1]) == 1 and row[0] == 0:
            try:
                s = (bytes((row * row[-1])[1:-1] + vector([AVG_VALUE]*len(cs))))
                if all(x in (ascii_lowercase+'_').encode() for x in s):
                    print(green[0], known_format.encode() + s + b'}', green[1])
                    # break
                else:
                    print(grey[0], known_format.encode() + s + b'}', grey[1])
            except:
                pass