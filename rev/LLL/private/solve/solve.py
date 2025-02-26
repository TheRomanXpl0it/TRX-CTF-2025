file = 'LLL.sml'
with open(file, 'r') as f:
	code = f.read().split('\n')

'''
datatype Exp = Const of int | Var of string | Sum of Exp * Exp | Sub of Exp * Exp | Mul of Exp * Exp | Div of Exp * Exp;
datatype Bool = True | False | And of Bool * Bool | Or of Bool * Bool | Not of Bool | Eq of Exp * Exp | Gt of Exp * Exp | Lt of Exp * Exp;
datatype Program = Skip | Seq of Program * Program | Assign of string * Exp | If of Bool * Program * Program | While of Bool * Program | Sync | Crit of Program;
datatype Thread = Null | Th of Program * Thread;
'''

EXP =	'lllllllllllllllllllllllllllllll'
CONST =	'llllllllllllllllllllllllllllllll'
VAR =	'lllllllllllllllllllllllllllllllll'
SUM =	'llllllllllllllllllllllllllllllllll'
SUB =	'lllllllllllllllllllllllllllllllllll'
MUL =	'llllllllllllllllllllllllllllllllllll'
DIV =	'lllllllllllllllllllllllllllllllllllll'

BOOL =	'llllllllllllllllllllllllllllllllllllll'
TRUE =	'lllllllllllllllllllllllllllllllllllllll'
FALSE =	'llllllllllllllllllllllllllllllllllllllll'
AND =	'lllllllllllllllllllllllllllllllllllllllll'
OR =	'llllllllllllllllllllllllllllllllllllllllll'
NOT =	'lllllllllllllllllllllllllllllllllllllllllll'
EQ =	'llllllllllllllllllllllllllllllllllllllllllll'
GT =	'lllllllllllllllllllllllllllllllllllllllllllll'
LT =	'llllllllllllllllllllllllllllllllllllllllllllll'

PROGRAM =	'lllllllllllllllllllllllllllllllllllllllllllllll'
SKIP =		'llllllllllllllllllllllllllllllllllllllllllllllll'
SEQ =		'lllllllllllllllllllllllllllllllllllllllllllllllll'
ASSIGN =	'llllllllllllllllllllllllllllllllllllllllllllllllll'
IF =		'lllllllllllllllllllllllllllllllllllllllllllllllllll'
WHILE =		'llllllllllllllllllllllllllllllllllllllllllllllllllll'
SYNC =		'lllllllllllllllllllllllllllllllllllllllllllllllllllll'
CRIT =		'llllllllllllllllllllllllllllllllllllllllllllllllllllll'

THREAD =	'lllllllllllllllllllllllllllllllllllllllllllllllllllllll'
NULL =		'llllllllllllllllllllllllllllllllllllllllllllllllllllllll'
TH =		'lllllllllllllllllllllllllllllllllllllllllllllllllllllllll'

operations = {
	EXP: 'Exp',
	CONST: 'Const',
	VAR: 'Var',
	SUM: 'Sum',
	SUB: 'Sub',
	MUL: 'Mul',
	DIV: 'Div',

	BOOL: 'Bool',
	TRUE: 'True',
	FALSE: 'False',
	AND: 'And',
	OR: 'Or',
	NOT: 'Not',
	EQ: 'Eq',
	GT: 'Gt',
	LT: 'Lt',

	PROGRAM: 'Program',
	SKIP: 'Skip',
	SEQ: 'Seq',
	ASSIGN: 'Assign',
	IF: 'If',
	WHILE: 'While',
	SYNC: 'Sync',
	CRIT: 'Crit',

	THREAD: 'Thread',
	NULL: 'Null',
	TH: 'Th',
}

############################## DEOBFUSCATION ##############################

start = 'val lll = '
ast = code[179][len(start):-1]

subs = sorted(operations.items(), reverse=True)
	
for sub, name in subs:
	ast = ast.replace(sub, name)

flag_chars = [f'"{ "l" * (i+1) }"' for i in range(29)]
for i in range(len(flag_chars)-1, -1, -1):
	ast = ast.replace(flag_chars[i], f'"c_{i}"')
ast = ast.replace('l' * 30, f'correct')

############################## OPERATION BLOCKS SPLIT ##############################

blocks = ast.split('Th')[1:]

def extract_from_block(block):
	values = {}
	splitted_block = block.split('Var "')
	for i in range(1, len(splitted_block)):
		var, val = splitted_block[i].split(')')[0].split('", Const ')
		var = int(var.split('_')[1])
		values[var] = int(val)
	return values

layers = []
for i in range(len(blocks) - 1):
	layers.append(extract_from_block(blocks[i]))

############################## EQAUATION SYSTEM SOLVING ##############################

def extract_equation(block):
	tmp = block.split('Mul')[1:]
	values = {}
	for i, mul in enumerate(tmp):
		mul = mul[len('(Const '):]
		val, var = mul.split('Var "')
		var = var.split('")')[0]
		if val[0] == '(':
			val = - int(val.split(' - ')[1][:-3])
		else:
			val = int(val[:-2])
		if i == (len(tmp)-1):
			const = mul.split('Const ')[1][:-3]
			if const[0] == '(':
				const = - int(const.split(' - ')[1][:-1])
			else:
				const = int(const)
		var = int(var.split('_')[1])
		values[var] = val
	return values, const


last_block = [check for check in blocks[-1].split('If') if 'correct' not in check][1:]


from z3 import *

flag_chars = [BitVec(f'c_{i}', 16) for i in range(29)]
s = Solver()

for sub_block in last_block:
	values, const = extract_equation(sub_block)
	# print(values, const)
	equation = 0
	for var, val in values.items():
		equation += val * flag_chars[var]
	s.add(equation == const)

print('Checking...')
if s.check() == sat:
	print('Sat')
	m = s.model()
	flag = [m[c].as_long() for c in flag_chars]
else:
	print('Unsat')
	exit(1)

############################## INVERTING BLOCKS ##############################

SUM = 0
SUB = 1
MUL = 2
signs = [SUM, MUL, SUB, SUM, SUB, SUB, MUL, SUM]

for i in range(len(layers)-1, -1, -1):
	sign = signs[i]
	if sign == SUM:
		for var, val in layers[i].items():
			flag[var] -= val
	elif sign == SUB:
		for var, val in layers[i].items():
			flag[var] += val
	elif sign == MUL:
		for var, val in layers[i].items():
			flag[var] //= val
	else:
		print('Error')
		exit(1)

############################## FLAG ##############################

print(flag)
print(bytes(flag))

# TRX{while_language_is_funny}
