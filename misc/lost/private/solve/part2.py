xored = [189, 19, 122, 254, 80, 100, 184, 91]
key = [202, 34, 0]

for i in range(len(xored)):
    xored[i] ^= key[i % len(key)]

print(
    ('').join(map(chr, xored))
)