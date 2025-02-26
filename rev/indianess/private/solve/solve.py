file = 'bytecode.bin'
with open(file, 'rb') as f:
	code = f.read()

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


DEBUG = False


def parse_code(op: str, mode: int, op1: int, op2: int):
	if not DEBUG:
		return
	if mode == REG_IMM or mode == REG_PLAIN:
		print(f'{op} r{op1}, {op2}')
	elif mode == MEM_IMM_IMM:
		print(f'{op} mem[{op1}], {op2}')
	elif mode == REG_MEM_IMM:
		print(f'{op} r{op1}, mem[{op2}]')
	elif mode == REG_REG:
		print(f'{op} r{op1}, r{op2}')
	elif mode == MEM_IMM_MEM_REG:
		print(f'{op} mem[{op1}], mem[r{op2}]')
	elif mode == MEM_REG_REG:
		print(f'{op} mem[r{op1}], r{op2}')
	elif mode == REG_MEM_REG:
		print(f'{op} r{op1}, mem[r{op2}]')
	elif mode == MEM_REG_MEM_REG:
		print(f'{op} mem[r{op1}], mem[r{op2}]')
	else:
		print(f'Unknown mode for {op}: {mode}')
		exit(1)


ciphertext = []
key = []

i = 0
while i < len(code):
	op = code[i]
	if op == PRINT:
		if DEBUG:
			print('print')
		i += 1
		continue
	mode = code[i+1]
	if op == MOV:
		parse_code('mov', mode, code[i+2], code[i+3])
	elif op == ADD:
		if mode == REG_IMM or mode == REG_PLAIN:
			if len(key) < 16:
				key.append(code[i+3])
		parse_code('add', mode, code[i+2], code[i+3])
	elif op == XOR:
		parse_code('xor', mode, code[i+2], code[i+3])	
	elif op == ASSERT:
		parse_code('assert', mode, code[i+2], code[i+3])
		ciphertext.append(code[i+3])
	else:
		print(f'Unknown op: {op}')
		exit(1)
	i += 4


print('key:', key)
print('ciphertext:', ciphertext)

from Crypto.Cipher import ARC4
cipher = ARC4.new(key=bytes(key))
flag = cipher.decrypt(bytes(ciphertext))
print(flag.decode())

# TRX{RC4_1s_4_r3al_m4st3rp13c3}
