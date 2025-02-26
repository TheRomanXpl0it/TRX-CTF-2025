# LLL

## Description

LLL is my favourite programming lan... Cryptographic algorithm

## First Steps

As we open the source file we can see that everything is obfuscated by changing the name of everything.
The simplest thing we can do, is run the code (give that is sml).
As we run the code (with `use "LLL.sml";` into the sml console) we see that loads the program and then it stops,
we can try to give `test` as input, but it fails with a `Flag length mismatch` exception.

Now we can try to find the length of the flag and where all of this happens;
at line 178 we can find where the input is taken:
```sml
val l = Option.getOpt (TextIO.inputLine TextIO.stdIn, "NONE\n");
```

This is used as argument to the function at line 141, where it compares the length of the input with **29**,
we can now start to recover some names, like `flag` and `flag_len`.

After running with a string of the correct length (28, because the 29th is the newline), we see a variable that holds an list of tuples of string and a number,
where the strings are "l" times their index+1 and the number is the ascii representation of the equivalent character.
so we can deobfuscate thi function in something like this:
```sml
fun repeat_string(n: int): string =
	if n <= 0 then ""
	else "l" ^ repeat_string (n - 1)


fun init(flag: string) =
	let
		val len = String.size flag
	in
		if len = flag_len then
			let
				val arr = Array.array (flag_len + 1, ("", 0)) 
				fun fillArray i =
					if i < flag_len then
						(Array.update (arr, i, ((repeat_string (i+1)), Char.ord (String.sub (flag, i))));
						 fillArray (i + 1))
					else if i = flag_len then
						(Array.update (arr, i, ("llllllllllllllllllllllllllllll", 1));
						 fillArray (i + 1))
					else
						arr
				fun arrayToList arr = Array.foldr (op ::) [] arr
			in
				arrayToList (fillArray 0)
			end
		else
			raise Fail "Flag length mismatch"
	end;
```

Now in the function the last thing remaining that is not that obvious, is `llllllllllllllllllllllllllllll`,
that we can find in the function below that is called at the end of the program,
So we can rename th unkown string as `correct` because of the print in the function,
and after looking into the other called function we can end up with something like:

```sml
fun check(result:(string * int) list) =
	let
		val correct = findElementByKey("correct", result)
	in
		if correct = 1 then
			print "Correct!\n"
		else
			print "Skill Issue!\n"
	end;
```

```sml
exception NotFoundException;
fun findElementByKey(key: string, lst: (string * int) list): int =
	case lst of
		[] => raise NotFoundException
		| (k,v) :: rest =>
			if k = key then
				v
			else
				findElementByKey(key, rest);
```

## Type Deobfuscation

We observe that the type `(string * int) list` is used throughout the program, suggesting that it serves as some sort of context or environment.
To simplify our analysis, we can assign generic names to various types for now, such as `type_1`, `type_2`, and for subtypes, `type_1_1`, `type_1_2`, etc.
Following this approach, we define the type structures accordingly.
```sml
datatype type_1 = type_1_1 of int | type_1_2 of string | type_1_3 of type_1 * type_1 | type_1_4 of type_1 * type_1 | type_1_5 of type_1 * type_1 | type_1_6 of type_1 * type_1;
datatype type_2 = type_2_1 | type_2_2 | type_2_3 of type_2 * type_2 | type_2_4 of type_2 * type_2 | type_2_5 of type_2 | type_2_6 of type_1 * type_1 | type_2_7 of type_1 * type_1 | type_2_8 of type_1 * type_1;
datatype type_3 = type_3_1 | type_3_2 of type_3 * type_3 | type_3_3 of string * type_1 | type_3_4 of type_2 * type_3 * type_3 | type_3_5 of type_2 * type_3 | type_3_6 | type_3_7 of type_3;
datatype type_4 = type_4_1 | type_4_2 of type_3 * type_4;
```

Upon closer examination of the functions, we notice that the first function operates on a `type_1` variable and includes cases for all its variants, similar to a tagged enum in other languages.
Likewise, the second function follows the same pattern for `type_2`, and so forth.

We can now attempt to deobfuscate these functions further.

Looking at the first function, we see that `type_1_1` simply unpacks its value, which must be an `int` (as inferred from the function’s type).
Most of the other subtypes recursively call the function while performing mathematical operations.
The exception is `type_1_2`, which, given a string, retrieves its corresponding value from the environment.

