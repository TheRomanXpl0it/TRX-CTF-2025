# Molly

## Challenge Description
*yes, I play lego games while listening to music in my free time*

## Molly Overview
We are presented with two PE x86_64 binaries: `molly.exe` and `molly_dll.dll` 

Initially, disassembling `molly.exe` reveals a multitude of unusual instructions. Furthermore, the high entropy in the `.text` section suggests that the code is not standard executable code.

![static_first_view](img/static_first_view.png)


At this point running `molly.exe` produces the following output:
(binary is safe, you can also check VirusTotal)
```
@@@@@@@@@@@@@@@@@@@ , @@@@@@@@@@@@@@@@@@
@@@@@@@@@@@/  /////////////  /@@@@@@@@@@
@@@@@@@/ //*                 //. /@@@@@@
@@@@@  /       ///////// //      /  @@@@
@@@/ /     // //////////////       / /@@
@@ //    ///////  ////// /          /. @
@/ /    ////// /////*,.              / /
@ /    /////    //////////            /
, /    /////  //////////////          /
@ /    ///// ,//////////////          /
@/ /    ////  //////////             / /
@@ */    //   ////    /////         /, @
@@@/ /       ////     ,////        / /@@
@@@@@  /                *//      / .@@@@
@@@@@@@/  //                 //. /@@@@@@
@@@@@@@@@@@/  /////////////  /@@@@@@@@@@

> SYSTEM VALIDATION IN PROGRESS
> USER MUST INPUT THE VERIFICATION TOKEN molly.exe <token>
> SYSTEM STATE: STOPPING
> USE WITH CAUTION, NO FAILURES ALLOWED
```

### Note
Upon executing Molly with an incorrect token, the binary becomes corrupted and an additional executable named `why.exe` is generated.

At this point `molly_dll.dll` likely plays a critical role in unpacking or decrypting `molly.exe`, making it the logical starting point for further analysis.


## Molly Dynamic Overview
By setting a breakpoint at the entry point of `molly.exe` using x64dbg and examining the memory regions corresponding to the `.text` section, we observed that the section is fragmented. Some regions are marked as `NO_ACCESS`, while others have a fixed size of <b>0x1000</b> with `READ_EXECUTE` permissions. This suggests that molly.exe is not packed; rather, it is decrypted and executed at runtime.

![x64dbg_regions](img/x64dbg_regions.png)

## Dll Static Analysis
When the Windows loader calls an imported DLL with an entry point, it executes on the main thread before the process's own entry point. As a result, the process entry point will not run until all DLL entry points have completed.

Disassembling the dll_main function within `molly_dll.dll` reveals a call to `GetProcAddress` for resolving `KiUserExceptionDispatcher`:
```as 
call    qword [rel GetCurrentProcess]
lea     rcx, [rel data_180006c48]  {"ntdll.dll"}
mov     rbx, rax
call    qword [rel GetModuleHandleA]
test    rax, rax
je      0x180002fb3

lea     rdx, [rel data_180006c58]  {"KiUserExceptionDispatcher"}
mov     rcx, rax
call    qword [rel GetProcAddress]
mov     qword [rel KiUserExceptionDispatcher_Add], rax
test    rax, rax
je      0x180002fb3
```

The resolution of `KiUserExceptionDispatcher` implies that `molly_dll.dll` is involved in Windows exception handling, which could be key to its runtime decryption capabilities. Also no standard exception handler appears to be registered... Let's look deeper


An effective obfuscation technique observed in `molly_dll.dll` is the inline use of system calls, which "obscures" the actual API functions being utilized:
```as
mov     eax, 0x1c
mov     r10, rcx
syscall 
retn     {__return_addr}
```

After looking for `eax, 0x1c` syscall signature inside `ntdll.dll` we can confirm this function is a reimplementation of `NtSetInformationProcess`

```as
lea     rax, [rel sub_1800030b0]
mov     r9d, 0x10
mov     qword [rsp+0x28 {var_10_1}], rax  {sub_1800030b0}
lea     r8, [rsp+0x20 {infostruct}]
xor     eax, eax  {0x0}
mov     edx, 0x28
mov     rcx, rbx
mov     qword [rsp+0x20 {infostruct}], rax  {0x0}
call    NtSetInformationProcess
```

`NtSetInformationProcess` is invoked with the undocumented `PROCESSINFOCLASS` value <b>0x28</b>, which is responsible for setting an InstrumentationCallback in the process structure. 

The function `sub_1800030b0` acts as this callback, being invoked during a kernel-mode to user-mode transition with a special register `r15` that points to the target user-mode function.

