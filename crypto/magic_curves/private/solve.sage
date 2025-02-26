import os
os.environ['PWNLIB_NOTERM'] = '1'
os.environ['TERM'] = 'linux'
from pwn import *

def smart_attack(G, P):
    """
    Solves the discrete logarithm problem using Smart's attack.
    More information: Smart N. P., "The Discrete Logarithm Problem on Elliptic Curves of Trace One"
    More information: Hofman S. J., "The Discrete Logarithm Problem on Anomalous Elliptic Curves" (Section 6)
    :param G: the base point
    :param P: the point multiplication result
    :return: l such that l * G == P
    """

    def _gf_to_qq(n, qq, x):
        return ZZ(x) if n == 1 else qq(list(map(int, x.polynomial())))

    # Lift a point to the p-adic numbers.
    def _lift(E, p, Px, Py):
        for P in E.lift_x(Px, all=True):
            if (P.xy()[1] % p) == Py:
                return P

    E = G.curve()
    assert E.trace_of_frobenius() == 1, f"Curve should have trace of Frobenius = 1."

    F = E.base_ring()
    p = F.characteristic()
    q = F.order()
    n = F.degree()
    qq = Qq(q, names="g")

    # Section 6.1: case where n == 1
    logging.info(f"Computing l % {p}...")
    E = EllipticCurve(qq, [_gf_to_qq(n, qq, a) + q * ZZ.random_element(1, q) for a in E.a_invariants()])
    Gx, Gy = _gf_to_qq(n, qq, G.xy()[0]), _gf_to_qq(n, qq, G.xy()[1])
    Gx, Gy = (q * _lift(E, p, Gx, Gy)).xy()
    Px, Py = _gf_to_qq(n, qq, P.xy()[0]), _gf_to_qq(n, qq, P.xy()[1])
    Px, Py = (q * _lift(E, p, Px, Py)).xy()
    l = ZZ(((Px / Py) / (Gx / Gy)) % p)

    if n > 1:
        # Section 6.2: case where n > 1
        G0 = p ** (n - 1) * G
        G0x, G0y = _gf_to_qq(n, qq, G0.xy()[0]), _gf_to_qq(n, qq, G0.xy()[1])
        G0x, G0y = (q * _lift(E, p, G0x, G0y)).xy()
        for i in range(1, n):
            logging.info(f"Computing l % {p ** (i + 1)}...")
            Pi = p ** (n - i - 1) * (P - l * G)
            if Pi.is_zero():
                continue

            Pix, Piy = _gf_to_qq(n, qq, Pi.xy()[0]), _gf_to_qq(n, qq, Pi.xy()[1])
            Pix, Piy = (q * _lift(E, p, Pix, Piy)).xy()
            l += p ** i * ZZ(((Pix / Piy) / (G0x / G0y)) % p)

    return int(l)

def pohlig_hellman(G, P):
    
    order = G.order()
    factors = [f[0]**f[1] for f in order.factor()]
    res = []

    for f in factors:

        Gf = G * (order // f)
        Pf = P * (order // f)

        res.append(discrete_log(Pf, Gf, ord=f, operation='+'))
    
    return CRT_list(res, factors)

p =    86173971746995248163241339822241438307290608733427662264837550369
a, b = 86173971746995248163241339822241438307290608733427662261446455585, 77986137112576

Zp = Zmod(p)

r = process(["sage", "../dist/chall.sage"])

E1 = EllipticCurve(Zp, [a, b])
E2 = EllipticCurve(Zp, [b, a])

r.sendlineafter(b"Give me a, b, p: ", f"{a},{b},{p}".encode())
pts = [tuple(map(int, k[1:-1].split(' : ')[:2])) for k in r.recvline().decode().strip().split('points: ')[1].split(',')]

P1, Q1 = E1(*pts[0]), E1(*pts[1])
P2, Q2 = E2(*pts[2]), E2(*pts[3])

print(P1, Q1, P2, Q2)

k1 = smart_attack(P1, Q1)
assert P1 * k1 == Q1
print(k1)

k2 = pohlig_hellman(P2, Q2)
assert P2 * k2 == Q2
print(k2)
r.sendlineafter(b"Give me k1, k2: ", f"{k1},{k2}".encode())

r.interactive()