This suggests that type_1 represents an expression type, encompassing constants, mathematical operations, and variables (similar to objects).
We can rename all related elements accordingly.
```sml
datatype Exp = Const of int | Var of string | Sum of Exp * Exp | Sub of Exp * Exp | Mul of Exp * Exp | Div of Exp * Exp;

fun evalExp(E:(string * int) list, ll:Exp):int = 
	case ll of
		Const v => v
		| Var v => findElementByKey(v, E)
		| Sum (v1, v2) => evalExp(E, v1) + evalExp(E, v2)
		| Sub (v1, v2) => evalExp(E, v1) - evalExp(E, v2)
		| Mul (v1, v2) => evalExp(E, v1) * evalExp(E, v2)
		| Div (v1, v2) => evalExp(E, v1) div evalExp(E, v2);
```

For the second function, we can apply a similar approach and determine that it operates on boolean values.
```sml
datatype Bool = True | False | And of Bool * Bool | Or of Bool * Bool | Not of Bool | Eq of Exp * Exp | Gt of Exp * Exp | Lt of Exp * Exp;

fun evalBool(E:(string * int) list, ll:Bool):bool =
	case ll of
		True => true 
		| False => false
		| And (lll,llll) => evalBool(E, lll) andalso evalBool(E, llll)
		| Or (lll,llll) => evalBool(E, lll) orelse evalBool(E, llll)
		| Not lll => not(evalBool(E, lll))
		| Eq (lll,llll) => evalExp(E, lll) = evalExp(E, llll)
		| Gt (lll,llll) => evalExp(E, lll) > evalExp(E, llll)
		| Lt (lll,llll) => evalExp(E, lll) < evalExp(E, llll);
```

The third function is more complex, as its return type is the environment itself.
Considering that it modifies the environment, we can reasonably assume that `type_3` represents instructions.

Now, we analyze these instructions:
- The first case is a nop/skip operation since it does nothing and returns the environment unchanged.
- The second case evaluates two expressions sequentially, where the first function call updates the environment before the second function call operates on it. This suggests a sequence operation.
- The third case evaluates the first value, then inserts it at the beginning of the environment, making it similar to an assignment.
- The next case resembles an `if` statement, as indicated by its structure.
- The following case is trickier: it evaluates a boolean expression, and if the result is `false`, it returns immediately; otherwise, it evaluates a sequence of statements before recursively executing itself. This clearly represents a `while` loop.

```sml
fun evalProgram(E:(string * int) list, ll:Program):((string * int) list) = 
	case ll of
		Skip => E
		| Seq (lll,llll) => evalProgram(evalProgram(E, lll), llll)
		| Assign (lllll, llllll) => (lllll, evalExp(E,llllll)) :: E
		| If (lllllll, llllllll, lllllllll) => if evalBool(E, lllllll) then evalProgram(E, llllllll) else evalProgram(E, lllllllll)
		| While (lllllll, lll) => if evalBool(E, lllllll) then evalProgram(E, Seq(lll, ll)) else E
		| type_3_7 lll => evalProgram(E, lll)
		| type_3_6 => E;
```

