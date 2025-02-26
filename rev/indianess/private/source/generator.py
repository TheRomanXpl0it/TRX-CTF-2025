from Crypto.Cipher import ARC4


DEV = True
COMPILE = True


N = 256
key = bytes.fromhex('5d8810ce724ffff21982aa9f837f62e9')
plaintext = b'TRX{RC4_1s_4_r3al_m4st3rp13c3}'
cipher = ARC4.new(key)
ciphertext = cipher.encrypt(plaintext)

# OP_Code
ADD = 0
SUB = 1
MUL = 2
DIV = 3
MOD = 4
NOT = 5
OR = 6
AND = 7
XOR = 8
MOV = 9
ASSERT = 10
PRINT = 11

# MOD_Code
REG_REG = 0
MEM_IMM_MEM_IMM = 1
MEM_IMM_MEM_REG = 2
MEM_REG_MEM_IMM = 3
MEM_REG_MEM_REG = 4
REG_IMM = 5
REG_MEM_IMM = 6
REG_MEM_REG = 7
MEM_IMM_IMM = 8
MEM_REG_IMM = 9
MEM_IMM_REG = 10
MEM_REG_REG = 11
REG_PLAIN = 12

# Regs
R0 = 0
R1 = 1
R2 = 2
R3 = 3
R4 = 4
R5 = 5
R6 = 6
R7 = 7



f = open('bytecode.bin', 'wb')
	

if DEV and not COMPILE:
	print(f'plaintext = {plaintext}')
	print(f'mem = [0] * {N}')

# f.write(bytes([]))
if COMPILE:
	f.write(bytes([MOV, REG_IMM, R0, 0]))
else:
	print(f'r0 = 0')

for i in range(N):
	if COMPILE:
		f.write(bytes([MOV, MEM_IMM_IMM, i, i]))
	else:
		print(f'mem[{i}] = {i}')

for i in range(N):
	if COMPILE:
		f.write(bytes([MOV, REG_MEM_IMM, R1, i]))
		f.write(bytes([ADD, REG_IMM, R1, key[i % len(key)]]))
		f.write(bytes([ADD, REG_REG, R1, R0]))
		# f.write(bytes([MOD, REG_IMM, R1, N]))
		f.write(bytes([MOV, REG_REG, R0, R1]))
		f.write(bytes([MOV, REG_MEM_IMM, R2, i]))
		f.write(bytes([MOV, MEM_IMM_MEM_REG, i, R0]))
		f.write(bytes([MOV, MEM_REG_REG, R0, R2]))
	else:
		print(f'r1 = mem[{i}]')
		print(f'r1 += {key[i % len(key)]}')
		print(f'r1 += r0')
		print(f'r1 =% {N}')
		print(f'r0 = r1')
		print(f'r2 = mem[{i}]')
		print(f'mem[{i}] = mem[r0]')
		print(f'mem[r0] = r2')

if COMPILE:
	f.write(bytes([MOV, REG_IMM, R4, 0]))
	f.write(bytes([MOV, REG_IMM, R0, 0]))
else:
	print('r4 = 0')
	print('r0 = 0')

for n in range(len(plaintext)):
	if COMPILE:
		f.write(bytes([ADD, REG_IMM, R4, 1]))
		# f.write(bytes([MOD, REG_IMM, R4, N]))
		f.write(bytes([ADD, REG_MEM_REG, R0, R4]))
		# f.write(bytes([MOD, REG_IMM, R0, N]))
		f.write(bytes([MOV, REG_MEM_REG, R2, R4]))
		f.write(bytes([MOV, MEM_REG_MEM_REG, R4, R0]))
		f.write(bytes([MOV, MEM_REG_REG, R0, R2]))
		f.write(bytes([MOV, REG_MEM_REG, R3, R4]))
		f.write(bytes([ADD, REG_MEM_REG, R3, R0]))
		# f.write(bytes([MOD, REG_IMM, R3, N]))
		f.write(bytes([MOV, REG_MEM_REG, R5, R3]))
		f.write(bytes([XOR, REG_PLAIN, R5, n]))
		f.write(bytes([ASSERT, REG_IMM, R5, ciphertext[n]]))
	else:
		print('r4 += 1')
		print(f'r4 %= {N}')
		print('r0 += mem[r4]')
		print(f'r0 %= {N}')
		print(f'r2 = mem[r4]')
		print(f'mem[r4] = mem[r0]')
		print(f'mem[r0] = r2')
		print('r3 = mem[r4]')
		print('r3 += mem[r0]')
		print(f'r3 %= {N}')
		print(f'r5 = mem[r3]')
		print(f'r5 ^= plaintext[{n}]')
		print(f'assert r5 == {ciphertext[n]}')

if COMPILE:
	f.write(bytes([PRINT]))
else:
	print('print("Correct!")')



f.close()
