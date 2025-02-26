import re
from z3 import *

# can be found at start/end of the bytecode
FLAG_SIZE = 44 

fd = open("clambc_out.txt")
bytecode = fd.readlines()
fd.close()

# at line 1833 we start with the constants which end at line 3606 
# they are formatted like so, we want the id inside the [] and the number, we should also handle the negative numbers
# 1771 [3545]: 4294967295(0xffffffff)
constants = {}
for line in bytecode[1833:3606]:
    m = re.match(r"\d+ \[(\d+)\]: (\d+)\(\.*", line.strip())
    if m:
        key = int(m.group(1))
        value = int(m.group(2))
        if value > 0xffff0000: # horrible way to do this but it works 
            value = value - 0x100000000
        constants[key] = value
    else:
        print(line.strip(), m)
        print("Error in regex")
        exit(-1)



# now we start parsing the bytecode
# we only care about the conditions immediatly after the seek so we start at 3627 and end at 5074
# we can skip the first check which got rearranged by the compiler, we have more than enough information
s = Solver()
flag = [BitVec(f"f{i}", 8) for i in range(FLAG_SIZE-5)]

pos = -1    # index of the flag
res = 0     # result of the operation
value = 0   # operand of the operation
for line in bytecode[3630:5074]:
    # print(line.strip())
    
    if "seek" in line: 
        # print(line.strip())
        # the first constant is the index of the flag, the second is either SEEK_SET or SEEK_END
        # 2   16  OP_BC_CALL_API      [33 /168/  3]  14 = seek[3] (1788, 1789)
        m = re.search(r"seek\[3\] \((\d+), (\d+)\)", line.strip())
        if m:
            offset = constants[int(m.group(1))]
            seek_type = constants[int(m.group(2))]

            # print(m.group(1), constants[int(m.group(1))])
            # print(m.group(2), constants[int(m.group(2))])

            if seek_type == 2: # SEEK_END
                assert offset < 0
                pos = offset + FLAG_SIZE + 1 - 5 # +1 because we ignore the } at the end, -4 beacuse we ignore the TRX{
            elif seek_type == 0: # SEEK_SET
                assert offset > 0
                pos = offset - 4 # -4 because we ignore the "TRX{" at the start
        else:
            print(line.strip())
            print("Error in seek regex")
            exit(-1)
    elif "OP_BC_AND" in line:
        # print(line.strip())
        # the only thing we need is the constant after the &
        # 2  885  OP_BC_AND           [11 / 56/  1]  883 = 882 & 2657
        m = re.search(r"\d+ = \d+ & (\d+)", line.strip())
        if m:
            value = constants[int(m.group(1))]

            # print(m.group(1), hex(constants[int(m.group(1))]))
        else:
            print(line.strip())
            print("Error in AND regex")
            exit(-1)   
    elif "OP_BC_ICMP_ULT" in line:
        # print(line)
        # again we only need the constant after the <
        #  2   33  OP_BC_ICMP_ULT      [25 /126/  1]  31 = (30 < 1805)
        m = re.search(r"\d+ = \(\d+ < (\d+)\)", line.strip())
        if m:
            res = constants[int(m.group(1))]
            
            s.add((flag[pos]) >= res) # the < needs to be false
            
            value = -1 # reset value
        else:
            print(line.strip())
            print("Error in AND regex")
            exit(-1) 

        value = -1

    elif "OP_BC_ICMP_NE" in line:
        # print(line.strip())
        # again we only need the constant after the !=
        #   2  1459  OP_BC_ICMP_NE       [22 /111/  1]  1457 = (1456 != 3231)
        m = re.search(r"\d+ = \(\d+ != (\d+)\)", line.strip())
        if m:
            res = constants[int(m.group(1))]
            
            if value > 0: # at least once the compiler has optimized away the end, handle the situation
                s.add((flag[pos] & value) == res)
            else:
                s.add((flag[pos]) == res)
            
            value = -1 # reset value
        else:
            print(line.strip())
            print("Error in AND regex")
            exit(-1) 

# print(s)
print(s.check())

m = s.model()
guess = ""
for i in range(len(flag)):
    guess += chr(m[flag[i]].as_long())

print("Got Flag: " + "TRX{" + guess + "}")
fd = open("flag.txt", "w")
fd.write("TRX{" + guess + "}")
fd.close()

print("Written to flag.txt")
