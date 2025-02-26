from Crypto.Util.number import long_to_bytes
from Crypto.Cipher import AES
import hashlib
import numpy as np
from tqdm import trange
from multiprocessing import Pool

def composite_gcd(g1,g2):
	return g1.monic() if g2 == 0 else composite_gcd(g2, g1 % g2)

def attack(interval):
    R.<x> = PolynomialRing(Zmod(n))

    for b in trange(interval[0], interval[1]): #stopped at 56663

        c1 = []
        c2 = []

        f=0
        for i in range(len(e1)):
            f+=a1[i]*x^e1[i]
        f = f^eB-cA

        g = 0
        for i in range(len(e2)):
            g+=a2[i]*(x-b)^e2[i]
        g = g^eA-cB

        kA = Integer(-composite_gcd(f, g).coefficients()[0])
        kB = kA-b

        for i in range(len(e1)):
            c1.append(Integer(pow(kA, e1[i], n)))

        #Second encryption
        for i in range(len(e2)):
            c2.append(Integer(pow(kB, e2[i], n)))

        key = long_to_bytes(np.dot(a1, c1) + np.dot(a2, c2))
        key = hashlib.sha256(key).digest()
        cipher = AES.new(key, AES.MODE_CBC, iv)
        flag = cipher.decrypt(ciphertext) 
        if b'TRX{' in flag:
            print(flag)
            break  

     

n = 74108640606145180149510176618521075466446449858404049106163063303576519775371516730684561741303109628942939834010235880891892440093400730049046747948465132571198813698521999858038263599945023053475340613220207592168748854245090041629573715694434741597448560715790100488556615870531765342293294801796177055859
cA = 32989963764038703766543902748369333287012297140638330098970187536532325868712636338438606208794905788477320266216074714405223922191097634356892951982064198078965969054354716559896862549651475252705604586109526278297220426126006541046274939606397631006445628048739656231993604851671333833446796179315480833374
cB = 32375137218626379056239257605674904874749807847184548685225849015458878061025483521241800911947097064990427158418575006245671228257496652139697292048091918888309371200176086791244646892729638577274432726331820205262505116396482933878527455789223622237672838003569879529279052098425551623391481959056163549674
iv = bytes.fromhex('3ab60f72ae51421d2b26c493b1d0794e')
ciphertext = bytes.fromhex('e819e8b1b79680c0c6b8fe539f7883effc7f7a89f2fbd64f3c04da38bde65d0485cf50d21c30b660e5490bd9e7897ba3058350d5745c876e8860fef06b2c7501')
e1 = [2, 3, 5, 7] 
a1 = [69, 420, 1337, 9001]
e2 = [11, 13, 17, 19]
a2 = [72, 95, 237, 1001]
eA = 27
eB = 35

input_list = [(i, i+2**14) for i in range(-2**16, 2**16, 2**14)]

with Pool(8) as p:
    p.map(attack, input_list)