```as
ic_hook:
push    r10 {var_8_1}
push    rax {var_10}
pushfq   {var_18}
push    rbx {__saved_rbx}
mov     rbx, rsp {__saved_rbx}
lea     rax, [rel ic_hook_handler]
cmp     rcx, rax
cmove   rcx, r10
lea     r10, [rsp-0xc0 {var_e0}]
and     r10 {var_e0}, 0xfffffffffffffff0
mov     rsp, r10
cld     
sub     rsp, 0x60
mov     qword [rsp {var_140}], rcx
mov     qword [rsp+0x8 {__saved_rdx}], rdx
mov     qword [rsp+0x10 {__saved_rdi}], rdi
mov     qword [rsp+0x18 {__saved_rsi}], rsi
mov     qword [rsp+0x20 {__saved_r8}], r8
mov     qword [rsp+0x28 {__saved_r9}], r9
mov     qword [rsp+0x30 {__saved_r11}], r11
mov     qword [rsp+0x38 {__saved_r12}], r12
mov     qword [rsp+0x40 {__saved_r13}], r13
mov     qword [rsp+0x48 {__saved_r14}], r14
mov     qword [rsp+0x50 {__saved_r15}], r15
sub     rsp, 0x60
movaps  xmmword [rsp {__saved_zmm0}], xmm0
movaps  xmmword [rsp+0x10 {__saved_zmm1}], xmm1
movaps  xmmword [rsp+0x20 {__saved_zmm2}], xmm2
movaps  xmmword [rsp+0x30 {__saved_zmm3}], xmm3
movaps  xmmword [rsp+0x40 {__saved_zmm4}], xmm4
movaps  xmmword [rsp+0x50 {__saved_zmm5}], xmm5
mov     rdx, qword [rbx+0x10 {var_10}]
mov     rcx, qword [rbx+0x18 {var_8_1}]
call    ic_hook_handler
mov     qword [rbx+0x18 {var_8}], rax
movaps  xmm0, xmmword [rsp {__saved_zmm0}]
movaps  xmm1, xmmword [rsp+0x10 {__saved_zmm1}]
movaps  xmm2, xmmword [rsp+0x20 {__saved_zmm2}]
movaps  xmm3, xmmword [rsp+0x30 {__saved_zmm3}]
movaps  xmm4, xmmword [rsp+0x40 {__saved_zmm4}]
movaps  xmm5, xmmword [rsp+0x50 {__saved_zmm5}]
add     rsp, 0x60
mov     rcx, qword [rsp {var_140}]
mov     rdx, qword [rsp+0x8 {__saved_rdx}]
mov     rdi, qword [rsp+0x10 {__saved_rdi}]
mov     rsi, qword [rsp+0x18 {__saved_rsi}]
mov     r8, qword [rsp+0x20 {__saved_r8}]
mov     r9, qword [rsp+0x28 {__saved_r9}]
mov     r11, qword [rsp+0x30 {__saved_r11}]
mov     r12, qword [rsp+0x38 {__saved_r12}]
mov     r13, qword [rsp+0x40 {__saved_r13}]
mov     r14, qword [rsp+0x48 {__saved_r14}]
mov     r15, qword [rsp+0x50 {__saved_r15}]
add     rsp, 0x60
mov     rsp, rbx
pop     rbx {__saved_rbx}
popfq   
pop     rax {var_10}
pop     r10 {var_8}
jmp     r10
```

The function in the middle is responsible for setting the return address. Basically, the argument it receives is the original return address and it compares it against one specific target function `(KiUserExceptionDispatcher)`, if the addresses match up, then it returns a new hook otherwise it returns the argument passed.

### ki_user_exp_stub
```
cld     
lea     rcx, [rsp+0x4f0 {exp_record}]
mov     rdx, rsp {__return_addr}
call    ki_user_exp_hook
test    rax, rax
je      0x1800031c0

jmp     rax

cld     
mov     rcx, rsp {__return_addr}
mov     rdx, 0x0
call    RtlRestoreContext  {ic_hook_handler}
```
### ki_user_exp_hook
```c
if (exp_record->ExceptionCode == STATUS_ACCESS_VIOLATION && exp_record->ExceptionAddress)
{
    uintptr_t page_base = exp_record->ExceptionInformation[1] & 0xfffffffffffff000;
    
    if (sub_180004110(&page_guard, page_base))
    {
        if (_Mtx_lock(&encryption_mutex))
        {
            std::_Throw_Cpp_error(5);
            /* no return */
        }
        
        if (data_18000a05c == 0x7fffffff)
        {
            data_18000a05c = 0x7ffffffe;
            std::_Throw_Cpp_error(6);
            /* no return */
        }
        
        sub_180003bd0(&page_guard, page_base);
        sub_180003de0(&page_guard);
        int64_t result = _Mtx_unlock(&encryption_mutex);
        exp_record->ExceptionCode = 0;
        exp_record->ExceptionFlags = 0;
        exp_record->ExceptionAddress = 0;
        exp_record->NumberParameters = 0;
        context->EFlags = 0xfe;
        return result;  // return 0
    }
}

return KiUserExceptionDispatcher_Add;
```

