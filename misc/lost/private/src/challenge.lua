if K4_OBFUSCATED == nil then
    K4_MAX_CFLOW_START = function() end;
    K4_MAX_CFLOW_END = function() end;
    K4_GETSTACK = function() return {}; end;
    K4_CRASH = function(...) error(...) end;
    K4_ENCRYPT = function(v) return v; end;
    FLAG = "TRX{this_is_a_fake_flag}"
    -- WARNING, COMMENT LINE BELOW BEFORE OBFUSCATING
    -- FLAG = "TRX{lu4_w1z4rdry_m4573r3d_aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF}"
end

print([[
    
$$\                       $$\     
$$ |                      $$ |    
$$ | $$$$$$\   $$$$$$$\ $$$$$$\   
$$ |$$  __$$\ $$  _____|\_$$  _|  
$$ |$$ /  $$ |\$$$$$$\    $$ |    
$$ |$$ |  $$ | \____$$\   $$ |$$\ 
$$ |\$$$$$$  |$$$$$$$  |  \$$$$  |
\__| \______/ \_______/    \____/ 
]])
if FLAG == nil then
    print("Make sure to set the FLAG variable before running the challenge!");
    print("Ex: FLAG = 'TRX{goodluck}';");
    return 0;
end;

local xor4 = {
    [0]=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,
        1,0,3,2,5,4,7,6,9,8,11,10,13,12,15,14,
        2,3,0,1,6,7,4,5,10,11,8,9,14,15,12,13,
        3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12,
        4,5,6,7,0,1,2,3,12,13,14,15,8,9,10,11,
        5,4,7,6,1,0,3,2,13,12,15,14,9,8,11,10,
        6,7,4,5,2,3,0,1,14,15,12,13,10,11,8,9,
        7,6,5,4,3,2,1,0,15,14,13,12,11,10,9,8,
        8,9,10,11,12,13,14,15,0,1,2,3,4,5,6,7,
        9,8,11,10,13,12,15,14,1,0,3,2,5,4,7,6,
        10,11,8,9,14,15,12,13,2,3,0,1,6,7,4,5,
        11,10,9,8,15,14,13,12,3,2,1,0,7,6,5,4,
        12,13,14,15,8,9,10,11,4,5,6,7,0,1,2,3,
        13,12,15,14,9,8,11,10,5,4,7,6,1,0,3,2,
        14,15,12,13,10,11,8,9,6,7,4,5,2,3,0,1,
        15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,
};

local function split_by_underscore(input_str)
    local result = {};
	input_str = input_str:sub(5, -2);

    for word in string.gmatch(input_str, "[^_]+") do
        table.insert(result, word);
    end;
    return result;
end;

local function xor8(a, b) -- 1byte xor
    local al = a % 16;
    local bl = b % 16;
    return 16 * xor4[a - al + (b - bl) / 16] + xor4[16 * al + bl];
end;
local function hex(s)
    s = tostring(s);
    return (s:gsub('%d+', function (c)
        return string.format('0x%04X', c);
    end));
end;
local function CRASH_WRAPPER(...)
    print(...);
    K4_CRASH();
end

-- [[ meme part ]]
if FLAG == "TRX{this_is_a_fake_flag}" then
    CRASH_WRAPPER("do you really think it's that easy?");
    return 0;
end;

-- [[ setup part ]]
local parts = split_by_underscore(FLAG);
if #parts ~= 4 then
    CRASH_WRAPPER("this flag is weird, try again!");
    return 0;
end;

-- [[ bit functions setup ]]
if not bit32 then
    print("[WARNING] The 'bit32' library is missing. This may cause the challenge to run slower and be more difficult.");
end

-- [[ lua part ]]
print("starting integrity system");


local lua_part = parts[1];
if #lua_part ~= 3 then
    CRASH_WRAPPER("3 characters, 3 bytes... easy right?");
    return 0;
end;

local bit32_test = bit32 and bit32.btest or function(a, b) return a == b; end;
local bit32_bxor = bit32 and bit32.bxor or function(a, b) return xor8(a, b); end;
local bit32_band = bit32 and bit32.band or function(a, b) return a==b and a or 0 end;

if not bit32_test(bit32_bxor(lua_part:byte(1), 42), 0x46) then
    CRASH_WRAPPER("do you like xor?");
    return 1;
end;

if not bit32_test(bit32_band(lua_part:byte(2), 0x75), lua_part:byte(2)) then
    CRASH_WRAPPER("bitwise operations are fun!");
    return 2;
end;

if bit32_bxor(lua_part:byte(3), 0x34) ~= 0 then
    CRASH_WRAPPER("xor $r1, $r1 for the win!");
    return 3;
end;


-- [[ wizard part ]]
local key = {[0]=0xCA, 0x22, 0x00};
local wizard_enc = {0xbd,0x13,0x7a,0xfe,0x50,0x64,0xb8,0x5b}
local wizard = parts[2];

if #wizard ~= #wizard_enc then
    CRASH_WRAPPER("sorry, you can't spell magic");
    return 1;
end;

for i = 1, #wizard do
    local k = xor8(wizard:byte(i), key[(i-1) % 3]);

    if k ~= wizard_enc[i] then
        CRASH_WRAPPER("you are not a wizard " .. hex(i));
        return 2;
    end;
end;

-- [[ master part ]] 
-- m4573r3d
local master = parts[3];

if #master ~= 8 then
    CRASH_WRAPPER("you know what to do now");
    return 0;
end;

local master_shuffle = {
    "57";   -- 01
    "m4";   -- 00
    "3d";   -- 03
    "3r";   -- 02
}
setmetatable(master_shuffle, {
    __index = function(self, idx)
        local t = type(idx);
        if t == "number" then
            return rawget(self, idx - 42)
        elseif t == "string" then
            return rawget(self, #idx)
        elseif t == "table" then
            return rawget(self, 2)
        else
            CRASH_WRAPPER("what are you doing to my metamethods!!");
        end;
    end;
    __metatable = "don't touch me!";
})

if master_shuffle["sex"] ~= master:sub(7, 8) then
    CRASH_WRAPPER("tables metamethods are fun!");
    return 3;
end;

if master_shuffle[43] ~= master:sub(3, 4) then
    CRASH_WRAPPER("epic meta 43");
    return 4;
end;

if master_shuffle[42 + 4] ~= master:sub(5, 6) then
    CRASH_WRAPPER("epic meta 46");
    return 4;
end;

if master_shuffle[{}] ~= master:sub(1, 2) then
    CRASH_WRAPPER("epic meta 45");
    return 4;
end;

-- [[ final part ]]
local dec = K4_ENCRYPT('aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF');
if parts[4] ~= dec then
    CRASH_WRAPPER("you are at most there!");
    return 0;
end;

print("YOU MADE IT! HERE IS YOUR FLAG: " .. FLAG);