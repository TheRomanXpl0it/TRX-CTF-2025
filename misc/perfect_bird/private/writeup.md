# Perfect Bird

## Challenge Description

As a *bird* soaring through the sky, you seek the *perfect language*, and then... you find this

## Analysis
When we examine the challenge file, we immediately notice that it has a `.db3` extension and is quite large. Opening it with a text editor reveals a strange-looking language that initially appears obfuscated. Our first step is to determine what language this is.

Given the `.db3` file extension and the challenge description, which mentions the **perfect language** and emphasizes the word **bird**, we perform a quick search. This leads us to conclude that the language in question is [**DreamBerd**](https://github.com/TodePond/GulfOfMexico), an eso-lang.

### Static Analysis
After reviewing DreamBerd's specifics, we realize that there is no way to execute the program directly, so we opt for static analysis instead.

Examining the code, we observe that the variable `42` is used as an index for `m`. The declaration of `m` appears at the end of the file (line 34434) as an array of numbers:
`[205, 242, 231, 208, 235, 150, 5, 14, 162, 115, 134, 81, 118, 138, 49, 16, 54, 142, 80, 102, 139, 35, 127, 83, 52, 106, 200, 185, 153, 203, 34, 66, 62, 12, 7, 166, 34, 81, 250]`
The next line of the code prints this array, suggesting that myabe represents the flag for the challenge. Upon further analysis, we see that the rest of the code repeatedly executes the same operation inside an `if` statement that is always **True**:
```c
if (;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;42) {
    const var v = m[a-1]!!
    const var w = ((42 ^ v) % 256) ^ 0x89!!!
	m[a-1] = w!!!!
	const var a<-3> = 42 % 39!!
	42 += 1!
}
```
We simplify this snippet by renaming `42` as `i` and removing the redundant `!` symbols:
```c
const var v = m[a-1]
const var w = ((i ^ v) % 256) ^ 0x89
m[a-1] = w
const var a<-3> = i % 39
i += 1
```
Rearranging the instructions for better readability and removing unnecessary keywords (`const` and `var`), we obtain:
```c
a = i % 39
v = m[a-1]
w = ((i ^ v) % 256) ^ 0x89
m[a-1] = w
i += 1
```
Since DreamBerd indexes arrays in an unusual way, we account for the **-1** offset and rewrite the logic in Python:
```py
index = i % 39
value = m[index]
result = ((i ^ value) % 256) ^ 0x89
m[index] = result
i += 1
```

## Writing the Solve Script
To extract and decode the flag, we implement the following approach:

- **Read the file**, remove `!` symbols, and strip unnecessary whitespace:
```py
file = "chall.db3"

with open(file, "r") as f:
	code = f.read().split("\n")
code = [c.strip().replace('!', '') for c in code]
```

- **Extract the `m` array** (or copy it directly):
```py
mem = list(map(int, code[-4].split('[')[1][:-1].split(', ')))
```

- **Extract the lines containing hardcoded values:**
```py
start = 'const var w = '
operations = [c[len(start):] for c in code if c.startswith(start)]
```

- **Implement the original code logic:**
```py
for i, op in enumerate(operations):
	num = int(op.split(' ^ ')[2], 16)
	addr = i % len(mem)
	mem[addr] = ((i ^ mem[addr]) % 256) ^ num
```

- **Cast and print the flag:**
```py
flag = bytes(mem).decode()
print(flag)
```

## Final Solve Script
```py
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
```

## Flag
`TRX{tHi5_I5_th3_P3rf3ct_l4nGU4g3!!!!!!}`
