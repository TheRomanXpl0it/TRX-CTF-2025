from functools import reduce
import sys
import random
import numpy as np
import time
from z3 import Solver, BitVec, sat


############################## OPTIONS ##############################


CORE_FILE = './core.sml'
CORE_OBFUSCATED_FILE = './core_obfuscated.sml'
INTERMIDIATE_FILE = './intermediate.txt'
OUT_FILE = './chall.sml'

#! WARINING: IF THE PROGRAM IS TAKING TOO LONG TO RUN, RETRY TO RUN OR TRY TO REDUCE THE FLAG SIZE
FLAG = "TRX{while_language_is_funny}"

RUN = 0
TRANSPILE = 1

OBFUSCATE = 1


############################## CONSTANTS ##############################


MINUS = 0
PLUS = 1
MUL = 2

TK_THREAD = "th\n"
TK_SYNC = "sync"
TK_CRIT = "crit"
TK_ENDCRIT = "endcrit"
TK_IF = "if "
TK_ENDIF = "} else {"
TK_END = "}"
TK_WHILE = "while "
TK_SKIP = "nop"


############################## TRANSPILER ##############################


def seq(s1: str, s2: str) -> str:
	if not s1.strip():
		return s2
	return f"Seq({s1}, {s2 if s2 else 'Skip'})"


def parse_single(s: str) -> str:
	if s[0] == '-' and s[1:].isdigit():
		return f"Const (0 - {s[1:]})"
	if s.isdigit():
		return f"Const {s}"
	else:
		return f"Var \"{s}\""


def parse_scope(s: str, divs='()') -> int:
	graph = 0

	for i, char in enumerate(s):
		if char == divs[0]:
			graph += 1
			continue
		elif char == divs[1]:
			graph -= 1
			if not graph:
				break

		if graph < 0:
			raise Exception()

		if not graph:
			continue

	return i + 1


def parseE(e: str) -> str:
	if e[0].isalnum() or e[0] in '-':
		return parse_single(e)

	i = parse_scope(e)
	if i == len(e):
		return parse_single(e[1:-1])

	op1 = e[1:i-1]
	op = e[i]
	op2 = e[i+2:-1]

	operators = {
		"+" : "Sum",
		"-" : "Sub",
		"*" : "Mul",
		"/" : "Div"
	}
	op = operators.get(op, None)
	if op is None:
		raise Exception()
	
	return f'{op}({parseE(op1)}, {parseE(op2)})'


def parseA(a: str) -> str:
	a = ''.join([char for char in a if char != ' '])
	var, exp = a.split('=')
	exp = parseE(exp)
	return f'Assign("{var}", {exp})'


def parseB(b: str) -> str:
	if b[0] == '!':
		return f'Not({parseB(b[2:-1])})'

	i = parse_scope(b)
	if i == len(b):
		if b[0] == '(':
			return b[1:-1]
		return b

	op1 = b[1:i-1]
	j = b[i:].find('(') + i
	op = b[i:j]
	op2 = b[j+1:-1]

	operators = {
		"and" : "And",
		"or" : "Or",
		"==" : "Eq",
		">" : "Gt",
		"<" : "Lt"
	}
	op = operators.get(op, None)
	if op is None:
		raise Exception()

	if op in ['And', 'Or']:
		return f'{op}({parseB(op1)}, {parseB(op2)})'
	return f'{op}({parseE(op1)}, {parseE(op2)})'


def parseP(p: str) -> str:
	p = [line for line in p.split('\n') if line]
	line = 0
	res = []
	while line < len(p):
		l = p[line]
		if l == TK_SYNC:
			res.append('Sync')
		
		elif l == TK_CRIT:
			line += 1
			sub_if = []
			while p[line] != TK_ENDCRIT:
				sub_if.append(p[line])
				line += 1
			parsed = parseP('\n'.join(sub_if))
			res.append(f"Crit({parsed})")

		elif l.startswith(TK_IF):
			cond = parseB(
				''.join([
					c
					for c in l[len(TK_IF):-1]
					if c != ' '
				])[1:-1]
			)

			line += 1
			sub_if = []
			while p[line] != TK_ENDIF:
				sub_if.append(p[line][1:])
				line += 1
			_then = parseP('\n'.join(sub_if))

			line += 1
			sub_else = []
			while p[line] != TK_END:
				sub_else.append(p[line][1:])
				line += 1
			_else = parseP('\n'.join(sub_else))

			res.append(f"If({cond}, {_then}, {_else})")


		elif l.startswith(TK_WHILE):
			cond = parseB(
				''.join([
					c
					for c in l[len(TK_WHILE):-1]
					if c != ' '
				])[1:-1]
			)
			
			line += 1
			sub_while = []
			while p[line] != TK_END:
				sub_while.append(p[line][1:])
				line += 1
			cycle = parseP('\n'.join(sub_while))

			res.append(f"While({cond}, {cycle})")

		elif l.startswith(TK_SKIP):
			res.append("Skip")			

		else:
			res.append(parseA(l))
		line += 1

	res = reduce(seq, res, "")
	return res


def parse(t: str) -> str:
	t = t.strip()
	threads = [th for th in t.split(TK_THREAD) if th]
	progs = []
	for th in threads:
		progs.append(parseP(th))

	res = 'Null'
	for t in progs[::-1]:
		res = f'Th({t}, {res})'

	return res


def transpile(parsed):
	if OBFUSCATE:
		with open(CORE_OBFUSCATED_FILE, 'r') as f:
			core = f.read()
	else:
		with open(CORE_FILE, 'r') as f:
			core = f.read()
	transpiled = core % (len(FLAG), parsed)
	with open(OUT_FILE, 'w') as f:
		f.write(transpiled)


############################## CONSTRAINTS ##############################


