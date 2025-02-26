# epic_gaming2
xored = b"\xe8\x9d\x8e\x8b\xbc\xd4\x8d"
key = [ 0xDE, 0xAD, 0xBE, 0xEF ]

part1 = [ xored[i] ^ key[i % len(key)] for i in range(len(xored)) ]
print(''.join([chr(c) for c in part1]))

text = "0n0_d@y_w3_w1ll_m33t"
text += " " * (44 - len(text))
part2_c = [
    0,  182,  260,  429,  796,  680,  1188,  1043,  1560,  1548,  1520,  2618,  1656,  2548,  2604,  2145,  3184,  2346,  2250,  4332,  2600,  2877,  1870,  3174,  3120,  2050,  2080,  4050,  3668,  4089,  3060,  2573,  3456,  2673,  3876,  4270,  4716,  2960,  4180,  4212,  4400,  4141,  6216,  3612,  28208,  24368,  16484,  24441,  13175,  30559,  27697,  24428,  13165,  29747,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  8224,  0,  0,  0,  0,  0,  0
]
part2 = ""

from string import printable
for i in range(1, 44):
    sum = part2_c[i] / i
    for c in printable:
        if ord(c) + ord(text[i]) == sum:
            part2 += c
            break

# aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1RZc0NLNEt4 => base64 => "https..."
part2 = "a" + part2 
print(part2)


# x = (fi + ti) * i
# fi = (x / i) - ti
print()
print(list(map(ord, text)))