Now, stepping into the next functions, we find that they behave similarly but also incorporate `throw` and `callcc`.
A quick search reveals that these are [continuation](https://en.wikipedia.org/wiki/Continuation) primitives.
Examining their implementation, we determine that the function executes an instruction and then returns, except for the last two cases:
- One case executes all the instructions it contains.
- The other returns itself.


At this point, it is useful to see where this function is called.
We find that it is invoked by `llllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll`, which is simply a wrapper around callcc,
and that this, in turn, is called by `lllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllll`.
In the latter function, after calling the wrapper on the first element of the `type_4` parameter, additional operations are performed.

Examining `type_4`, we observe that it is simply a list of `Program` elements.
Given that we are dealing with a list of programs, where only one instruction is executed at a time, we can make an educated guess:

It resembles a basic threading system.

Supporting this hypothesis, we see that one function checks whether the next instruction (ignoring sequence wrappers) is a block operation.
It iterates over all programs, verifying if they are at the same block operation or at the end of the list.
Thus, the block operation likely serves as a barrier or synchronization mechanism.

Further analysis of the remaining functions confirms this assumption.

```sml
datatype Program = Skip | Seq of Program * Program | Assign of string * Exp | If of Bool * Program * Program | While of Bool * Program | Sync | Crit of Program;
datatype Thread = Null | Th of Program * Thread;
```

In conclusion, we can define the final types as follows:
- `Program`, representing the sequence of operations, including assignment, loops, and synchronization primitives.
- `Thread`, representing individual execution flows.
This allows us to fully analyze the execution environment and understand how the program processes the final, single-line command at the end of the file.

## Reverse of the Main Logic

Now that we have deobfuscated the program is time to understand what is actually doing into the executed section;
for this we will use a script to help us with the names.
First we start with the list of names that we found previosly:
```sml
datatype Exp = Const of int | Var of string | Sum of Exp * Exp | Sub of Exp * Exp | Mul of Exp * Exp | Div of Exp * Exp;
datatype Bool = True | False | And of Bool * Bool | Or of Bool * Bool | Not of Bool | Eq of Exp * Exp | Gt of Exp * Exp | Lt of Exp * Exp;
datatype Program = Skip | Seq of Program * Program | Assign of string * Exp | If of Bool * Program * Program | While of Bool * Program | Sync | Crit of Program;
datatype Thread = Null | Th of Program * Thread;
```

```py
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
```

Now we can replace the obfuscated names with their correct ones:
```py
start = 'val lll = '
ast = code[179][len(start):-1]

subs = sorted(operations.items(), reverse=True)
	
for sub, name in subs:
	ast = ast.replace(sub, name)

flag_chars = [f'"{ "l" * (i+1) }"' for i in range(29)]
for i in range(len(flag_chars)-1, -1, -1):
	ast = ast.replace(flag_chars[i], f'"c_{i}"')
ast = ast.replace('l' * 30, f'correct')
```

If we print the AST, we can now see what the program is doing. The first step is to split the threads so they can be analyzed separately.
After splitting, we observe that each thread performs operations of the same type, except for the last one, which is slightly longer. We will analyze it later.

The blocks perform mathematical operations on each flag character, one time for character per block.
Additionally, we notice **syncs** and **crits**, which indicate that the threads are executed in rounds as follows:
`[t1] -> [t2] -> [t3, t4, t5, t6] -> [t7] -> [t8] -> [t9]`.
Only the third group of threads runs in parallel. However, after analyzing the mathematical operations they perform, we see that they consist solely of addition and subtraction, meaning we can serialize them.

Now that we understand what each thread does and when it executes (except for the last one), we can extract the values from these blocks:
```py
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
```

For the last block, we observe many **if** statements. We can split them to analyze their purpose.
Most of them assign the `correct` value based on previous conditions. After filtering these out, we are left with many multiplications, sums, and comparisons.
After analyzing the logic, we find that each **if** statement represents an equation where the unknowns are the characters of the flag.
Since we have multiple equations, we can solve them using **Z3**.

First, we filter out the equations:
```py
last_block = [check for check in blocks[-1].split('If') if 'correct' not in check][1:]
```

Next, we write an equation extractor for the remaining statements:
```py
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
```

Now, we extract all equations and feed them into the **Z3** solver:
```py
from z3 import *

flag_chars = [BitVec(f'c_{i}', 16) for i in range(29)]
s = Solver()

for sub_block in last_block:
	values, const = extract_equation(sub_block)
	equation = 0
	for var, val in values.items():
		equation += val * flag_chars[var]
	s.add(equation == const)
```

Then, we check if a valid solution exists:
```py
print('Checking...')
if s.check() == sat:
	print('Sat')
	m = s.model()
	flag = [m[c].as_long() for c in flag_chars]
else:
	print('Unsat')
	exit(1)
```

With the system solved, we can retrieve the operations from previous threads:
```py
SUM = 0
SUB = 1
MUL = 2
signs = [SUM, MUL, SUB, SUM, SUB, SUB, MUL, SUM]
```

And invert them:
```py
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
```

Finally, we cast the flag and win:
```py
print(flag)
print(bytes(flag))
```

## Final Solve Scipt

```py
file = 'dist/LLL.sml'
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
```

## Flag

`TRX{while_language_is_funny}`
