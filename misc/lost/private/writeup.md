# Lost

## Challenge Description
I once had a license for this script, but now all I have left is myself; just me and only me. I won’t get lost..
...

## Lost Overview
We are given a `lost.lua` script. A quick glance reveals that the script is obfuscated, and the **input flag** is defined as a global variable at the top (e.g., `FLAG=TRX{goodluck_...}`). According to the challenge description, this flag represents our license key.

To ensure the script works with various Lua versions, I tested it using different interpreters, including *luau* and *luajit 2.1.0*:

```
$$\                       $$\
$$ |                      $$ |
$$ | $$$$$$\   $$$$$$$\ $$$$$$\
$$ |$$  __$$\ $$  _____|\_$$  _|
$$ |$$ /  $$ |\$$$$$$\    $$ |
$$ |$$ |  $$ | \____$$\   $$ |$$\
$$ |\$$$$$$  |$$$$$$$  |  \$$$$  |
\__| \______/ \_______/    \____/

this flag is weird, try again!
[never exit]
```
The script runs correctly on these interpreters, so we can proceed with examining its output.

It seems that the script does not like the default flag. I even tried running it without setting a flag:
```
...
Make sure to set the FLAG variable before running the challenge!
Ex: FLAG = 'TRX{goodluck}';
```

At the end of the script, there is a long encoded string that appears to be compressed data used during execution. For now, we treat it as **bytecode**