It is evident that `ki_user_exp_hook` handles `STATUS_ACCESS_VIOLATION` exceptions caused by attempts to access `NO_ACCESS` pages, allowing `sub_180003bd0` to decrypt it. Once a guarded page is successfully decrypted, `ki_user_exp_stub` checks the return value from `ki_user_exp_hook`. If the value is 0, it calls `RtlRestoreContext` to restore the execution state, allowing the binary to continue execution.

> `sub_180004110` check if the page is a guarded_page <br>
> `sub_180003de0` is responsible to re-encrypts old pages, making runtime dumping "ineffective"

## Binary Static Decryptor 
Now let's look inside `sub_180003bd0`:
```c
void* decrypt_page(int32_t* arg1, uintptr_t page_base)

{
    page_base_1 = page_base;
    void* result = sub_1800035f0(arg1, &page_base_1);
    
    if (result)
    {
        int64_t r8_16 = (((((((((((((((uint64_t)page_base ^ 0xcbf29ce484222325) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 8)) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 0x10)) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 0x18)) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 0x20)) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 0x28)) * 0x100000001b3) ^ (uint64_t)(uint8_t)(page_base >> 0x30)) * 0x100000001b3) ^ page_base >> 0x38;
        int64_t* rcx_9 = ((*(uint64_t*)((char*)arg1 + 0x30) & (r8_16 * 0x100000001b3)) << 4) + *(uint64_t*)((char*)arg1 + 0x18);
        result = rcx_9[1];
        
        if (result == *(uint64_t*)((char*)arg1 + 8))
        {
            label_180003dcb:
            std::_Xout_of_range("invalid unordered_map<K, T> key");
            /* no return */
        }
        
        while (page_base != *(uint64_t*)((char*)result + 0x10))
        {
            if (result == *(uint64_t*)rcx_9)
                goto label_180003dcb;
            
            result = *(uint64_t*)((char*)result + 8);
        }
        
        if (*(uint8_t*)((char*)result + 0x18))
        {
            flNewProtect = 0x1000;
            dwSize = page_base;
            void* var_38_1 = &arg_8;
            VirtualProtect(GetCurrentProcess(), &dwSize, &flNewProtect, 4);
            uintptr_t page_base_2 = page_base;
            int64_t r10_1 = 0;
            int64_t i_1 = 0x1000;
            int64_t i;
            
            do
            {
                uint8_t rax_15 = *(uint8_t*)page_base_2;
                page_base_2 += 1;
                int64_t rcx_12 = r10_1;
                uint8_t rotated_nibble = rax_15 >> 4 | rax_15 << 4;
                int64_t rax_16;
                int64_t rdx_2;
                rdx_2 = HIGHQ(-0x7777777777777777 * r10_1);
                rax_16 = LOWQ(-0x7777777777777777 * r10_1);
                *(uint8_t*)(page_base_2 - 1) = rotated_nibble;
                r10_1 += 1;
                *(uint8_t*)(page_base_2 - 1) = rotated_nibble ^ page_guard_key[rcx_12 - (rdx_2 >> 3) * 0xf];
                i = i_1;
                i_1 -= 1;
            } while (i != 1);
            flNewProtect = 0x1000;
            dwSize = page_base;
            void* var_38_2 = &arg_8;
            VirtualProtect(GetCurrentProcess(), &dwSize, &flNewProtect, 0x20);
            return set_page_flag(arg1, page_base, false);
        }
    }
    
    return result;
}
```

MollyDll decryption routine is quite simple, it first xor using a known key and then rotate the byte nibbles.

