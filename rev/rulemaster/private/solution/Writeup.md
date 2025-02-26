# Challenge WriteUp

## Info

Title: RuleMaster

Difficulty: Medium

Category: Rev

## Description

I am tired of hackers evading my signatures, why don't you try triggering it for a change?

## Solution

The file given for the challenge is a ".cbc" with the magic bytes "ClamBC", which, with a bit of googling, we can easily find out that is a "ClamAV signature bytecode".

This is a feature offered by the ClamAV AntiVirus where an analyst can write a logical signature in C, which is then compiled into bytecode and added to the traditional signatures of the antivirus.

The first result of the google search is the (ClamBC)[https://linux.die.net/man/1/clambc] tool, installed with ClamAV, which is essential to the challenge.

The first thing one can try is the comand to extract the source code, which fails:
```
> clambc -p chall.cbc
Nice_try_but_it_cant_be_this_easy%
```

This is beacause the bytecode was compiled with a COPYRIGHT header, meaning the source code is not included in the bytecode.

For this reason we have to work with the bytecode which we can extract with the following command:
```
> clambc -c chall.cbc
```

Before looking at the bytecode we can check which is the initial signature that triggers the bytecode, which we can see with the following command:
```
> clambc --info chall.cbc
...
bytecode logical signature: The_RuleGod...{Congrats_You_got_it,It_just_needs_a_little_fixing-come_on,Perfect_form_now_we_just_need_whats_inside,Well_thats_a_start_but_its_not_quite_it_yet,You_read_the_CTF_rules_i_like_that};Engine:56-255,Target:0;0;0:5452587b
...
```

We can see at the end of the line after "Target" that the rule triggers when the file contains "5452587b", which is "TRX{", our flag format.

Now we can start looking at the bytecode, the bytecode is structured in several sections, only two are useful, the constants section and the function section. The function section contains the bytecode we need to reverse, the constants section contains the value of all the costants of the program which are going to be accessed by ID in the bytecode.

The first check is on the last character of the flag which needs to be equal to "}", and here alreay we can see that "bb.4" is the "FAIL" block so it's what we need to avoid.
```
0    1  OP_BC_CALL_API      [33 /168/  3]  3 = seek[3] (1775, 1776) -- constants[1775] = -1, constants[1776] = SEEK_END
0    2  OP_BC_CALL_API      [33 /168/  3]  4 = read[1] (p.1, 1777) -- constants[1777] = 1
0    3  OP_BC_COPY          [34 /171/  1]  cp 1 -> 5
0    4  OP_BC_ICMP_EQ       [21 /106/  1]  6 = (5 == 1778)  -- constants[1778] = "}"
0    5  OP_BC_COPY          [34 /174/  4]  cp 1779 -> 0
0    6  OP_BC_BRANCH        [17 / 85/  0]  br 6 ? bb.1 : bb.4
```

Next is the check on the size of the flag which is 44:
```
1    8  OP_BC_ICMP_EQ       [21 /108/  3]  8 = (3 == 1781) -- constants[1781] = 44
1    9  OP_BC_COPY          [34 /174/  4]  cp 1782 -> 0
1   10  OP_BC_BRANCH        [17 / 85/  0]  br 8 ? bb.2 : bb.4
```

Now after this we see a series of operation on value of the file which follow the following format:
```
2   20  OP_BC_CALL_API      [33 /168/  3]  18 = seek[3] (1792, 1793)
2   21  OP_BC_CALL_API      [33 /168/  3]  19 = read[1] (p.1, 1794)
2   22  OP_BC_COPY          [34 /171/  1]  cp 1 -> 20
2   23  OP_BC_AND           [11 / 56/  1]  21 = 20 & 1795
2   24  OP_BC_ICMP_NE       [22 /111/  1]  22 = (21 != 1796)
```
which is equal to:
```
seek(X, SEEK_SET/SEEK_END)
read(buf, 1)
check = (buf & Y) == Z
```
with the value of X,Y and Z all contained in the constants section.

Or:
```
2  1363  OP_BC_CALL_API      [33 /168/  3]  1361 = seek[3] (3135, 3136)
2  1364  OP_BC_CALL_API      [33 /168/  3]  1362 = read[1] (p.1, 3137)
2  1365  OP_BC_COPY          [34 /171/  1]  cp 1 -> 1363
2  1366  OP_BC_ICMP_UGT      [23 /116/  1]  1364 = (1363 > 3138)
```
which is equal to:
```
seek(X, SEEK_SET/SEEK_END)
read(buf, 1)
check = (buf > Y) 
```

And if we scroll all the way to the bottom, we can there the check is performed:
```
...
2  1759  OP_BC_SELECT        [31 /155/  0]  1757 = 1756 ? 3531 : 71)
2  1760  OP_BC_SELECT        [31 /155/  0]  1758 = 1757 ? 3532 : 67)
2  1761  OP_BC_SELECT        [31 /155/  0]  1759 = 1758 ? 3533 : 63)
2  1762  OP_BC_SELECT        [31 /155/  0]  1760 = 1759 ? 3534 : 59)
2  1763  OP_BC_SELECT        [31 /155/  0]  1761 = 1760 ? 3535 : 54)
2  1764  OP_BC_SELECT        [31 /155/  0]  1762 = 1761 ? 3536 : 50)
2  1765  OP_BC_SELECT        [31 /155/  0]  1763 = 1762 ? 3537 : 45)
2  1766  OP_BC_SELECT        [31 /155/  0]  1764 = 1763 ? 3538 : 41)
2  1767  OP_BC_SELECT        [31 /155/  0]  1765 = 1764 ? 3539 : 36)
2  1768  OP_BC_SELECT        [31 /155/  0]  1766 = 1765 ? 3540 : 31)
2  1769  OP_BC_SELECT        [31 /155/  0]  1767 = 1766 ? 3541 : 27)
2  1770  OP_BC_SELECT        [31 /155/  0]  1768 = 1767 ? 3542 : 22)
2  1771  OP_BC_SELECT        [31 /155/  0]  1769 = 1768 ? 3543 : 17)
2  1772  OP_BC_SELECT        [31 /155/  0]  1770 = 1769 ? 3544 : 1461)
2  1773  OP_BC_COPY          [34 /174/  4]  cp 3545 -> 0
2  1774  OP_BC_BRANCH        [17 / 85/  0]  br 1770 ? bb.4 : bb.3
```
which is just an efficient way of making sure that all the checks are equal to 0. Meaning that all the conditions above need to be False.

After noticing this we just need to write a parser that extracts all the conditions and passes then to z3 which is what i have done in the "solve.py" script.


Fun Fact: The AND contitions are by themselfs almost enough to get the flag, except for one character which is incorrectly capitalized, after adding the LESS condition the solution becomes correct.