## Lost First Analysis
Before diving into the complexities of `lost`, we set up a proper environment for analysis. The first step is to beautify the script.  
> There are many tools available online or on GitHub <br>for example: [lua-beautifier](https://goonlinetools.com/lua-beautifier/).


Now when making sure that the script still work we will notice that executing the beautified version doesn't give us the expected output, at this point we need to figure out wheter is the beautified output problem or script integrity check...

I tried a simple modification by extending the second line (for example, to `200`). Running the script still produced the same behavior, confirming that an integrity check is indeed in place.

*Returning to the beautified script..*

Next, we set up a hook library to trace which library functions are used and where:

```lua
local dbg_getinfo = debug.getinfo;
local str_format = string.format;
local tbl_foreach = table.foreach;

local function hook_library(library_name, meta_methods)
    local old_library = _G[library_name];
    local new_mt = {};
    new_mt.__old = old_library;
    new_mt.__name = library_name;
    for k, v in pairs(meta_methods) do
        new_mt[k] = v;
    end;
    _G[library_name] = setmetatable({}, new_mt)
end;

local general_meta_logger = {
    __index = function(self, idx)
        local mt = getmetatable(self);
        local index_line = dbg_getinfo(2).currentline;
        print(str_format("__index: %s; index: %s from line %d", mt.__name, idx, index_line));
        local value = mt.__old[idx];
        return value;
    end;
    __newindex = function(self, idx, value)
        local mt = getmetatable(self);
        print(str_format(
            "__newindex: %s; index: %s; old value: %s, value: %s from line %d", 
            mt.__name, idx, mt.__old[idx], value, dbg_getinfo(2).currentline
        ));
        mt.__old[idx] = value;
    end;
}

-- hooks
hook_library("debug", general_meta_logger)
hook_library("string", general_meta_logger)
hook_library("math", general_meta_logger)
hook_library("table", general_meta_logger)
hook_library("io", general_meta_logger)
hook_library("os", general_meta_logger)
hook_library("coroutine", general_meta_logger)
```
> Note: This hook method works on LuaJIT but not on Luau, which enforces strict sandbox rules that prevent overwriting libraries.

The hook output reveals interesting logs:
```
__index: table; index: concat from line 59
__index: math; index: ldexp from line 60
__index: table; index: insert from line 68
__index: debug; index: getinfo from line 457
__index: debug; index: getinfo from line 1887
```

It appears the script uses `debug.getinfo` to retrieve context information. Although we could further hook debug.getinfo to see which fields are accessed, but only currentline, lastlinedefined, and linedefined are relevant for the integrity check.

By removing `debug.getinfo` via our hook, we notice the script attempting to use `debug.traceback`. At this point, we undefine `debug` library to see how the script behaves:

```lua
-- FLAG = "...
-- one of those two methods is fine
_G["debug"] = nil;
debug = nil
-- script...
```
Running the beautified script now works flawlessly.
> Note: The script doesn’t crash if the debug library is missing, that's for env compatibility reasons.

### Beautifier Check Logic
Here is the reconstructed integrity check logic:
```lua
if debug then
    if debug.getinfo(1).currentline > 100 or tonumber(debug.traceback():match(':(%d+)')); then
        -- CRASH();
    end;
end
```

At this point, I searched for a `while true do` loop and, unsurprisingly, found one. This strongly suggests that the script implements a VM cycle that executes instructions:

```lua
while true do
    c = l[e]
    t = c.H
    if t <= 101 then
        if t <= 50 then
            if t <= 24 then
                if t <= 11 then
                    if t <= 5 then
                        if t <= 2 then
                            if t <= 0 then
                                local i
                                local t
                                -- mov operation on stack
                                S[c.c] = S[c.S] 
                                -- increasing pc
                                e = e + 1 
                                -- changing current instruction
                                c = l[e] 
```
> Instructions seem to be located using a binary search, and there are two types of program counters: one for retrieving instruction data (instruction pc) and one for locating the instruction operation (instruction vmpc).

## Lost VM Analysis
Based on our observations, we expect the script to deserialize bytecode and load constants and instructions.

Scrolling up in the main VM cycle, we find the following logic:
```lua
for l = 1, c do
    local e = i()
    local c
    -- deserialize constants based on types
    if (e == 0) then
        c = (i() ~= 0)
    elseif (e == 3) then
        c = r()
    elseif (e == 2) then
        c = h()
    end
    -- store constants
    S[l] = c
end
for c = 1, e() do
    -- recursively deserialize protos inside the current proto
    t[c - 1] = Q() 
end
l.d = i()
for l = 1, e() do
    local S = i()
    local c = {H = n(), c = n(), nil, nil}
    -- deserialize instructions based on instruction type
    -- like: iABC, iABx, iAsBx, etc
    if (S == 0) then
        c.S = n()
        c.N = n()
    elseif (S == 1) then
        c.S = e()
    elseif (S == 2) then
        c.S = e() - (2 ^ 16)
    elseif (S == 3) then
        c.S = e() - (2 ^ 16)
        c.N = n()
    end
    -- store instruction
    o[l] = c
end
```


## Lost VM First Check

Our hook system revealed an interesting log from the *VM cycle*:

`__index: table; index: insert from line 459`

At this point we improve the hook system to also hook library functions
by doing so:
```lua
-- ...
__index = function(self, idx)
    local mt = getmetatable(self);
    local index_line = dbg_getinfo(2).currentline;
    print(str_format("__index: %s; index: %s from line %d", mt.__name, idx, index_line));
    local value = mt.__old[idx];

    -- target VM Instructions
    if index_line > 277 then
        if type(value) == "function" then
            return function(...)
                local call_line = dbg_getinfo(2).currentline;
                local func_name = mt.__name .. "." .. idx;
                -- we ignore string.sub and string.char
                if func_name == "string.sub" or func_name == "string.char" then
                    return value(...);
                end
                print("-----------VM CALL-----------")
                print(str_format("%s called from %d args: ", func_name, call_line))
                print(...)
                print("-----------------------------")
                return value(...);
            end;
        end
    end;

    return value;
end;
-- ...
```

By running the beautified script again we get the following logs:
```
-----------VM CALL-----------
table.insert called from 3725 args:
table: 0x010e2258       goodluck
-----------------------------
__index: table; index: insert from line 478
-----------VM CALL-----------
table.insert called from 3725 args:
table: 0x010e2258       aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF
-----------------------------
```
It seem like the script is inserting flag parts splitted by `_` inside a table, we will call this table `flag_parts`

Let's hook flag_parts to figure out where it is getting used
```lua
if t == 183 then
    -- vmpc 183
    local e = c.c
    local args = {o(S, e + 1, c.S)}
    local arg1, arg2 = args[1], args[2]
    if type(arg1) == 'table' and type(arg2) == "string" and getmetatable(arg1) == nil then
        setmetatable(arg1, {
            __storage = {},
            __index = function (self, idx)
                local idx_line = dbg_getinfo(2).currentline
                print(
                    str_format("access to flag_parts[%d] from %d", idx, idx_line)
                )
                local mt = getmetatable(self)
                local st = mt.__storage;
                return st[idx];
            end,
            __newindex = function(self, idx, value)
                local mt = getmetatable(self)
                local st = mt.__storage;
                st[idx] = value;
            end,
            __len = function(self)
                local mt = getmetatable(self)
                local st = mt.__storage;
                local idx_line = dbg_getinfo(2).currentline
                print(
                    str_format("#flag_parts detected from %d", idx_line)
                )
                return #st;
            end
        })
    end
    local mt = getmetatable(arg1)
    if mt then
        -- aka table.insert on our storage
        S[e](mt.__storage, arg2)
    else
        S[e](o(S, e + 1, c.S))
    end
end
```

With this new hook in place we can find where operations on *flag_parts* are coming:

log: `#flag_parts detected from 1214`

Going to line `1214` in my beautified script I find the following instruction:
```lua
if t <= 44 then
    -- vmpc 44
    S[c.c] = #S[c.S]
end
```
We can look for the next instruction *vmpc* by incrementing the *pc*
> we expect it to be a check on the len(flag_parts)

```lua
if t <= 44 then
    -- vmpc 44
    S[c.c] = #S[c.S]
    local next_inst = l[e + 1]
    local next_vmpc = next_inst.H
    print("#flag_parts next vmpc " .. tostring(next_vmpc))
end
```
log: `#flag_parts next vmpc 35`

Now let's look at vmpc 35
```lua
else
    -- vmpc 35
    if (S[c.c] == n[c.N]) then
        e = e + 1
    else
        e = c.S
    end
end
```

Wow we discovered an equality check: `S[c.c] == n[c.N]`. Let's examine the operand values:

* `S[c.c] = 2`;
* `n[c.N] = 4`;`

Now to confirm this check we could patch *vmpc 35* or just add two more parts to our flag.. 

## Lost VM Part 1

By changing `FLAG` to `'TRX{good_luck_test_aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF}';`, We notice a new output from the script, which indicates that we have successfully moved on to another check!

```
access to flag_parts[1] from 478
...
3 characters, 3 bytes... easy right?
```

which we can approach as the same way we used:
```lua
elseif t == 10 then
    -- vmpc 10
    S[c.c] = S[c.S][n[c.N]]
    local next_inst = l[e + 1]
    local next_vmpc = next_inst.H
    print("flag_parts[1] next vmpc " .. next_vmpc) -- vmpc 44
else
```

We notice *vmpc 10* is getting the first flag part and then getting its len from *vmpc 44* and then move to *vmpc 132*

```lua
else
    -- vmpc 132
    print("vmpc 132", S[c.c], "~=", n[c.N]) -- vmpc 132        4       ~=      3
    if (S[c.c] ~= n[c.N]) then
        e = e + 1
    else
        e = c.S
    end
end
```

Thanks to this check we can confirm the first flag part need to be 3 bytes long

New output:
```
...
do you like xor?
```

It seem we are not getting any interesting log and we need a new approach to figure out what is going on with the first flag part

Let's log all unique vmpc that are getting executed when a special flag is toggled on

```lua
local log_current_function = false;
local logged_instructions = {}
while true do
    c = l[e]
    t = c.H
    if log_current_function and logged_instructions[t] == nil then
        print(str_format("%s: pc %d\tvmpc %d", dbg_getinfo(1).func, e, t))
        logged_instructions[t] = true;
    end
    -- ...
```

Let's toggle `log_current_function` from vmpc 132

```lua
if (S[c.c] ~= n[c.N]) then
    e = e + 1
else
    e = c.S
    log_current_function = true;
end
```
```
vmpc 132        3       ~=      3
function: 0x010c61d0: pc 1436   vmpc 99
function: 0x010c61d0: pc 1437   vmpc 73
function: 0x010c61d0: pc 1439   vmpc 152
function: 0x010c61d0: pc 1445   vmpc 32
function: 0x010c61d0: pc 1447   vmpc 1
function: 0x010c61d0: pc 1454   vmpc 2
function: 0x010c61d0: pc 1466   vmpc 54
function: 0x010c61d0: pc 1467   vmpc 0
function: 0x010c61d0: pc 1478   vmpc 56
__index: string; index: sub from line 1369
__index: string; index: char from line 1375
function: 0x010c61d0: pc 1495   vmpc 121
...
function: 0x010c61d0: pc 1574   vmpc 114
do you like xor?
```

From this log output we can notice how `string.index` and `string.sub` are used just before the script freezes. For this reason we inspect vmpc 0 and 56, the vmpcs likely causing the VM to jump to the crash function.

```lua
-- ...
if t <= 0 then
    -- vmpc 0
    -- ...
    c = l[e]
    t = c.c
    S[t] = S[t](o(S, t + 1, c.S)) -- xor8(flag_parts[1][1], 42)
    e = e + 1
    c = l[e]
    S[c.c] = n[c.S]
    e = e + 1
    c = l[e]
    t = c.c
    S[t] = S[t](o(S, t + 1, c.S)) -- bit32_test(flag_parts[1][1] ^ 42, 0x46)
    -- x ^ 42 = 70 -> x = 'l' flag_parts[1][1] == 'l'
    e = e + 1
    c = l[e]
    -- we can also change this to check if we bypass the check
    if not S[c.c] then 
        e = e + 1
    else
        e = c.S
    end
elseif t == 1 then
-- ...
```

We can now change the first part character to `l` and from the new output we can see we moved to another check:
```
function: 0x010c6ea8: pc 1578   vmpc 79
function: 0x010c6ea8: pc 1591   vmpc 56
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
....
bitwise operations are fun!
```

At this point we can go check vmpc 79
```lua
-- vmpc 79
-- ...
e = e + 1
c = l[e]
t = c.c
S[t] = S[t](o(S, t + 1, i)) -- check if flag_parts[1][2] == "a"
-- print(o(S, t + 1, i)) -- 97 => "a"
-- this will make the vm jmp to the next check
S[t] = true
```

New output after changing first part second character to `a`:
```
...
function: 0x00ec6e68: pc 1692   vmpc 204
function: 0x00ec6e68: pc 1700   vmpc 56
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
...
xor $r1, $r1 for the win!
```

```lua
-- vmpc 204
-- ...
S[t] = S[t](o(S, t + 1, c.S))
e = e + 1
c = l[e]
S[c.c] = n[c.S]
e = e + 1
c = l[e]
t = c.c
S[t] = S[t](o(S, t + 1, c.S))
-- print(o(S, t + 1, c.S)) -- flag_parts[1][3] == '4'
e = e + 1
c = l[e]
if (S[c.c] ~= n[c.N]) then -- flag_parts[1][3] check
-- ...
```

The first flag part is `lu4`!

# Lost VM Part 2

With the updated flag, the crash message changes to:

```
...
#flag_parts next vmpc 116
function: 0x010b6dd8: pc 1815   vmpc 116
function: 0x010b6dd8: pc 1818   vmpc 56
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
...
sorry, you can't spell magic
```

This corresponds to vmpc 116:
> Remember vmpc 116 ;)

```lua
elseif t > 115 then
    -- vmpc 116
    if e == 1815 then
        -- 1815 => check if #flag_parts[2] == 8
        print("vmpc 116", S[c.c], "~=", S[c.N], e)
    end
    if (S[c.c] ~= S[c.N]) then
        e = e + 1
    else
        e = c.S
    end
else
```

> Since vmpc is frequently used we need to filter its logs based on pc

Thanks to `#flag_parts` log and `vmpc 116` we know we are checking `#flag_parts[2] == 8`

The new output:
```
function: 0x00eb6b28: pc 1923   vmpc 93
function: 0x00eb6b28: pc 1936   vmpc 56
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
...
#flag_parts next vmpc 163
-----------VM CALL-----------
string.format called from -1 args:
0x%04X  1
-----------------------------
you are not a wizard 0x0001
```

Let's look at vmpc 93

```lua
elseif t == 93 then
    -- vmpc 93
    local is_1933 = e == 1933
    local i
    local t
    t = c.c
    i = S[c.S]
    S[t + 1] = i
    S[t] = i[n[c.N]]
    e = e + 1
    c = l[e]
    S[c.c] = S[c.S]
    e = e + 1
    c = l[e]
    t = c.c
    S[t] = S[t](o(S, t + 1, c.S))
    -- return value is the char at index arg2 inside flag_parts[2]
    -- we notice flag_parts[2] getting printed with a value that seem an index
    -- print(S[t], o(S, t + 1, c.S)) 
    e = e + 1
    c = l[e]
    S[c.c] = n[c.S]
    e = e + 1
    c = l[e]
    S[c.c] = S[c.S] - S[c.N] -- (idx-1)
    e = e + 1
    c = l[e]
    S[c.c] = n[c.S]
    e = e + 1
    c = l[e]
    S[c.c] = S[c.S] % S[c.N] -- (idx-1) % 3
    e = e + 1
    c = l[e]
    S[c.c] = S[c.S][S[c.N]] -- key[(idx-1) % 3]
    -- dump xor key
    local part2_key = ""
    for i=0, #S[c.S] do
        part2_key = part2_key .. tostring(S[c.S][i]) .. ", "
    end
    print(part2_key)
    e = e + 1
    c = l[e]
    t = c.c
    S[t] = S[t](o(S, t + 1, c.S)) -- xor(flag_parts[2][idx] ^ key)
    e = e + 1
    c = l[e]
    S[c.c] = S[c.S][S[c.N]] 
    -- dump the xor result
    local part2_xored = "";
    for i=1, #S[c.S] do
        part2_xored = part2_xored .. tostring(S[c.S][i]) .. ", "
    end
    print(part2_xored)
else
```

After dumping `part2_xored` and `part2_key` we can write a simple solve script
```py
xored = [189, 19, 122, 254, 80, 100, 184, 91]
key = [202, 34, 0]

for i in range(len(xored)):
    xored[i] ^= key[i % len(key)]

print(
    ('').join(map(chr, xored))
)
```

> output: `w1z4rdry`

# Lost VM Part 3

By using the new flag the crash message change to:

```
...
#flag_parts next vmpc 163
function: 0x010c6820: pc 2048   vmpc 56
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
...
you know what to do now
```

It seem like that after retriving `#flag_parts[3]` we are not logging the vmpc responsible to perform the check, this is because `logged_instructions` saturated and we need to reset it in order to log again reused `vmpcs`

Let's check vmpc 116
```lua
elseif t > 115 then
-- vmpc 116
if e == 1815 then
    -- 1815 => check if #flag_parts[2] == 8
    print("vmpc 116", S[c.c], "~=", S[c.N], e)
end
print(e, S[c.c], "~=", S[c.N])
```

From the new output we can notice vmpc 116 begin used at pc 2045 to check `#flag_parts[3] == 8`

```
access to flag_parts[3] from 2131
#flag_parts next vmpc 163
2045    4       ~=      8
function: 0x010b6a28: pc 2048   vmpc 56
```

```lua
elseif t > 115 then
    -- vmpc 116
    if e == 1815 or e == 2045 then
        -- 1815 => check if #flag_parts[2] == 8
        -- 2045 => check if #flag_parts[3] == 8
        print("vmpc 116", S[c.c], "~=", S[c.N], e)
        logged_instructions = {}; -- reset log blacklist
    end
```


```
#flag_parts next vmpc 163
function: 0x00ec66c0: pc 2733   vmpc 197
__index: string; index: sub from line 1370
__index: string; index: char from line 1376
#flag_parts next vmpc 163
function: 0x00ec66c0: pc 2836   vmpc 114
tables metamethods are fun!
```

By looking at 197 we approach this part by inspecting the stack:
```lua
-- vmpc 197
-- ...
S[t] = S[t](o(S, t + 1, c.S)) -- flag_parts[3]:sub(7, 8)
e = e + 1
c = l[e]
-- print(S[c.N]) -- flag_parts_3:sub(7, 8)
-- flag table must be on stack with a metatable
for i, v in next, S do
    if type(v) == 'table' and getmetatable(v) then
        print("---------TALBE_WITH_METAMETHODS---------")
        tbl_foreach(v, print) -- we can reconstruct part3 easily 
        print("----------------------------------------")
        -- m4573r3d
        logged_instructions = {}
    end
end
if (S[c.c] ~= S[c.N]) then
-- ...
```

From output:
```
---------TALBE_WITH_METAMETHODS---------
1       57
2       m4
3       3d
4       3r
----------------------------------------
```

> reconstructed: `m4573r3d`

```
YOU MADE IT! HERE IS YOUR FLAG: TRX{lu4_w1z4rdry_m4573r3d_aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF}
```