We can write a simple python script that decrypt `molly.exe` .text section:
```py
import sys
import pefile

key = [0x66,0x6f,0x72,0x67,0x69,0x76,0x65,0x6d,0x65,0x66,0x61,0x74,0x68,0x65,0x72]
def invert_nibbles(b):
    return (b & 0xf0) >> 4 | (b & 0x0f) << 4 

def main():
    if len(sys.argv) != 2:
        sys.exit(1)

    pe_path = sys.argv[1]

    try:
        pe = pefile.PE(pe_path)
    except Exception as e:
        sys.exit(1)

    text_section = None
    for section in pe.sections:
        if b'.text' in section.Name:
            text_section = section
            break

    if text_section is None:
        sys.exit(2)

    data = bytearray(text_section.get_data())
    pages = text_section.SizeOfRawData // 0x1000
   
    for i in range(pages):
        offset = i * 0x1000
        for j in range(0x1000):
            data[offset + j] = invert_nibbles(data[offset + j])
            data[offset + j] ^= key[j % len(key)]

    pe.set_bytes_at_offset(text_section.PointerToRawData, bytes(data))
    pe.write('molly_dec.exe')
    
if __name__ == "__main__":
    main()
```

## Binary Dynamic Decryption (Bonus)
One interesting feature of Molly is its ability to re-encrypt old unlocked pages once the maximum number of decrypted pages has been reached. However, due to the binary’s size and an incorrectly set limit of `0x10`, Molly allowed 15 pages to remain decrypted, and no re-encryption occurs after the binary exits.

![encoldpages](img/molly_encoldpages.png)

How can we exploit this behavior?

First, configure x64dbg to establish breakpoints prior to Molly's start and before its termination, and disable the general exception breakpoint.
![dbg_dumppreparation](img/x64dbg_dump.png)

After running Molly, the console should close while the process remains active. Next, open Scylla to dump the process.
![scylla_dump](img/Scylla_dump.png)

Even if the binary is not fully decrypted, we can still analyze its core components to reconstruct the flag.

![molly_dump](img/molly_dump.png)

## Binary Analysis

Upon examining the main function, it becomes clear that Molly compiles and executes a Lua script containing custom functions: `epic_gaming1`, `epic_gaming2`, and `epic_gaming3`; and subsequently defines a global variable `flag` with the input provided when running the binary.

Beautified molly script:
```lua
local function a(b)
    local c = {}
    b = b:sub(5, -2)
    for d in string.gmatch(b, "[^_]+") do
        table.insert(c, d)
    end
    return c
end
local function e(f)
    if #f ~= 4 then
        return 1
    end
    local g = 100 + 89 - (84 - 608 / ((945 + 12 + 92 + 65 - 31) / 57) - 23) - 60
    local h = 2370000 / (12 + 93 - 95 / (646 / (85 - 3468 / 68))) / 100 - 52 - 63 - 71
    local i = 149 - (-15 + 8800 / (6248 / (125 - (104 - (17502 / (72 / 12) + 93) / 35 + 36))))
    local j = (52808 / (31 - 1800 / (51 - (95 - 448448 / (147 - 83) / 91) + 42)) - 20) / 66
    if string.char(g, h, i, j) ~= f then
        return 1
    end
    return 0
end
local k = a(flag) -- split content inside {} by _
local l = epic_gaming2(k[1]) -- run first part check (c side)
l = l + e(k[2]) -- run second part check (lua side)
l = l + epic_gaming3(k[3]) -- run third part check (c side)
l = l + epic_gaming1(k[4]) -- run fourth part check (c side)
return l

```

### epic_gaming2
```py
# epic_gaming2 solve
xored = b"\xe8\x9d\x8e\x8b\xbc\xd4\x8d"
key = [ 0xDE, 0xAD, 0xBE, 0xEF ]

part1 = [ xored[i] ^ key[i % len(key)] for i in range(len(xored)) ]
    
print(''.join([chr(c) for c in part1])) # 600dby3
```

```c
__int64 __fastcall epic_gaming2(__int64 a1)
{
  // ...
  if ( v3 == 7 )
  {
    *(_DWORD *)v10 = 0xEFBEADDE;
    *(_QWORD *)v11 = 0x8DD4BC8B8E9DE8LL;
    v4 = v11;
    v5 = 0;
    v6 = v2 - (_QWORD)v11;
    while ( 1 )
    {
      v7 = v4[v6];
      *v4 ^= v10[v5 & 3];
// ...
  return 1LL;
}
```
> 600dby3

### epic_gaming_lua
```lua
local g = 100 + 89 - (84 - 608 / ((945 + 12 + 92 + 65 - 31) / 57) - 23) - 60
local h = 2370000 / (12 + 93 - 95 / (646 / (85 - 3468 / 68))) / 100 - 52 - 63 - 71
local i = 149 - (-15 + 8800 / (6248 / (125 - (104 - (17502 / (72 / 12) + 93) / 35 + 36))))
local j = (52808 / (31 - 1800 / (51 - (95 - 448448 / (147 - 83) / 91) + 42)) - 20) / 66
print(string.char(g, h, i, j))
```
> `d3@r`

