import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import unpad
from itertools import permutations, product
set_verbose(-1)

p = 2**127 - 1
Zp = Zmod(p)
R.<x> = PolynomialRing(Zp)

a, b = 57792482556163740063210341500068239889, 169237172037427005576500528337261655640
F = x**5 + a*x**3 + b*x
H = x**2 + x + 1

iv = bytes.fromhex('da122954201b841f01b85ab12da1ab3b')
ct = bytes.fromhex('b21a0a89502508119e2062a7145775418163d947b889b58e2ec88ad3907129fceff7c38b2721d6c89b16edf7a05153b6b54fa55c36f74d479f08a8afa2ca08c8')

C = HyperellipticCurve(F, H)
J = C.jacobian()(Zp)

PQRu = x^2 + 63302659844929880293283924307824630476*x + 147250528713145888320441019253715338546
PQSu = x^2 + 149118285722446734984934788574031623199*x + 23310041014195484294124078181127671986

def invert(Pt):
    return C(Pt[0], -Pt[1] -H(Pt[0]))

def extractPoints(u, v=None):
    if len(u.roots()) != 2:
        return []
    A, B = [uu[0] for uu in u.roots()]
    if v:
        return [(C(A, v(A)), C(B, v(B)))]
    A, B = C.lift_x(A), C.lift_x(B)
    return list(product([A, invert(A)], [B, invert(B)]))

def try_decrypt(points):
    secret = hashlib.sha256(''.join([str((pt[0], pt[1])) for pt in points]).encode()).digest()
    cipher = AES.new(key=secret, mode=AES.MODE_CBC, iv=iv)

    flag = cipher.decrypt(ct)
    if b"TRX{" in flag:
        print(unpad(flag, AES.block_size).decode())

for N, M in product(extractPoints(PQRu), extractPoints(PQSu)):
    N1, N2 = N
    M1, M2 = M

    Jn = J(N1) + J(N2) # P + Q + R
    Jm = J(M1) + J(M2) # P + Q + S

    Jnm = Jn - Jm # R - S
    for AA, BB in extractPoints(Jnm[0]):
        for R, Sn in [(AA, BB), (BB, AA)]:
            S = invert(Sn)

            Jpq1 = Jn - J(R)
            Jpq2 = Jm - J(S)

            if Jpq1 != Jpq2:
                continue

            for P, Q in extractPoints(*Jpq1):
                Jp, Jq, Jr, Js = map(J, [P, Q, R, S])
                for pp in permutations([Jp, Jq, Jr, Js]):
                    try_decrypt(pp)