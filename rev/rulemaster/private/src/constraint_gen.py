import z3
import random 

CONSTRAINT_PER_LETTER = 8 
FLAG = open("../flag.txt").read().split("{")[1][:-1].encode("utf-8")
FLAG_SIZE = len(FLAG) + 5

print("Finding constraint for: ", FLAG)
print("Total flag len:", FLAG_SIZE)

# SEEK_MODES = ["SEEK_CUR", "SEEK_END", "SEEK_SET"]
SEEK_MODES = ["SEEK_END", "SEEK_SET"]
OPERATIONS = ["&", "|", "<"]
# OPERATIONS = ["&", "|"]

# constraint will look something like this
# we need to remember that there is an extra TRX{ at the start and an extra } at the end
'''
    seek(X, Y)
    read(buf, 1)
    if (buf |&<> Z != Z*)
        correct = 0
'''


print("Trying to find contraints...")
while True:
    constraints = []
    s = z3.Solver()
    guessed_flag = [z3.BitVec(f"f{i}", 8) for i in range(len(FLAG))]
    for i, f in enumerate(FLAG):
        for c in range(CONSTRAINT_PER_LETTER):

            offset = 0
            curr_constr = ""
            seek_type = random.choice(SEEK_MODES)
            if seek_type == "SEEK_END":
                offset = i - len(FLAG) - 1
            elif seek_type == "SEEK_SET":
                offset = i + 4
            else:
                print("Unsupported SEEK")
                exit(-1)

            curr_constr += f"seek({offset},{seek_type});\n"
            curr_constr += f"read(&buf, 1);\n" 
             
            op = random.choice(OPERATIONS)
            # op = OPERATIONS[c % len(OPERATIONS)] 
            value = random.randint(0, 255)
            if op == "&":
                res = f & value
                s.add(guessed_flag[i] & value == res)
                curr_constr += f"if ((buf {op} {value}) != {res})\n"
            elif op == "|":
                res = f | value
                s.add(guessed_flag[i] | value == res)
                curr_constr += f"if ((buf {op} {value}) != {res})\n"
            elif op == "<":
                res = f < value
                if res:
                    s.add(z3.ULT(guessed_flag[i], value))
                    curr_constr += f"if (buf >= {value})\n"
                else:
                    s.add(z3.UGE(guessed_flag[i], value))
                    curr_constr += f"if (buf < {value})\n" 
            # elif op == ">":
            #     res = f > value
            #     if res:
            #         s.add(z3.UGT(guessed_flag[i], value))
            #     else:
            #         s.add(z3.ULE(guessed_flag[i], value))
            else:
                print("Unsupported operation!")
                exit(-1)

            curr_constr += "\tcorrect = 0;"
            # print(op, value, "=", res)
            # print(s)

            constraints.append(curr_constr)
            # print(curr_constr)
            # print(constraints)

    # print(s)
    if s.check() == z3.sat:
        # print("Solved")
        m = s.model()
        guess = ""
        for i in range(len(guessed_flag)):
            guess += chr(m[guessed_flag[i]].as_long())

        # print(guess)
        if guess.encode("utf-8") == FLAG:
            print("Guess is equal to flag:", guess)

            print("Constraints:")
            random.shuffle(constraints)
            for s in constraints:
                print(s)
            exit(1)

        continue

    print("Not solvable", s.check())




