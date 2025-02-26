from Crypto.Util.number import bytes_to_long as b2l
outs = [25655763503777127809574173484, 8225698895190455994566939853, 10138657858525287519660632490]
points = [0xdeadbeef, 13371337, 0xcafebabe]
mod1 = b2l(b'cant_give_you_everything')
mod2 = b2l(b'only_half!!!')

P = PolynomialRing(ZZ, ','.join([f'f{i}{j}' for i in range(10) for j in range(4)] + [f'k{i}' for i in range(len(outs))]))
fsym = P.gens()[:-len(outs)]
fsym = [sum([((fsym[i*4+j] + 76 + 0x40)*256 + 0x1f)*(256**2)**(3-j) for j in range(4)])+ 0xfffe0000000000000000 for i in range(10)]
ksym = P.gens()[-len(outs):]

eqs = []
for i in range(len(points)):
    eqs.append(sum([(fsym[j])*points[i]**j for j in range(10)]) - (ksym[i])*mod2 - outs[i])

A,mons = Sequence(eqs).coefficients_monomials(sparse=False) 
L = block_matrix(QQ, [
    [A.T, 1],
    [mod1, 0]
])

ws = diagonal_matrix([1]*len(eqs) + [44]*len(P.gens()[:-len(outs)]) + [(mod1//mod2) >> 1]*len(ksym) + [1], sparse=False)
L /= ws
L = L.BKZ(block_size=40, proof=False)
L *= ws
for row in L:
    if row[:len(eqs)] == 0 and row[-1] in [-1,1]:
        try:
            print(bytes(x+76 for x in (row*row[-1])[3:-4]))
        except:
            pass