def generate_linear_system(solutions):
	n = len(solutions)
	while True:
		A = np.random.randint(-10, 10, size=(n, n))
		if np.linalg.det(A) != 0:
			break
	solutions = np.array(solutions)
	b = np.dot(A, solutions)
	return A, b


def gen_constraint_layer(flag, sign=MINUS):
	if sign == MINUS:
		mask = [random.randint(2, flag[i]-32) for i in range(len(flag))]
		masked_flag = [flag[i] - mask[i] for i in range(len(flag))]
	elif sign == PLUS:
		mask = [random.randint(2, flag[i]*2) for i in range(len(flag))]
		masked_flag = [flag[i] + mask[i] for i in range(len(flag))]
	elif sign == MUL:
		mask = [random.randint(2, 10) for i in range(len(flag))]
		masked_flag = [flag[i] * mask[i] for i in range(len(flag))]

	operations = [TK_SKIP] * (len(masked_flag) * 3)

	for i, c in enumerate(masked_flag):
		idx = random.randint(0, len(operations)-1)
		if sign == MINUS:
			s = '-' 
		elif sign == PLUS: 
			s = '+'
		elif sign == MUL:
			s = '*'
		if OBFUSCATE:
			op = f"{'l' * (i+1)} = ({'l' * (i+1)}) {s} ({mask[i]})"
		else:
			op = f"c_{i} = (c_{i}) {s} ({mask[i]})"
		if operations[idx] == TK_SKIP:
			operations[idx] = op
		else:
			operations.insert(idx, op)

	shrinked_ops = []
	last = ''
	for op in operations:
		if op == last == TK_SKIP:
			continue
		last = op
		shrinked_ops.append(op)

	if sign == MUL:
		shrinked_ops.insert(0, TK_CRIT)
		shrinked_ops.append(TK_ENDCRIT)

	return shrinked_ops, masked_flag


def generate_constraints(flag, signs):
	consts = []
	masked_flag = flag[::]

	for i, sign in enumerate(signs):
		try:
			const, masked_flag = gen_constraint_layer(masked_flag, sign)
		except ValueError:
			print("Generated Negative Value")
			exit(1)
		consts.append(const)

	A, b = generate_linear_system(masked_flag[::])
	n = len(masked_flag)

	s = Solver()
	x = [BitVec(f"x{i}", 16) for i in range(n)]

	constraints = []
	for i in range(n):
		s.add(sum([A[i, j]*x[j] for j in range(n)]) == b[i])
		if OBFUSCATE:
			tmp = [f"({A[i, j]}) * ({'l' * (j+1)}))" for j in range(n)]
			equation = reduce(lambda x, y: f'({x} + {y})', tmp) + f' == ({b[i]})'
			comp = f"if ( {equation} ) {{\n\tif ( ({'l' * (n+1)}) == (1) ) {{\n\t\t{'l' * (n+1)} = (1)\n\t}} else {{\n\t\t{'l' * (n+1)} = (0)\n\t}}\n}} else {{\n\tif ( ({'l' * (n+1)}) == (1) ) {{\n\t\t{'l' * (n+1)} = (0)\n\t}} else {{\n\t\t{'l' * (n+1)} = (0)\n\t}}\n}}"
		else:
			tmp = [f'(({A[i, j]}) * (c_{j}))' for j in range(n)]
			equation = reduce(lambda x, y: f'({x} + {y})', tmp) + f' == ({b[i]})'
			comp = f'if ( {equation} ) {{\n\tif ( (correct) == (1) ) {{\n\t\tcorrect = (1)\n\t}} else {{\n\t\tcorrect = (0)\n\t}}\n}} else {{\n\tif ( (correct) == (1) ) {{\n\t\tcorrect = (0)\n\t}} else {{\n\t\tcorrect = (0)\n\t}}\n}}'
		constraints.append(comp)
	consts.append(constraints)

	start = time.time()
	if s.check() == sat:
		end = time.time()
		m = s.model()
		system_solve = [m[x[i]].as_long() for i in range(n)]
		if system_solve != masked_flag:
			print("Wrong solution")
			exit(1)
		print(f"Solve Time: {end-start:.2f} seconds")
	else:
		print("Unsatisfiable System")
		exit(1)
	
	return consts


def shuffle_constraints(constraints, signs):
	tot_mul = sum([1 for s in signs if s == MUL])
	mul_num = 0
	for i in range(len(constraints)-1):
		if signs[i] == MUL:
			mul_num += 1
			constraints[i] = [TK_SYNC]*mul_num + constraints[i] + [TK_SYNC]*(tot_mul-mul_num+1)
		else:
			constraints[i] = [TK_SYNC] * mul_num + constraints[i] + [TK_SYNC] * (tot_mul-mul_num+1)
	constraints[-1] = [TK_SYNC] * (tot_mul+1) + constraints[-1]
	return constraints




############################## MAIN ##############################

if FLAG[-1] != '\n':
	FLAG += '\n'
flag = [ord(c) for c in FLAG]

signs = [PLUS, MUL, MINUS, PLUS, MINUS, MINUS, MUL, PLUS]

constraints = generate_constraints(flag, signs)
constraints = shuffle_constraints(constraints, signs)

with open(INTERMIDIATE_FILE, 'w') as f:
	for c in constraints:
		f.write('\n'+TK_THREAD)
		for op in c:
			f.write(op + '\n')


if len(sys.argv) > 1:
	file = sys.argv[1]
else:
	file = "intermediate.fmi"
with open(file, 'r') as f:
	prog = f.read()

parsed = parse(prog)

if TRANSPILE:
	transpile(parsed)
else:
	print(parsed)


if RUN:
	from os import system
	system(f'cat {OUT_FILE} | sml')
