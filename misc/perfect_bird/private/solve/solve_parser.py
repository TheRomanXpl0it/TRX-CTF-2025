file = "chall.db3"

with open(file, "r") as f:
	code = f.read().split("\n")
code = [c.strip().replace('!', '') for c in code]

mem = list(map(int, code[-4].split('[')[1][:-1].split(', ')))

start = 'const var w = '
operations = [c[len(start):] for c in code if c.startswith(start)]

for i, op in enumerate(operations):
	num = int(op.split(' ^ ')[2], 16)
	addr = i % len(mem)
	mem[addr] = ((i ^ mem[addr]) % 256) ^ num

flag = bytes(mem).decode()
print(flag)