### epic_gaming3
```c
&& ((unsigned __int16)v2[1] | (unsigned __int16)(*v2 << 8)) == COERCE_INT('0p')
    && ((unsigned __int16)v2[3] | (unsigned __int16)(v2[2] << 8)) == COERCE_INT('3n')
    && ((unsigned __int16)v2[5] | (unsigned __int16)(v2[4] << 8)) == COERCE_INT('50')
    && ((unsigned __int16)v2[7] | (unsigned __int16)(v2[6] << 8)) == COERCE_INT('ur')
    && ((unsigned __int16)v2[9] | (unsigned __int16)(v2[8] << 8)) == COERCE_INT('c3') )
```
> `0p3n50urc3`

### epic_gaming1
```py
text = "0n0_d@y_w3_w1ll_m33t"
text += " " * (44 - len(text))
part2_c = [0, 182, 260, 429, 796, 680, 1188, 1043, 1560, 1548, 1520, 2618, 1656, 2548, 2604, 2145, 3184, 2346, 2250, 4332, 2600, 2877, 1870, 3174, 3120, 2050, 2080, 4050, 3668, 4089, 3060, 2573, 3456, 2673, 3876, 4270, 4716, 2960, 4180, 4212, 4400, 4141, 6216, 3612]
print(part2_c[:44])
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
```
> aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1RZc0NLNEt4

Final flag is `TRX{600dby3_d3@r_0p3n50urc3_aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L1RZc0NLNEt4}`


# Molly Revenge
Due to Molly dynamic dumping approach, Molly Revenge presents a hardened version of Molly, incorporating anti-debug checks, an new encryption/decryption routine, fewer unlocked pages limit, and rigorous flag integrity verification.

## Molly Revenge Decryptor
```py
import sys
import pefile
from Crypto.Cipher import ChaCha20

chacha_key = bytes([
    81, 90, 238, 246,
    49, 96, 101, 57,
    154, 226, 109, 170,
    143, 34, 55, 109,
    174, 11, 21, 112,
    250, 101, 27, 136,
    129, 218, 111, 100,
    38, 121, 11, 3
])
chacha_nonce = bytes([0xd0, 0, 0, 0, 0, 0, 0, 0])

def main():
    if len(sys.argv) != 2:
        sys.exit(1)

    pe_path = sys.argv[1]

    try:
        pe = pefile.PE(pe_path)
    except Exception as e:
        sys.exit(1)

    text_section = None
    for section in pe.sections:
        if b'.text' in section.Name:
            text_section = section
            break

    if text_section is None:
        sys.exit(2)

    data = bytearray(text_section.get_data())
    pages = text_section.SizeOfRawData // 0x1000
    
    
    for i in range(pages):
        offset = i * 0x1000
        cipher = ChaCha20.new(key=chacha_key, nonce=chacha_nonce) # fancy way to use ChaCha20 since nonce doesn't change
        data[offset:offset + 0x1000] = bytearray(cipher.decrypt(data[offset:offset + 0x1000]))
    

    pe.set_bytes_at_offset(text_section.PointerToRawData, bytes(data))
    pe.write('molly_revenge_dec.exe')
    
if __name__ == "__main__":
    main()
```

# Special Notes
Molly reimplements the Byfron Hyperion anti-tamper feature, originally adopted in Roblox, in a simpler CTF-style manner. *This explains the fancy descriptions.*

```
[Roblox] Developers,

We know how important anti-cheat and security are for you and the entire Roblox community. At RDC 1,7k, we announced that we’re turning our focus to cheat prevention. To help get us there, we’re thrilled to welcome Byfron, a leader in anti-cheat solutions, to Roblox. Together, we are combining forces to greatly expand Roblox’s anti-cheat capabilities.

Byfron has developed a state-of-the-art anti-cheat solution that is being utilized by some of the world’s largest game publishers. The team is also passionate about competitive gaming and security, so we think they’re going to be a great match for our community. With their deep domain knowledge and security engineering expertise, we will be accelerating our roadmap to build robust anti-cheat and security solutions. This includes client-side and server-side anti-cheat, alt accounts detection, and additional tools for developers to combat cheaters. Integrating Byfron’s technology into the Roblox platform will improve experience security, protect the competitive landscape, and to allow developers to spend more time building their experiences.

We look forward to sharing more in the coming months. In the meantime, please join us in welcoming Byfron to the Roblox community!
```