import colored_traceback
colored_traceback.add_hook = lambda: None
from pwn import remote, process
from hashlib import sha256
from Crypto.Cipher import AES

# r = process(['sage', 'chall.sage'])
#  nc lepton.ctf.theromanxpl0.it 7004 
r = remote('lepton.ctf.theromanxpl0.it', 7012)

def walk_isogeny(E, exponent_vector):
    P = E.random_point()
    o = P.order()
    order = prod(ells[i] for i in range(len(ells)) if exponent_vector[i] == 1)
    while o % order:
        P = E.random_point()
        o = P.order()
    P = o // order * P
    phi = E.isogeny(P, algorithm='factored')
    E = phi.codomain()
    return E, phi

ells = [3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 
        71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 
        149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 
        227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
        307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 587]
p = 4 * prod(ells) - 1
F = GF(p)
E0 = EllipticCurve(F, [1, 0])


recovered_secret = []

last_res = None

for i in range(74):
    r.recvuntil(b'Intermidiate montgomery curve: ')
    a2 = int(r.recvline().strip())
    E = EllipticCurve(F, [0, a2, 0, 1, 0])
    E.set_order(4 * prod(ells))
    P = E.random_point()
    while P.order() % ells[i]:
        P = E.random_point()
    P = P * (P.order() // ells[i])
    r.recvline()
    r.sendline(f'{P.xy()[0]},{P.xy()[1]}')
    resp = r.recvline().strip()
    if b"Invalid" in resp:
        recovered_secret.append(1)
    else:
        recovered_secret.append(0)
        last_res = E, P, bytes.fromhex(resp.decode())
    print(f"Round {i}: {recovered_secret}")

secret_vector = recovered_secret
E, P, resp = last_res
E, phi = walk_isogeny(E, secret_vector)
E_final = E.montgomery_model()
phi = E.isomorphism_to(E_final)*phi
Q = phi(P)
secret_key = sha256(str(Q.xy()[0]).encode()).digest()
cipher = AES.new(secret_key, AES.MODE_ECB)
dec = cipher.decrypt(resp)
if b'TRX{' in dec:
    print(dec)
