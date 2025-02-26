## Indianess

## Challenge Description
*Like a timeless classic in literature, this challenge embodies the essence of its genre. A true staple of CTFs, it tests fundamental skills with a familiar yet ever-engaging twist. Seasoned players will recognize its form*

## Static Analysis

We can start with a few observations, the challenge attachments contains an executable called `vm` and a binary file called `bytecode.bin`, as we can guess, this will most likely be a vm challenge, so we can start  reversing.

Opening the `vm` executable in IDA reveals a stripped C++ binary. The `main` function takes two arguments: the bytecode file and a flag string. The function `sub_6B67` loads the bytecode file and passes its contents to `sub_2589`, which implements the core of the virtual machine.

### Understanding the Virtual Machine

Through analysis, we determine that the VM operates on an array, likely used as registers. It supports standard operations such as `ADD`, `SUB`, `MOV`, with multiple operand types like `REG2REG`, `MEM2MEM`, and `MEM2REG`. The last instruction in the bytecode prints output based on the correctness of the flag. Lastly we can notice that the flag len is checked to be 30.

## Writing a Disassembler

Analyzing the instruction set, we determine the following opcode mappings:
```py
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
```

Now we implement the disassebler knowing the codes.
First, we can start by loading the code file:
```py
file = 'bytecode.bin'
with open(file, 'rb') as f:
	code = f.read()
```

Then we can write an helper function that gives combine the instruction with the mode:
```py
def parse_code(op: str, mode: int, op1: int, op2: int):
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
```

now we can run the program an write only the neede instructions in a loop that reads all the instructions:
```py
i = 0
while i < len(code):
	op = code[i]
	if op == PRINT:
		print('print')
		i += 1
		continue
	mode = code[i+1]
	if op == MOV:
		parse_code('mov', mode, code[i+2], code[i+3])
	elif op == ADD:
		parse_code('add', mode, code[i+2], code[i+3])
	elif op == XOR:
		parse_code('xor', mode, code[i+2], code[i+3])	
	elif op == ASSERT:
		parse_code('assert', mode, code[i+2], code[i+3])
	else:
		print(f'Unknown op: {op}')
		exit(1)
	i += 4
```

## Final Disassembler
```py
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


def parse_code(op: str, mode: int, op1: int, op2: int):
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

i = 0
while i < len(code):
	op = code[i]
	if op == PRINT:
		print('print')
		i += 1
		continue
	mode = code[i+1]
	if op == MOV:
		parse_code('mov', mode, code[i+2], code[i+3])
	elif op == ADD:
		parse_code('add', mode, code[i+2], code[i+3])
	elif op == XOR:
		parse_code('xor', mode, code[i+2], code[i+3])	
	elif op == ASSERT:
		parse_code('assert', mode, code[i+2], code[i+3])
	else:
		print(f'Unknown op: {op}')
		exit(1)
	i += 4
```

## Bytecode Analysis


At first we can notice something strange, the bytecode is only using 5 different instructions.
We can inspect the disassembled code to get an idea of what is doing.

If we filter for the assert like operation we notice that there are only 30 of them, exactly as the flag len.
And if we filter for the print operation that checks if we have the correct flag, we see that there is only one at the end of the bytecode.

Now we can look at first operations of the bytecode, and we can see are a lor of initializazion of the memory like:
```asm
mov r0, 0
mov mem[0], 0
mov mem[1], 1
mov mem[2], 2
mov mem[3], 3
mov mem[4], 4
mov mem[5], 5
mov mem[6], 6
mov mem[7], 7
mov mem[8], 8
mov mem[9], 9
mov mem[10], 10
mov mem[11], 11
mov mem[12], 12
mov mem[13], 13
...
```
This is very strange, also after the initialization we are greeted with another strange combination of instructions like:
```asm
mov r1, mem[0]
add r1, 93
add r1, r0
mov r0, r1
mov r2, mem[0]
mov mem[0], mem[r0]
mov mem[r0], r2
...
```
That is repeated with a different value and offset. if we filter by "add r1, " and remove the ones with r0,
We see that the hardcoded values repeats themselves after 16 bytes,
and if we filter for "mov r1, mem" to see how far it goes we see that it goes until 255.
This can be unrolled to the following code:
```py
r0 = 0
mem = [0] * 256
for i in range(256):
	mem[i] = i
hardcoded = [...]
for i in range(256):
	r0 += mem[i] + hardcoded[i % 16]
	mem[i], mem[r0] = mem[r0], mem[i] # swap
```

After a quick look we recognize the initialization frunction of **RC4**!

After this realization we can extract with the disassembler the hardcoded values in the *movs* and in the *asserts*
```py
elif op == ADD:
	if mode == REG_IMM or mode == REG_PLAIN:
		if len(key) < 16:
			key.append(code[i+3])
	parse_code('add', mode, code[i+2], code[i+3])
```
```py
elif op == ASSERT:
	parse_code('assert', mode, code[i+2], code[i+3])
	ciphertext.append(code[i+3])
```

Now for the final step, decrypt the ciphertext:
```py
from Crypto.Cipher import ARC4
cipher = ARC4.new(key=bytes(key))
flag = cipher.decrypt(bytes(ciphertext))
print(flag.decode())
```

## Final Solve Script
```py
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
```

## Flag

`TRX{RC4_1s_4_r3al_m4st3rp13c3}`
