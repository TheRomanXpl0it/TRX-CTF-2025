import random

BITS = 216

m = 0

j = -2**15
def f(x):
    return 11*x*(x+1)+3

def find_m(bits):
    global m

    lb, hb = 1, 2
    while f(hb) < 2**bits:
        lb = hb
        hb *= 2

    while (hb - lb) > 10:
        m = (hb + lb) // 2
        if f(m) < bits:
            lb = m
        else:
            hb = m
    
    m += random.randint(m//11, m//10)

def next_prime():
    global m
    p = 4
    while not is_prime(p):
        m += 1
        p = f(m)
    return p

find_m(BITS)

while True:
    p = next_prime()
    Zp = Zmod(p)
    
    E1 = EllipticCurve(j=Zp(j))
    if E1.cardinality() != p:
        continue
    
    a, b = E1.a4(), E1.a6()
    E2 = EllipticCurve([b, a])

    try:
        alarm(5)
        fs = E2.cardinality().factor(algorithm="ecm")[-1][0]
    except AlarmInterrupt:
        continue
    finally:
        cancel_alarm()

    print('.', end='')

    if fs < 2**60:
        print("\n")
        print(f"{a = }\n{b = }\n{p = }")
        print(int(fs).bit_length())