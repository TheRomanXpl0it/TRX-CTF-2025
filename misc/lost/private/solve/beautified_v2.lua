FLAG = "TRX{lu4_w1z4rdry_m4573r3d_aHR0cHM6Ly9wYXN0ZWJpbi5jb20vcmF3L3BSSEw0V1dF}"

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

-- 277: while true do

local general_meta_logger = {
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

local crash_messages = {
    ["you are not a wizard 0x0001"] = true,
    ["sorry, you can't spell magic"] = true,
    ["tables metamethods are fun!"] = true,
    ["you are at most there!"] = true
}

local old_print = print;
print = function(...)
    local args = {...};
    if crash_messages[args[1]] then
        old_print("CRASH called from", dbg_getinfo(3).currentline);
        return;
    end

    old_print(...);
end;

-- beautifier check bypass
_G["debug"] = {};


return (function(i, n, o, S, c, ...)
    local E = getfenv or function()
            return _ENV
        end
    local e, l = E(1), ("")
    local d = e[n["https://theromanxpl0.it/_l9js7t94O"] .. "\97\116" .. o[238346702]]
    local a = l["\103\115" .. n[790415826] .. c[779131960]]
    local s = l["\99\104\97" .. "\114"]
    local t = l[S["https://discord.gg/kMR2eyusf6_AbH41HN0ff"] .. c[779131960]]
    local A = e[n.Grazie_Dario_J00Rp3x .. S["https://www.youtube.com/watch?v=HKnUdvVXOuw_PEwAOXvDn"]]
    local l = l[c[779131960] .. o["Leandro_sbrugna_AcV77m"] .. n.Leandro_sbrugna_Cknt0NGjdf]
    local f = e["\116\97\98\108" .. "\101"]
    local o = e[o[99165527] .. "\101" .. i["https://www.youtube.com/watch?v=HKnUdvVXOuw_QPAfAANNz7"]]
    local B = e["\115\101\116\109\101\116\97\116" .. "\97" .. "\98" .. "\108" .. "\101"]
    local o = f["\99\111\110\99\97" .. S["https://www.youtube.com/watch?v=HKnUdvVXOuw_PEwAOXvDn"]]
    local N = d["\108\100\101" .. S[371789834] .. "\112"]
    local o = e["\117\110\112" .. S[578205439] .. c[401388731]] or f[c[614095223] .. c[401388731]]
    local d =
        f[
        i["Lignano_Sabbiadoro_è_ANNIENTATA_zot7wmzlk"] ..
            n[417861824] ..
                i["https://www.youtube.com/watch?v=HKnUdvVXOuw_QPAfAANNz7"] ..
                    S["https://www.youtube.com/watch?v=HKnUdvVXOuw_PEwAOXvDn"]
    ]
    local e, S, n = nil, "", {}
    local n, h = 256, -255
    local i = {}
    for c = 0, n - 1 do
        i[c] = s(c)
    end
    local f =
        a(
        c[
            "/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAAyACUDASIAAhEBAxEB/8QAHAAAAgIDAQEAAAAAAAAAAAAAAAgGBwEFCQID/8QAMRAAAQMDAgQDBQkAAAAAAAAAAQIDBAAFEQYSByExYQhBURMjMnGRFBUiM2KBobHR/8QAFwEBAQEBAAAAAAAAAAAAAAAABgUEB//EACcRAAECBAUEAwEAAAAAAAAAAAIAAQMEBREGITFBcRM0UWESM4HB/9oADAMBAAIRAxEAPwDqnWCQBknArNQDitrQ6YtwaZcKFuDKlAZIFT6pUApcqUybXtt5da5GTiT8cZeFq6niHmnDhDiVY9DXul30fxMkRrkyt+d7RD69u3mc9u1MFDkJlxm5KPhcSFCpeH8QjWxJnH4k23pbqxRY9HNhi5s+jr7UUUUkUZFLf4kLmzFcWzLf2OLJCFbtuxPzpkKUzxjX9zTk+POSgOoQlDi2ykHp5jv286NYpgPHk2b2kWF43RqAl6VY6FudlVLjrDkxC4y8kyWy2hRyOisnJ+dPBoWR9q07GdT8BSNnYYrnlZOOl6v8dq2zxaFsuuJRGbYj7VhPkpf05+dP7wkffk6Etr0k5cUg5OMfwKhYWkwl5p+mV8s0ixnMHHhA8Vs7qY0UUV0Jc7WCQBk9BSy+J9m06rhOmNFQ+/CQU7VH8zl1A7Uxsye2y24tDiCtKAoJUfiBNUnxR4cSL9Lcu9heQptZ942SfdfTy9M8u9RK3CizMv0g0fbd+FZohhBmWim9raeP1JRwx05e5+rk7bXb2WWXcuKUyv8ACP3xXSHhldY0zTrMGOwGxCSlvkMBQ9aXKwcMrwxeExIdvkttuHLilNk5P6cZz/VXnEu1r4d2ZEJwlTzqtsh5IGEKCSQM9OQB8+tQ6HKFTj6jt8WfLPV+L7pDiOZGoCIC9y2ttyrKorWWS5Nz7XHltqKkuICgVDng8xmimQRWMWLyg5A4E4vsoVql55uMoodWkiIkjCiOeKhFknzkKiLRMfSpxslZDhBUcdT60UUPqvfwuR/qRyX0Fwtv95XERpZE+SCGlYIdV/tQG93CeLrEbE18JWzlSfaKweauvOiis9e7mB+rXIaF+K5+G777+lGHHnluKLrg3KUSeveiiimdP7WHwyLzf3ny6//Z_WSLeT"
        ],
        "[%z\1-\127\194-\244][\128-\191]*",
        function(f)
            local c, o = l(f), 1
            if c >= 192 and c < 254 then
                local e = 64
                c = c - 128
                repeat
                    local S = l(f, o + 1) or 0
                    if S >= 128 and S < 192 then
                        c, o = (c - e - 2) * 64 + S, o + 1
                    else
                        c, o = l(f), 1
                    end
                    e = e * 32
                until c < e
            end
            if not e then
                e = s(c + h)
                return e
            end
            if i[h + c] then
                S = i[c + h]
            else
                S = e .. t(e, 1, 1)
            end
            i[n] = e .. t(S, 1, 1)
            e, n = S, n + 1
            return S
        end
    )
    local S = bit and bit.bxor or function(c, S)
            local e, l = 1, 0
            while c > 0 and S > 0 do
                local n, t = c % 2, S % 2
                if n ~= t then
                    l = l + e
                end
                c, S, e = (c - n) / 2, (S - t) / 2, e * 2
            end
            if c < S then
                c = S
            end
            while c > 0 do
                local S = c % 2
                if S > 0 then
                    l = l + e
                end
                c, e = (c - S) / 2, e * 2
            end
            return l
        end
    local function h(e, c, S)
        if S then
            local c = (e / 2 ^ (c - 1)) % 2 ^ ((S - 1) - (c - 1) + 1)
            return c - c % 1
        else
            local c = 2 ^ (c - 1)
            return (e % (c + c) >= c) and 1 or 0
        end
    end
    local c = 1
    local function n()
        local e, l = l(f, c, c + 2)
        e = S(e, 159)
        l = S(l, 159)
        c = c + 2
        return (l * 256) + e
    end
    local function e()
        local e, l, n, t = l(f, c, c + 3)
        e = S(e, 159)
        l = S(l, 159)
        n = S(n, 159)
        t = S(t, 159)
        c = c + 4
        return (t * 16777216) + (n * 65536) + (l * 256) + e
    end
    local function i()
        local e = S(l(f, c, c), 159)
        c = c + 1
        return e
    end
    local function r()
        local c = e()
        local e = e()
        local l = 1
        local S = (h(e, 1, 20) * (2 ^ 32)) + c
        local c = h(e, 21, 31)
        local e = ((-1) ^ h(e, 32))
        if (c == 0) then
            if (S == 0) then
                return e * 0
            else
                c = 1
                l = 0
            end
        elseif (c == 2047) then
            return (S == 0) and (e * (1 / 0)) or (e * (0 / 0))
        end
        return N(e, c - 1023) * (l + (S / (2 ^ 52)))
    end
    local a = e
    local function h(e)
        local n
        if (not e) then
            e = a()
            if (e == 0) then
                return ""
            end
        end
        n = t(f, c, c + e - 1)
        c = c + e
        local c = ""
        for e = 1, #n do
            c = c .. s(S(l(t(n, e, e)), 159))
        end
        return c
    end
    local c = e
    local function N(...)
        return {...}, A("#", ...)
    end
    local function Q()
        local o = {}
        local t = {}
        local c = {}
        local S = {}
        local l = {h = o, L = t, v = c, W = S}
        local c = e()
        print("----------CONSTANTS DESERIALIZER----------")
        for l = 1, c do
            local e = i()
            local c
            if (e == 0) then
                c = (i() ~= 0)
            elseif (e == 3) then
                c = r()
            elseif (e == 2) then
                c = h()
            end
            print(l, c)
            S[l] = c
        end
        print("-------------------------------")
        for c = 1, e() do
            t[c - 1] = Q()
        end
        l.d = i()
        for l = 1, e() do
            local S = i()
            local c = {H = n(), c = n(), nil, nil}
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
            o[l] = c
            
        end
        
        return l
    end
    local function s(c, h, f)
        local S = c.L
        local l = c.h
        local e = c.W
        local c = c.d
        return function(...)
            local l = l
            local a = {}
            local t = c
            local i = -1
            local E = A("#", ...) - 1
            local N = N
            local A = {}
            local r = S
            local u = {...}
            local S = {}
            local n = e
            local e = 1
            for c = 0, E do
                if (c >= t) then
                    a[c - t] = u[c + 1]
                else
                    S[c] = u[c + 1]
                end
            end
            local u = E - t + 1
            local c
            local t
            local log_current_function = false
            local logged_instructions = {}
            while true do
                c = l[e]
                t = c.H
                if log_current_function and logged_instructions[t] == nil then
                    print(str_format("%s: pc %d\tvmpc %d", dbg_getinfo(1).func, e, t))
                    logged_instructions[t] = true;
                end
                if t <= 101 then
                    if t <= 50 then
                        if t <= 24 then
                            if t <= 11 then
                                if t <= 5 then
                                    if t <= 2 then
                                        if t <= 0 then
                                            -- vmpc 0
                                            local i
                                            local t
                                            S[c.c] = S[c.S]
                                            e = e + 1
                                            c = l[e]
                                            t = c.c
                                            i = S[c.S]
                                            S[t + 1] = i
                                            S[t] = i[n[c.N]]
                                            e = e + 1
                                            c = l[e]
                                            S[c.c] = n[c.S]
                                            e = e + 1
                                            c = l[e]
                                            t = c.c
                                            S[t] = S[t](o(S, t + 1, c.S))
                                            e = e + 1
                                            c = l[e]
                                            S[c.c] = n[c.S]
                                            e = e + 1
                                            c = l[e]
                                            t = c.c
                                            S[t] = S[t](o(S, t + 1, c.S))
                                            e = e + 1
                                            c = l[e]
                                            S[c.c] = n[c.S]
                                            e = e + 1
                                            c = l[e]
                                            t = c.c
                                            S[t] = S[t](o(S, t + 1, c.S))
                                            -- print(o(S, t + 1, c.S)) -- xor(flag_parts[1][1], something)?
                                            -- x ^ 42 = 70 -> x = 'l' flag_parts[1][1] == 'l'
                                            e = e + 1
                                            c = l[e]
                                            if not S[c.c] then -- we can change this to check if we bypass the check
                                                e = e + 1
                                            else
                                                e = c.S
                                            end
                                        elseif t == 1 then
                                            if S[c.c] then
                                                e = e + 1
                                            else
                                                e = c.S
                                            end
                                        else
                                            local o = r[c.S]
                                            local t
                                            local n = {}
                                            t =
                                                B(
                                                {},
                                                {__index = function(e, c)
                                                        local c = n[c]
                                                        return c[1][c[2]]
                                                    end, __newindex = function(S, c, e)
                                                        local c = n[c]
                                                        c[1][c[2]] = e
                                                    end}
                                            )
                                            for t = 1, c.N do
                                                e = e + 1
                                                local c = l[e]
                                                if c.H == 151 then
                                                    n[t - 1] = {S, c.S}
                                                else
                                                    n[t - 1] = {h, c.S}
                                                end
                                                A[#A + 1] = n
                                            end
                                            S[c.c] = s(o, t, f)
                                        end
                                    elseif t <= 3 then
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    elseif t == 4 then
                                        S[c.c] = S[c.S] / n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] - S[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] / n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] * n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        e = c.S
                                    else
                                        local l = c.c
                                        local n = S[l]
                                        local t = S[l + 2]
                                        if (t > 0) then
                                            if (n > S[l + 1]) then
                                                e = c.S
                                            else
                                                S[l + 3] = n
                                            end
                                        elseif (n < S[l + 1]) then
                                            e = c.S
                                        else
                                            S[l + 3] = n
                                        end
                                    end
                                elseif t <= 8 then
                                    if t <= 6 then
                                        if (n[c.c] < S[c.N]) then
                                            e = c.S
                                        else
                                            e = e + 1
                                        end
                                    elseif t == 7 then
                                        local o = r[c.S]
                                        local t
                                        local n = {}
                                        t =
                                            B(
                                            {},
                                            {__index = function(e, c)
                                                    local c = n[c]
                                                    return c[1][c[2]]
                                                end, __newindex = function(S, c, e)
                                                    local c = n[c]
                                                    c[1][c[2]] = e
                                                end}
                                        )
                                        for t = 1, c.N do
                                            e = e + 1
                                            local c = l[e]
                                            if c.H == 151 then
                                                n[t - 1] = {S, c.S}
                                            else
                                                n[t - 1] = {h, c.S}
                                            end
                                            A[#A + 1] = n
                                        end
                                        S[c.c] = s(o, t, f)
                                    else
                                        do
                                            return S[c.c]
                                        end
                                    end
                                elseif t <= 9 then
                                    S[c.c] = S[c.S] * n[c.N]
                                elseif t == 10 then
                                    S[c.c] = S[c.S][n[c.N]]
                                else
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                end
                            elseif t <= 17 then
                                if t <= 14 then
                                    if t <= 12 then
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    elseif t > 13 then
                                        S[c.c] = S[c.S] / n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] - S[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] / n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] * n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        e = c.S
                                    else
                                        local t
                                        S[c.c] = S[c.S] % n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] + n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        S[t] = S[t](o(S, t + 1, c.S))
                                        print(S[t])
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S][S[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        S[t] = S[t](o(S, t + 1, c.S))
                                        
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S][S[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    end
                                elseif t <= 15 then
                                    local o
                                    local t
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    for c = t + 1, c.S do
                                        d(o, S[c])
                                    end
                                elseif t == 16 then
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] - S[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] * n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    e = c.S
                                else
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                end
                            elseif t <= 20 then
                                if t <= 18 then
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                elseif t == 19 then
                                    S[c.c] = (c.S ~= 0)
                                else
                                    local d
                                    local t
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    i = t + u - 1
                                    for c = t, i do
                                        d = a[c - t]
                                        S[c] = d
                                    end
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    S[t](o(S, t + 1, i))
                                    e = e + 1
                                    c = l[e]
                                    for c, e in next, S do
                                        S[c] = nil
                                    end
                                    e = e - 1
                                    while true do
                                    end
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    do
                                        return
                                    end
                                end
                            elseif t <= 22 then
                                if t == 21 then
                                    local e = c.c
                                    local n = {S[e](o(S, e + 1, c.S))}
                                    local l = 0
                                    for c = e, c.N do
                                        l = l + 1
                                        S[c] = n[l]
                                    end
                                else
                                    if (S[c.c] == n[c.N]) then
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t > 23 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t <= 37 then
                            if t <= 30 then
                                if t <= 27 then
                                    if t <= 25 then
                                    elseif t > 26 then
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    else
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    end
                                elseif t <= 28 then
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                elseif t > 29 then
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                else
                                    local e = c.c
                                    local l = S[c.S]
                                    S[e + 1] = l
                                    S[e] = l[n[c.N]]
                                end
                            elseif t <= 33 then
                                if t <= 31 then
                                    if (n[c.c] < S[c.N]) then
                                        e = c.S
                                    else
                                        e = e + 1
                                    end
                                elseif t == 32 then
                                    S[c.c] = s(r[c.S], nil, f)
                                else
                                    local c = c.c
                                    S[c](S[c + 1])
                                end
                            elseif t <= 35 then
                                if t == 34 then
                                    i = c.c
                                else
                                    -- vmpc 35
                                    if (S[c.c] == n[c.N]) then -- check if #flag_parts == 4
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t > 36 then
                                local d
                                local s, a
                                local h
                                local t
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t]()
                                e = e + 1
                                c = l[e]
                                t = c.c
                                h = S[c.S]
                                S[t + 1] = h
                                S[t] = h[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                s, a = N(S[t](o(S, t + 1, c.S)))
                                i = a + t - 1
                                d = 0
                                for c = t, i do
                                    d = d + 1
                                    S[c] = s[d]
                                end
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, i))
                                e = e + 1
                                c = l[e]
                                if S[c.c] then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            else
                                local n
                                S[c.c] = h[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                n = c.c
                                do
                                    return S[n](o(S, n + 1, c.S))
                                end
                                e = e + 1
                                c = l[e]
                                n = c.c
                                do
                                    return o(S, n, i)
                                end
                                e = e + 1
                                c = l[e]
                                do
                                    return
                                end
                            end
                        elseif t <= 43 then
                            if t <= 40 then
                                if t <= 38 then
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] - S[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] * n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    e = c.S
                                elseif t > 39 then
                                    local i
                                    local o
                                    local t
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    S[t] = S[t](S[t + 1])
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S][n[c.N]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S][n[c.N]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = {}
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    i = S[t + 2]
                                    if (i > 0) then
                                        if (o > S[t + 1]) then
                                            e = c.S
                                        else
                                            S[t + 3] = o
                                        end
                                    elseif (o < S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                else
                                    local c = c.c
                                    S[c] = S[c](o(S, c + 1, i))
                                end
                            elseif t <= 41 then
                                local i
                                local t
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                i = S[c.S]
                                S[t + 1] = i
                                S[t] = i[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                if (S[c.c] ~= S[c.N]) then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            elseif t == 42 then
                                local l = c.S
                                local e = S[l]
                                for c = l + 1, c.N do
                                    e = e .. S[c]
                                end
                                S[c.c] = e
                            else
                                local o
                                local t
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                for c = t + 1, c.S do
                                    d(o, S[c])
                                end
                            end
                        elseif t <= 46 then
                            if t <= 44 then
                                -- vmpc 44
                                S[c.c] = #S[c.S] -- #flag_parts[2]
                                if e == 3182 then -- #flag_parts[4]
                                    --print(S[c.S]) -- is encrypted part
                                    
                                    logged_instructions = {}
                                end
                            elseif t > 45 then
                                -- vmpc 46
                                while true do
                                end
                                for c, e in next, S do
                                    S[c] = nil
                                end
                                e = e - 1
                            else
                                local c = c.c
                                S[c](o(S, c + 1, i))
                            end
                        elseif t <= 48 then
                            if t == 47 then
                                local n
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = #S[c.S]
                                e = e + 1
                                c = l[e]
                                n = c.c
                                do
                                    return S[n](o(S, n + 1, c.S))
                                end
                                e = e + 1
                                c = l[e]
                                n = c.c
                                do
                                    return o(S, n, i)
                                end
                                e = e + 1
                                c = l[e]
                                e = c.S
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t > 49 then
                            if S[c.c] then
                                e = e + 1
                            else
                                e = c.S
                            end
                        else
                            local e = c.c
                            S[e] = S[e](o(S, e + 1, c.S))
                        end
                    elseif t <= 75 then
                        if t <= 62 then
                            if t <= 56 then
                                if t <= 53 then
                                    if t <= 51 then
                                        local c = c.c
                                        do
                                            return o(S, c, i)
                                        end
                                    elseif t > 52 then
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    else
                                        f[n[c.S]] = S[c.c]
                                    end
                                elseif t <= 54 then
                                    -- vmpc 54
                                    S[c.c] = S[c.S]
                                elseif t > 55 then
                                    -- vmpc 56
                                    local i
                                    local o
                                    local t
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S][n[c.N]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = f[n[c.S]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S][n[c.N]]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = {}
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    i = S[t + 2]
                                    for i, v in next, S do
                                        -- constructed from vmpc 94
                                        if type(v) == "string" and #v == 44 then
                                            print("part4", v)
                                            break;
                                        end
                                    end
                                    -- tbl_foreach(S, print)
                                    if (i > 0) then
                                        if (o > S[t + 1]) then
                                            e = c.S
                                        else
                                            S[t + 3] = o
                                        end
                                    elseif (o < S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                else
                                    if (S[c.c] == S[c.N]) then
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t <= 59 then
                                if t <= 57 then
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] - S[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] / n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S] * n[c.N]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = S[c.S]
                                    e = e + 1
                                    c = l[e]
                                    e = c.S
                                elseif t > 58 then
                                    local e = c.c
                                    do
                                        return S[e](o(S, e + 1, c.S))
                                    end
                                else
                                    S[c.c] = S[c.S] % n[c.N]
                                end
                            elseif t <= 60 then
                                S[c.c][n[c.S]] = n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            elseif t == 61 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                S[c.c] = S[c.S] - S[c.N]
                            end
                        elseif t <= 68 then
                            if t <= 65 then
                                if t <= 63 then
                                    local o
                                    local t
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    for c = t + 1, c.S do
                                        d(o, S[c])
                                    end
                                elseif t > 64 then
                                    -- vmpc 65
                                    if (S[c.c] < S[c.N]) then
                                        e = c.S
                                    else
                                        e = e + 1
                                    end
                                else
                                    if (S[c.c] ~= S[c.N]) then
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t <= 66 then
                                -- vmpc 66
                                
                                if (S[c.c] == S[c.N]) then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            elseif t > 67 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                local o
                                local t
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                for c = t + 1, c.S do
                                    d(o, S[c])
                                end
                            end
                        elseif t <= 71 then
                            if t <= 69 then
                                local o
                                local t
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                for c = t + 1, c.S do
                                    d(o, S[c])
                                end
                            elseif t == 70 then
                                S[c.c] = S[c.S] - n[c.N]
                            else
                                local i
                                local o
                                local t
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                i = S[t + 2]
                                if (i > 0) then
                                    if (o > S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                elseif (o < S[t + 1]) then
                                    e = c.S
                                else
                                    S[t + 3] = o
                                end
                            end
                        elseif t <= 73 then
                            if t > 72 then
                                if not S[c.c] then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            else
                                S[c.c] = n[c.S] * S[c.N]
                            end
                        elseif t > 74 then
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t <= 88 then
                        if t <= 81 then
                            if t <= 78 then
                                if t <= 76 then
                                    local l = c.c
                                    local t = c.N
                                    local n = l + 2
                                    local l = {S[l](S[l + 1], S[n])}
                                    for c = 1, t do
                                        S[n + c] = l[c]
                                    end
                                    local l = l[1]
                                    if l then
                                        S[n] = l
                                        e = c.S
                                    else
                                        e = e + 1
                                    end
                                elseif t == 77 then
                                    f[n[c.S]] = S[c.c]
                                else
                                    -- vmpc 78
                                    if (S[c.c] < S[c.N]) then
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t <= 79 then
                                -- vmpc 79
                                local d
                                local s, h
                                local f
                                local t
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                f = S[c.S]
                                S[t + 1] = f
                                S[t] = f[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                t = c.c
                                f = S[c.S]
                                S[t + 1] = f
                                S[t] = f[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                s, h = N(S[t](o(S, t + 1, c.S)))
                                i = h + t - 1
                                d = 0
                                for c = t, i do
                                    d = d + 1
                                    S[c] = s[d]
                                end
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, i)) -- check if flag_parts[1][2] == "a"
                                -- print(o(S, t + 1, i)) -- 97 => "a"
                                -- S[t] = true; -- this will make the vm jmp to the next check
                                S[t] = true
                            elseif t > 80 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                -- vmpc 80
                                S[c.c][n[c.S]] = n[c.N]
                            end
                        elseif t <= 84 then
                            if t <= 82 then
                                if (S[c.c] < S[c.N]) then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            elseif t == 83 then
                                S[c.c] = S[c.S] + S[c.N]
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t <= 86 then
                            if t == 85 then
                                S[c.c] = S[c.S] % S[c.N]
                            else
                                local o
                                local t
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                for c = t + 1, c.S do
                                    d(o, S[c])
                                end
                            end
                        elseif t == 87 then
                            local t
                            S[c.c] = S[c.S][n[c.N]]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t] = S[t](S[t + 1])
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S][n[c.N]]
                            e = e + 1
                            c = l[e]
                            if not S[c.c] then
                                e = e + 1
                            else
                                e = c.S
                            end
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t <= 94 then
                        if t <= 91 then
                            if t <= 89 then
                                local d
                                local o
                                local i
                                local t
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](S[t + 1])
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                i = S[c.S]
                                S[t + 1] = i
                                S[t] = i[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                d = S[t + 2]
                                if (d > 0) then
                                    if (o > S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                elseif (o < S[t + 1]) then
                                    e = c.S
                                else
                                    S[t + 3] = o
                                end
                            elseif t > 90 then
                                local l = S[c.N]
                                if not l then
                                    e = e + 1
                                else
                                    S[c.c] = l
                                    e = c.S
                                end
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t <= 92 then
                            local c = c.c
                            S[c](o(S, c + 1, i))
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
                            -- vmpc 94
                            S[c.c] = S[c.S][S[c.N]]
                            
                        end
                    elseif t <= 97 then
                        if t <= 95 then
                            S[c.c] = S[c.S] / n[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S] - S[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S] / n[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S] * n[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            e = c.S
                        elseif t == 96 then
                            local c = c.c
                            S[c] = S[c](S[c + 1])
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t <= 99 then
                        if t == 98 then
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        else
                            S[c.c] = f[n[c.S]]
                        end
                    elseif t > 100 then
                        local t
                        S[c.c] = S[c.S] % n[c.N]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S] + n[c.N]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        t = c.c
                        S[t] = S[t](o(S, t + 1, c.S))
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S][S[c.N]]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        t = c.c
                        S[t] = S[t](o(S, t + 1, c.S))
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S][S[c.N]]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                    else
                        if (S[c.c] < S[c.N]) then
                            e = c.S
                        else
                            e = e + 1
                        end
                    end
                elseif t <= 152 then
                    if t <= 126 then
                        if t <= 113 then
                            if t <= 107 then
                                if t <= 104 then
                                    if t <= 102 then
                                        local t
                                        S[c.c] = S[c.S] % n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S] + n[c.N]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        S[t] = S[t](o(S, t + 1, c.S))
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S][S[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        S[t] = S[t](o(S, t + 1, c.S))
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S][S[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = S[c.S]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                    elseif t == 103 then
                                        S[c.c] = S[c.S] % S[c.N]
                                    else
                                        -- vmpc 104
                                        local i
                                        local t
                                        S[c.c] = S[c.S][S[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        i = S[c.S]
                                        S[t + 1] = i
                                        S[t] = i[n[c.N]]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        S[c.c] = n[c.S]
                                        e = e + 1
                                        c = l[e]
                                        t = c.c
                                        S[t] = S[t](o(S, t + 1, c.S))
                                        e = e + 1
                                        c = l[e]
                                        -- check m4573r3d "m4" "57" "3r"
                                        logged_instructions = {}
                                        if (S[c.c] ~= S[c.N]) then
                                            e = e + 1
                                        else
                                            e = c.S
                                        end
                                    end
                                elseif t <= 105 then
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                elseif t > 106 then
                                    S[c.c][S[c.S]] = S[c.N]
                                else
                                    if (n[c.c] < S[c.N]) then
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                end
                            elseif t <= 110 then
                                if t <= 108 then
                                    local l = S[c.N]
                                    if not l then
                                        e = e + 1
                                    else
                                        S[c.c] = l
                                        e = c.S
                                    end
                                elseif t > 109 then
                                    local e = c.c
                                    local l, c = N(S[e](o(S, e + 1, c.S)))
                                    i = c + e - 1
                                    local c = 0
                                    for e = e, i do
                                        c = c + 1
                                        S[e] = l[c]
                                    end
                                else
                                    S[c.c] = n[c.S]
                                end
                            elseif t <= 111 then
                                local e = c.c
                                local l = S[c.S]
                                S[e + 1] = l
                                S[e] = l[n[c.N]]
                            elseif t > 112 then
                                S[c.c] = S[c.S] / n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] - S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] / n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] * n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = c.S
                            else
                                S[c.c] = S[c.S] + n[c.N]
                            end
                        elseif t <= 119 then
                            if t <= 116 then
                                if t <= 114 then
                                    -- vmpc 114
                                    -- call crash function
                                    local inst = l[e-1]
                                    local c = c.c
                                    S[c](S[c + 1])
                                elseif t > 115 then
                                    -- vmpc 116
                                    if e == 1815 then
                                        -- print(S[c.c] ,S[c.N]) -- check if #flag_parts[2] == 8
                                        print("----------CHECKED_PART2----------")
                                        logged_instructions = {}
                                    elseif e == 1933 then
                                        -- at vm pc 93
                                        -- check flag_parts[2][idx] ^ key[(idx-1) % 3] == S[c.N]
                                        print("----------CHECKED_PART3----------")
                                        logged_instructions = {}
                                    elseif e == 2045 then
                                        -- check if #flag_parts[3] == 8
                                        -- print(S[c.c], S[c.N])
                                    
                                    end

                                    if (S[c.c] ~= S[c.N]) then 
                                        e = e + 1
                                    else
                                        e = c.S
                                    end
                                else
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                end
                            elseif t <= 117 then
                                S[c.c] = (c.S ~= 0)
                                e = e + 1
                            elseif t == 118 then
                                S[c.c] = h[c.S]
                            else
                                S[c.c] = n[c.S] * S[c.N]
                            end
                        elseif t <= 122 then
                            if t <= 120 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            elseif t > 121 then
                                S[c.c][n[c.S]] = n[c.N]
                            else
                                -- vmpc 121
                                local c = c.c
                                S[c] = S[c](S[c + 1]);
                                if S[c + 1] == FLAG then
                                    log_current_function = true;
                                end
                            end
                        elseif t <= 124 then
                            if t > 123 then
                                do
                                    return
                                end
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t > 125 then
                            if (n[c.c] < S[c.N]) then
                                e = e + 1
                            else
                                e = c.S
                            end
                        else
                            local o
                            local t
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            o = S[t]
                            for c = t + 1, c.S do
                                d(o, S[c])
                            end
                        end
                    elseif t <= 139 then
                        if t <= 132 then
                            if t <= 129 then
                                if t <= 127 then
                                    S[c.c] = S[c.S][S[c.N]]
                                elseif t == 128 then
                                    local o
                                    local t
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    for c = t + 1, c.S do
                                        d(o, S[c])
                                    end
                                else
                                    -- vmpc 129
                                    local o
                                    local t
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    S[c.c] = n[c.S]
                                    e = e + 1
                                    c = l[e]
                                    t = c.c
                                    o = S[t]
                                    for c = t + 1, c.S do
                                        d(o, S[c])
                                    end
                                end
                            elseif t <= 130 then
                                -- vmpc 130
                                local i
                                local o
                                local t
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                i = S[t + 2]
                                if (i > 0) then
                                    if (o > S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                elseif (o < S[t + 1]) then
                                    e = c.S
                                else
                                    S[t + 3] = o
                                end
                            elseif t == 131 then
                                local o
                                local t
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                for c = t + 1, c.S do
                                    d(o, S[c])
                                end
                            else
                                -- vmpc 132
                                if (S[c.c] ~= n[c.N]) then -- check #flag_parts[1] == 3
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            end
                        elseif t <= 135 then
                            if t <= 133 then
                                local t
                                S[c.c] = S[c.S] % n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] + n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            elseif t == 134 then
                                local h
                                local i
                                local d
                                local t
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                t = c.c
                                d = S[c.S]
                                S[t + 1] = d
                                S[t] = d[n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                i = S[t]
                                h = S[t + 2]
                                if (h > 0) then
                                    if (i > S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = i
                                    end
                                elseif (i < S[t + 1]) then
                                    e = c.S
                                else
                                    S[t + 3] = i
                                end
                            else
                                local i
                                local o
                                local t
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = f[n[c.S]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][n[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = {}
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                o = S[t]
                                i = S[t + 2]
                                if (i > 0) then
                                    if (o > S[t + 1]) then
                                        e = c.S
                                    else
                                        S[t + 3] = o
                                    end
                                elseif (o < S[t + 1]) then
                                    e = c.S
                                else
                                    S[t + 3] = o
                                end
                            end
                        elseif t <= 137 then
                            if t > 136 then
                                local c = c.c
                                S[c] = S[c]()
                            else
                                local c = c.c
                                i = c + u - 1
                                for e = c, i do
                                    local c = a[e - c]
                                    S[e] = c
                                end
                            end
                        elseif t == 138 then
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        else
                            S[c.c] = s(r[c.S], nil, f)
                        end
                    elseif t <= 145 then
                        if t <= 142 then
                            if t <= 140 then
                                S[c.c] = S[c.S] % n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] % n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = h[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] - S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] - S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] / n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] + S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S] * S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = h[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S] * S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] + S[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] + S[c.N]
                                e = e + 1
                                c = l[e]
                                do
                                    return S[c.c]
                                end
                                e = e + 1
                                c = l[e]
                                do
                                    return
                                end
                            elseif t == 141 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                if (n[c.c] == n[c.N]) then
                                    e = e + 1
                                else
                                    e = c.S
                                end
                            end
                        elseif t <= 143 then
                            -- vmpc 143
                            local o
                            local i
                            local t
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t] = S[t](S[t + 1])
                            e = e + 1
                            c = l[e]
                            i = c.S
                            o = S[i]
                            for c = i + 1, c.N do
                                o = o .. S[c]
                            end
                            S[c.c] = o
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t](S[t + 1])
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            do
                                return S[c.c]
                            end
                        elseif t == 144 then
                            S[c.c] = {}
                        else
                            local t
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S] - n[c.N]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            do
                                return S[t](o(S, t + 1, c.S))
                            end
                            e = e + 1
                            c = l[e]
                            t = c.c
                            do
                                return o(S, t, i)
                            end
                            e = e + 1
                            c = l[e]
                            e = c.S
                        end
                    elseif t <= 148 then
                        if t <= 146 then
                            e = e - 1
                            while true do
                            end
                            for c, e in next, S do
                                S[c] = nil
                            end
                        elseif t > 147 then
                            S[c.c]()
                        else
                            S[c.c] = S[c.S] - S[c.N]
                        end
                    elseif t <= 150 then
                        if t == 149 then
                            local t
                            S[c.c] = S[c.S] % n[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S] + n[c.N]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t] = S[t](o(S, t + 1, c.S))
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S][S[c.N]]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t] = S[t](o(S, t + 1, c.S))
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S][S[c.N]]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            e = e + 1
                            c = l[e]
                            e = e + 1
                            c = l[e]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        else
                            S[c.c] = S[c.S] + n[c.N]
                        end
                    elseif t == 151 then
                        S[c.c] = S[c.S]
                    else
                        e = c.S
                    end
                elseif t <= 178 then
                    if t <= 165 then
                        if t <= 158 then
                            if t <= 155 then
                                if t <= 153 then
                                    local c = c.c
                                    do
                                        return o(S, c, i)
                                    end
                                elseif t > 154 then
                                    local l = c.c
                                    local t = S[l + 2]
                                    local n = S[l] + t
                                    S[l] = n
                                    if (t > 0) then
                                        if (n <= S[l + 1]) then
                                            e = c.S
                                            S[l + 3] = n
                                        end
                                    elseif (n >= S[l + 1]) then
                                        e = c.S
                                        S[l + 3] = n
                                    end
                                else
                                    local l = c.c
                                    local t = c.N
                                    local n = l + 2
                                    local l = {S[l](S[l + 1], S[n])}
                                    for c = 1, t do
                                        S[n + c] = l[c]
                                    end
                                    local l = l[1]
                                    if l then
                                        S[n] = l
                                        e = c.S
                                    else
                                        e = e + 1
                                    end
                                end
                            elseif t <= 156 then
                                local e = c.c
                                local l, c = N(S[e](o(S, e + 1, c.S)))
                                i = c + e - 1
                                local c = 0
                                for e = e, i do
                                    c = c + 1
                                    S[e] = l[c]
                                end
                            elseif t == 157 then
                            else
                                local t
                                S[c.c] = S[c.S] % n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S] + n[c.N]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                t = c.c
                                S[t] = S[t](o(S, t + 1, c.S))
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S][S[c.N]]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = S[c.S]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t <= 161 then
                            if t <= 159 then
                                -- vmpc 159
                                local l = c.c
                                local t = S[l + 2]
                                local n = S[l] + t
                                S[l] = n
                                
                                if (t > 0) then
                                    if (n <= S[l + 1]) then
                                        e = c.S
                                        S[l + 3] = n
                                    end
                                elseif (n >= S[l + 1]) then
                                    e = c.S
                                    S[l + 3] = n
                                end
                            elseif t > 160 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            else
                                S[c.c] = S[c.S] / n[c.N]
                            end
                        elseif t <= 163 then
                            if t > 162 then
                                S[c.c] = n[c.S]
                            else
                                -- vmpc 162
                                local e = c.c
                                local l = S[e]
                                for c = e + 1, c.S do
                                    d(l, S[c])
                                    
                                end
                            end
                        elseif t == 164 then
                            S[c.c]()
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t <= 171 then
                        if t <= 168 then
                            if t <= 166 then
                                local c = c.c
                                S[c] = S[c]()
                            elseif t == 167 then
                                S[c.c][S[c.S]] = S[c.N]
                            else
                                e = c.S
                            end
                        elseif t <= 169 then
                            local o
                            local t
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            o = S[t]
                            for c = t + 1, c.S do
                                d(o, S[c])
                            end
                        elseif t == 170 then
                            S[c.c] = h[c.S]
                        else
                            local t
                            S[c.c] = S[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            do
                                return S[t](o(S, t + 1, c.S))
                            end
                            e = e + 1
                            c = l[e]
                            t = c.c
                            do
                                return o(S, t, i)
                            end
                            e = e + 1
                            c = l[e]
                            e = c.S
                        end
                    elseif t <= 174 then
                        if t <= 172 then
                            S[c.c] = S[c.S] + S[c.N]
                        elseif t > 173 then
                            do
                                return S[c.c]
                            end
                        else
                            S[c.c] = S[c.S] / n[c.N]
                        end
                    elseif t <= 176 then
                        if t > 175 then
                            local e = c.c
                            local n = {S[e](o(S, e + 1, c.S))}
                            local l = 0
                            for c = e, c.N do
                                l = l + 1
                                S[c] = n[l]
                            end
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t == 177 then
                        local t
                        S[c.c] = S[c.S] % n[c.N]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S] + n[c.N]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        t = c.c
                        S[t] = S[t](o(S, t + 1, c.S))
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S][S[c.N]]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        t = c.c
                        S[t] = S[t](o(S, t + 1, c.S))
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S][S[c.N]]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = S[c.S]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                    else
                        -- vmpc 178
                        S[c.c] = S[c.S] * n[c.N]
                    end
                elseif t <= 191 then
                    if t <= 184 then
                        if t <= 181 then
                            if t <= 179 then
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            elseif t == 180 then
                                local e = c.c
                                do
                                    return S[e](o(S, e + 1, c.S))
                                end
                            else
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                                e = e + 1
                                c = l[e]
                                S[c.c] = n[c.S]
                            end
                        elseif t <= 182 then
                            if (S[c.c] ~= n[c.N]) then
                                e = e + 1
                            else
                                e = c.S
                            end
                        elseif t == 183 then
                            local e = c.c
                            S[e](o(S, e + 1, c.S)); print("flag's parts constructor called from: " .. dbg_getinfo(2).currentline)
                        else
                            do
                                return
                            end
                        end
                    elseif t <= 187 then
                        if t <= 185 then
                            local e = c.c
                            S[e] = S[e](o(S, e + 1, c.S))
                        elseif t > 186 then
                            S[c.c] = S[c.S] % n[c.N]
                        else
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                        end
                    elseif t <= 189 then
                        if t > 188 then
                            local i
                            local t
                            S[c.c] = S[c.S][S[c.N]]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            i = S[c.S]
                            S[t + 1] = i
                            S[t] = i[n[c.N]]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            S[c.c] = n[c.S]
                            e = e + 1
                            c = l[e]
                            t = c.c
                            S[t] = S[t](o(S, t + 1, c.S))
                            e = e + 1
                            c = l[e]
                            if (S[c.c] ~= S[c.N]) then
                                e = e + 1
                            else
                                e = c.S
                            end
                        else
                            if (n[c.c] == n[c.N]) then
                                e = e + 1
                            else
                                e = c.S
                            end
                        end
                    elseif t == 190 then
                        S[c.c] = {}
                    else
                        S[c.c] = (c.S ~= 0)
                        e = e + 1
                    end
                elseif t <= 197 then
                    if t <= 194 then
                        if t <= 192 then
                            S[c.c] = (c.S ~= 0)
                        elseif t > 193 then
                            S[c.c] = S[c.S] - n[c.N]
                        else
                            -- vmpc 193
                            local e = c.c
                            local l = S[e]
                            for c = e + 1, c.S do
                                d(l, S[c])
                            end
                        end
                    elseif t <= 195 then
                        S[c.c] = S[c.S][n[c.N]]
                    elseif t > 196 then
                        -- vmpc 197
                        local i
                        local t
                        t = c.c
                        i = S[c.S]
                        S[t + 1] = i
                        S[t] = i[n[c.N]]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                        e = e + 1
                        c = l[e]
                        S[c.c] = n[c.S]
                        e = e + 1
                        c = l[e]
                        t = c.c
                        S[t] = S[t](o(S, t + 1, c.S)) -- flag_parts[3]:sub(7, 8)
                        e = e + 1
                        c = l[e]
                        -- print(S[c.N]) -- flag_parts_3:sub(7, 8)
                        -- flag table must be on stack
                        for i, v in next, S do
                            if type(v) == 'table' and getmetatable(v) then
                                tbl_foreach(v, print) -- we can reconstruct part3 easily 
                                -- m4573r3d
                                print("---------THIRD_PART_CHECK---------")
                                logged_instructions = {}
                                break;
                            end
                        end
                        if (S[c.c] ~= S[c.N]) then
                            e = e + 1
                        else
                            e = c.S
                        end
                    else
                        S[c.c] = #S[c.S]
                    end
                elseif t <= 200 then
                    if t <= 198 then
                        local c = c.c
                        S[c] = S[c](o(S, c + 1, i))
                    elseif t == 199 then
                        local c = c.c
                        i = c + u - 1
                        for e = c, i do
                            local c = a[e - c]
                            S[e] = c
                        end
                    else
                        -- vmpc 200
                        local l = c.S
                        local e = S[l]
                        for c = l + 1, c.N do
                            e = e .. S[c]
                        end
                        
                        S[c.c] = e
                    end
                elseif t <= 202 then
                    if t > 201 then
                        -- vmpc 202
                        local l = c.c
                        local n = S[l]
                        local t = S[l + 2]
                        if (t > 0) then
                            if (n > S[l + 1]) then
                                e = c.S
                            else
                                S[l + 3] = n
                            end
                        elseif (n < S[l + 1]) then
                            e = c.S
                        else
                            S[l + 3] = n
                        end
                    else
                        -- vmpc 201
                        i = c.c
                    end
                elseif t == 203 then
                    if not S[c.c] then
                        e = e + 1
                    else
                        e = c.S
                    end
                else
                    -- vmpc 204
                    local i
                    local t
                    t = c.c
                    i = S[c.S]
                    S[t + 1] = i
                    S[t] = i[n[c.N]]
                    e = e + 1
                    c = l[e]
                    S[c.c] = n[c.S]
                    e = e + 1
                    c = l[e]
                    t = c.c
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
                    print("---------FIRST_PART---------")
                    logged_instructions = {} -- reset blacklisted instructions
                    if (S[c.c] ~= n[c.N]) then -- flag_parts[1][3] check
                        e = e + 1
                    else
                        e = c.S
                    end
                end
                e = e + 1
            end
        end
    end
    return s(Q(), {}, E())(...)
end)(
    {
        ["https://www.youtube.com/watch?v=HKnUdvVXOuw_QPAfAANNz7"] = ("\114"),
        ["Lignano_Sabbiadoro_è_ANNIENTATA_zot7wmzlk"] = ("\105")
    },
    {
        [(790415826)] = ("\117"),
        ["Grazie_Dario_J00Rp3x"] = ("\115\101\108\101\99"),
        Leandro_sbrugna_Cknt0NGjdf = ("\101"),
        [(417861824)] = ("\110\115\101"),
        ["https://theromanxpl0.it/_l9js7t94O"] = ("\109")
    },
    {[(238346702)] = ("\104"), [(99165527)] = ("\116\111\110\117\109\98"), ["Leandro_sbrugna_AcV77m"] = ("\121\116")},
    {
        [(371789858 - #("titto sex chat llm when?"))] = ("\120"),
        ["https://www.youtube.com/watch?v=HKnUdvVXOuw_PEwAOXvDn"] = ("\116"),
        ["https://discord.gg/kMR2eyusf6_AbH41HN0ff"] = ("\115\117"),
        [(578205439)] = ("\97\99")
    },
    {
        ["/9j/4AAQSkZJRgABAQAAAQABAAD/2wBDAAMCAgICAgMCAgIDAwMDBAYEBAQEBAgGBgUGCQgKCgkICQkKDA8MCgsOCwkJDRENDg8QEBEQCgwSExIQEw8QEBD/2wBDAQMDAwQDBAgEBAgQCwkLEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBAQEBD/wAARCAAyACUDASIAAhEBAxEB/8QAHAAAAgIDAQEAAAAAAAAAAAAAAAgGBwEFCQID/8QAMRAAAQMDAgQDBQkAAAAAAAAAAQIDBAAFEQYSByExYQhBURMjMnGRFBUiM2KBobHR/8QAFwEBAQEBAAAAAAAAAAAAAAAABgUEB//EACcRAAECBAUEAwEAAAAAAAAAAAIAAQMEBREGITFBcRM0UWESM4HB/9oADAMBAAIRAxEAPwDqnWCQBknArNQDitrQ6YtwaZcKFuDKlAZIFT6pUApcqUybXtt5da5GTiT8cZeFq6niHmnDhDiVY9DXul30fxMkRrkyt+d7RD69u3mc9u1MFDkJlxm5KPhcSFCpeH8QjWxJnH4k23pbqxRY9HNhi5s+jr7UUUUkUZFLf4kLmzFcWzLf2OLJCFbtuxPzpkKUzxjX9zTk+POSgOoQlDi2ykHp5jv286NYpgPHk2b2kWF43RqAl6VY6FudlVLjrDkxC4y8kyWy2hRyOisnJ+dPBoWR9q07GdT8BSNnYYrnlZOOl6v8dq2zxaFsuuJRGbYj7VhPkpf05+dP7wkffk6Etr0k5cUg5OMfwKhYWkwl5p+mV8s0ixnMHHhA8Vs7qY0UUV0Jc7WCQBk9BSy+J9m06rhOmNFQ+/CQU7VH8zl1A7Uxsye2y24tDiCtKAoJUfiBNUnxR4cSL9Lcu9heQptZ942SfdfTy9M8u9RK3CizMv0g0fbd+FZohhBmWim9raeP1JRwx05e5+rk7bXb2WWXcuKUyv8ACP3xXSHhldY0zTrMGOwGxCSlvkMBQ9aXKwcMrwxeExIdvkttuHLilNk5P6cZz/VXnEu1r4d2ZEJwlTzqtsh5IGEKCSQM9OQB8+tQ6HKFTj6jt8WfLPV+L7pDiOZGoCIC9y2ttyrKorWWS5Nz7XHltqKkuICgVDng8xmimQRWMWLyg5A4E4vsoVql55uMoodWkiIkjCiOeKhFknzkKiLRMfSpxslZDhBUcdT60UUPqvfwuR/qRyX0Fwtv95XERpZE+SCGlYIdV/tQG93CeLrEbE18JWzlSfaKweauvOiis9e7mB+rXIaF+K5+G777+lGHHnluKLrg3KUSeveiiimdP7WHwyLzf3ny6//Z_WSLeT"] = ("ƂƝƞƞƜƙȁƞǈǽǲǩǹƜƑȅǩǰǮǬǯǪǹǻǪƿǷǩǵƜƗȅǷǯǺǱȠȋƘȅǖǽǰǺǲȋƜȅƏŵƜƔȅǘǵǬǹǋǹǬǨȹƜƆȅƨďǤǾǩŬĬǬƟĆƚƴľƙƮŲĖŊǌƤƐƍĒƲƜƚȅǪǥǮȋȝȁǷǹǪɡǰǨɘȅǱǽǪǶƜȥȁǛǯǲǯǬƫɧȁǘǒǝǗƜƛȅǰǹǧȃȅǺǹǼǩǷƜƖȅǕǰǪȇȉȤȅǚʅǬǵǫƜƉȅƃĬǇƣǾŶĠƽƐĀƛǉľǤƽźąŎǟƦǜƜƲȅƛĉǮƳǼŌĈƧƲĖǐƜĆȽġĥŸǗʱƅŀƣǼĵǵıƢƖŜƌƿĝƊĊĺƱǥǔǈĜǮĸɼȅǫǩǼɽȅƞĞǀǞˢˣƾǞʂȁǔǯǼǕǺɭȅǛǘǬǽǱȋƕȅǎǲǽǥȹǗȚ˨ȅƶ˫˻ȁǝȖǵǨɪǹ˲ƒ˞ɢ˹ǪɪǽǼȫƜƋȅǬȏƿǫȕǩȶƿǸȏ̋ǯǰƜǱȅǼŁƼƃƝĄŃƝǾŭǧǩŝǄǈđŻĭƑǂǼǮųǍƞăǅŃƿǹĚƽƋĬǈŗŧǶƐǤƞīƊžċƠƻĖǭǆǜƝǗŕ͂ĽƕƼǒįƜăŧǙŁĎƣǤƈĄņŵŧƭǍǳƆěǜĆĴĈƆĝƒǐƥȂǫǄĊśƪƬǁŘƟǙƀǇćǃĸŠůǼćȱȅǒǯǷȸȺǵǻȋʊȁǩ̠ǬɛɝƜǳȅƥĔǻǕǏŋĉǘơōƻƁĺǤǭůĔřƠǰǙǎėƦǼŵƦĵƸǙűǌƫĿƟĪĚ̴ƁưċǞĖŤǑƛŹƎƽǼǼƸĢƛĐĝǡǔƵďǽūĈƵĭũǉƁǫĤĲĘŇǛƺƙƦŮưŧŁūǴĽǱƾǁƾǾƈǤťĲǘǇǡļǈƻǦƠŪưŔĔŝȜȅǄǯǱǼǵǹǭȁƸ˫ɟƞɡǪǵǰǸǯƜ̑ȁǋǯȏǺΝǨΟȋƓȅǌǹȢȔǙȻʍɶƞǼǦɳƜ̈ƞǛǶǽ˷Ȗȼ΢ƞǻшǪǫǮ˸ȽȅǋǵǱǩ˾Ц̨ǌǽǺǵΤΚǻȈǹ˱ΘȁяȕǳǵǸǷ˿ƜƏȅǧʕȔƿǻǲǵǮǼǯщ˲ƐзǹȩȹȸǪЦǰǷОˣȁƂТȅȨЦǽјʉȎΥǺ̖ЖȁƿƿЧʄǦпѯ˹Ҕȁǜǽ̠ǎщǪҙȆȕǪɳƬƜжЭǪʕ҈ʏȊȌȅѤѪƿȶǮ˾ΠƜƃȅƈĢǞǧǺŵţǲƙęƈƆĺưƠżėŜƱơƎƉœƧǩũҟȄȁǊ˷ǵǲƜȭȁǍĥѨƞǓƪƿǙǐǛǌǅǎǊ˳ɯ˸ȹǽƜƍȅǑЯ̠ǜǩ̨҆ƭǛѹǻǳӷƞҒКȓПƞƫҎȁўǷǺɱӥƻȅƘĬƜǼǰůţǫƙĎƃƅĦǤƼŹĔĿǸǢƓƚŒƼƾůƭĤƳǙŽǞǾœțɮƞǰǩКȼӠƞǮѤǲӥȲԔȏвдƜҀȁǗɢʓǫΠȩҐʗэХȔ˸ʗՑƞǐՂǼ҄ǹǭȊǰӁУǙǰ̗ȫ˲ՅЛǪƫƬԐŮƟˬƞǸɲɳԐƺ˫ƎȦՂȨǯǵǺǌǯȓҨΦЫȅƗıǓǦƽŧĠǩƝōǛԓƞ˽˿ȹʗԿǖǹȈɫԐƖ˫ȍȁǎօʍǫՎӁѲɠɢ˷ǧ̖̘̔ǹԐǔ˫ՋպȵНǵǷխӥəЭ֢ҪՅǋǶǹՉпчɪңƞҮǫҴЧʈՅǻǬɜׇіǶ։ҪҲȆȵǪǩȈǉΥԐǗ̇з׀ǶǪǗʕǮҫ׎҈̏չ˶ӹ˝ȁǕǫǝПžǯ˫ӽȁ̠ɫֆʄȐȒɝΦǥҫΥгӁˣфѳʅǫǯԉɢұҺ˷ǫǶ؎ȼՠǜʕȨǋǩԉǫǈǹǦǩпǧщ̩х̊Πǫؕיؒӡǧǹ҂ʌЩԐƲ˫ӧƞƿɻэӭƿӲǝǋǖضƞǋטعǰ̂țЬƞ֏֑֓֕֗˵ՐҺш״ǩǮ̍ʐҊҋư˫ՠикǹǘ̦ќǰԐǝ˫ՅʓՈпящًǖǯǮ؊ǜЧпҨɫƜƁȀƞƾچƾƔƺƺǂڇڍڎڏڎڊڌڍډƺƾǢڐڙڐڊڗڔڜژڊڡڋڇڢڡڌڥڣچڕڗڜƾқڒƾڭқڳǢǂƿڲژڈڟڜƯچڟǂڨړھږڹڪڻۄۃڝڶڳڰۉǢڰګڵڨچۏۓڝƾۀڡ۔Ɣۋژۋڳƿڽ۟۠ڽڇۣڽƔӫّ֮ȋׄрǥȔؙ׺ȐԃǏǼǴҭԋХȶʈƌȅمǑǝǆنɸǏǇƿǋǊǝǌӶցȁԜԞԠţǱƕĄƌǉĥƩƺԝՅǉǚјҰְƞԜǒƢǩĤįǰƉČſǉĲƟʁэǊ׋ǹǮɳҪ܎юǽҼЧ١ֆ̎չӿΤеۿӮǗǙǊ܉ǝǛǓ۪ɢ۬ӂˣĪǈǲǶŵʡƏĝƌƗľưƟżđӖӘӚӜӞПǞǁ˫נ؄ȶџ̨ǲ،נǻ̢ȶʍѹɿאȴȫǑНɬэʌדȨΠПľǷ֧˴ݴ҂ǪǛӹ˷۲ƞǒפ҅҇҉չǊظ҂ޏء֢ǳˮЧёԐǅ֚ۻ҂ɦƈؚ׆ǹ̡̟̣̥թ٭ƜƅȅƍĵǛѡūĩǸǞĆƅƝĺơƺźćŖƱƯƃƛÿƪǱݧǃ˫ۮǸ־չђǽǧּ̩ХɿщНҪƺȅǍšǝǫʟĤǼ˓ƙƘűǤǹıĝŖǥƥƍǀřǟƾŠƦĶψŨǖǪńƼŦًʖѷܻ׊˲˨ȟǺПŞǈ˧ҋĞǙ؁ȅߐȶѸΟǳʄȔȖуԿ֜̀Ǭԋ̠טȏ̒̚ȗɫݭǺҜ؇Цɛԋَ݀ՠХą̊́ɿ̧ǰʗ˨ў،؂ФɢǶ؆҂ȑٺȹɛԐȁޏܳǦǪݐУȶէߑэҮՁՃࠞэޮ࠵ƜܹݺȔҵǷլծ׵ࡌզȊדչַ̕ӼҁҿΟ̎бҮ˷ɡԐƎݪΙؖȈࠜȼУЧǸ˸ȢչǼȔࡤՠȴȩȴǬדчӤ˲ԿǗӹѧ˨ǫǥ̩ࡹǫƿդ̕ԐǊ֚ب࠙ɴޏ̢ࠠުՈӥܹצȹʌǮԃࡋіȔٻ׵ާȁʛʝʟʡƝęǇƆİƵƼıćŅǶưƗǍ֍ՒӹޓוʗٓѪԉѭȈ̌ȋܢܳȫܶΦݐۮܞғ֨ƞٽ՘ַмފҫࡈǪǜǯҟхࣣǺǥǘɳӁхǧɳǳߓӁ޲ȁƄĬǎƣƹŶŴƱǞŉƙǚŽƢƥşśřǹƥǜƗĜƟƽࣃƞӿǺњȷטѺכȁȹȒࠞƀӄĩǓǶƽŢħǾƗōƀƘŽƱƫźčŉƽǢƈƜČǭǽŢƦĬƭǚࡨЭ˿ݼسǽɡиէߛչҨً֬ҴܻʅܻԊՅȑޟऎٕ֖֒֔֘ǛऎםǯǳࡖްƾȅƣČǧƣǒŃÿǚǞĦƻǊŽƌƋĿĸčǚƏǜƵĺƚǌģſćƀƼĠƝҹ˭֫ёݐՅܳ՞אࣧǥǗǥȒ׹ƞƍĦǄޏբࡓў״ऎǫǽȻЧށթȋࣙǐɢ࣮ǬǳǑщǳȼƇʚʜƣǴŪĪǨǞĘſƊĩԩżśŉǼǢƒſĂпǐ׸э؄ޔʗۮǊ։׃̬Ȩ˲ּȢѠǸǥș࠶ƞॾۮѼɱչࡻǲ̠ԐކԐࠏޏқֵࡦ̙ࣙɩধƿѴǵ৤ۭɚࠕԋƤƶƹǺƳƵпլՂॾנࡁ࠘ȗșț۾Эǳ̎ѼѾ֜ǪЩǬǱƜǞȅƯĢǕǠƽŵİԣōƛƄŽƵƫťअइǜƨķƎǗģƯĤƱƒŹǛǟŇǨĹČƐǽƖǹċǸĉšǎǔŸƈǦƨǵƼŵƋěŞǹǐƵŝǹŠňПĞǍٱɨɪяאǖփǰօࠈҋȁ੏̉سɢԐƼתȁǇȈǳǋɝ׵Կד࡜ݑȁƷĹƆƣǗňĄǘǞŒǇǌĉƖƐŨĚŀǼƦƐƙĖƤǡĢǼऺƞूȊƿ̨ƿȔ࣒ܷ঍ॏנՓދ࠾ǲǺݵҫׯঙ৫ǥԐƆؿȅǇŴпҴҸхʄ࠲ǱǮӤȋՠ̝ǰޫݳ̣ȉӻۮح৫੬ƞʓࡻњગɪǋǥדй׎ǪࣞॆۮǇ׋੘ˣŞ؀ԋ˷ȩЙא࠱ȒسѱࡩԈ࡬ࢅࡤՅХǷǻאǒ׬ޔऎޗُݐܹ܀܂܄ǒ܆ӯǐह˨ǘǏǈऎʌǨख़ȷȹȻࠞנѣȈٍװखٌ࠾֌ֱ̛ࠥǶࠧࠩފટ঍ҿࠞхǈǌ۬ݧǵણӨͨхǽԃǯ؜מײѐȔ˲эҥԉѓԉԐƊࠌҋƴ˫эՓЙֲ،УܳǬӣ̩ԿטךЪ˨НױУǓǹǥɰʄƜƂ޳ࣶǵǦĨţǦƏĚǇƈľƪǭਝŜǡƥƐƂœƢऴƮĦԋ֋ࣟУɰȶّՠਖ਼ȅۮƞǨ୭ƞʱ୭эҋĦȅşş୲ȅڄȁ୸ȁ୺୼ȁ୾ƞ஀ƞஂஃ̄Ġ୲୶ˣஇஉ୾չघɳҋۮƝǻ৔சȅĖȂਖ਼ǂ஛஛ஐ୻୼ॾˣஎȅணȁܹ঍˟ˡਖ਼ମࡅŞࠟה҈ۺɩǪ੒Յƥěǡǘƴࡥ࡟ԋছࡃـȂۮٶǬࡅƞ׾؀նո̫ȁ̵̷̭̯̱̳̹̻͇͉͍̽̿́̓͋ͅ͏͓͕͙͑͗͛ͣͥͧͩͫͭͯ͟͝͡ͱͳ͵ͷ͹ͻͽͿ΁΃Ɯ΅·Ή΋΍ΏΑΓΕćߌଯҋ਍୽ǫˣĘ஡ҋـȀڄəఔȁȄԐȭȄெࡆ୽ట୯టజˣПڄȄԿ֎ƞՅஅஃஃకȁ˻хڄȲఢƞȲȲరƞжశжжּƞٓ஄ȁȍנڄҀٓڄѲࣙӧȍछڄƨ঎఻ˣ౑۾ܹƞǥ౒ȭӧΪ̑ց؂ౝ౒ցƜÿƞȍȾకĻ౦ƞՠƝ౪Ҁࣙ୳ƞѲУ౮ƞցౌŔ౬ƞǺ஛Ŝƞ۾ӽ֨ĭಀಅܢಅ۾౱̛хȅƊƞநʙీȁާУȅ঩࠻ȅȾಘȁʙȾெʙ̑ʙӄషਖ਼঩౱ȁȾਁˣ޲ಪಣ޲ெާ̑ࢯನƞಢಫƞಳభమ୲఺Ƅ౫ృƞӃנƛǠ౓ǑசಞĆӾசƛȥж਍Ȁಯೊਗ਼சʾೋڄģƞୋȾ܎೙Ɓƞ޲ցƛǪ೚ƞǙச೟ೖȁ೧ڄǋು೯ಾƞċƞछȾୋ౻छछ౗ſೠƞ೟ȅ೼೼౗ಾಾ౗޲೼ҋȾछటफ़ೌǐƞȾǎச೒˼஛౑Ⱦࣳௌ೎ٌೈȂ೓ജȀ೪ƞǁ஛೙೛౷ച౓Ǉசୋഢഫഡടǆ஛೮ӃӃೱೳ೟೶ȁı೾ഽ܎Ĭƞഄനƞഗഽࡆടഒ౐ƞಎӃȿವ೥ȅŕ౻ؑടǽ஛ǀോు൙ƞŖƞ˻̛ಎ౤౻Ԛൊəಌ౑Ȅీ൒ՅേȅǶ஛Įஞəగടǯச஘ܣٔˣȲȥȥ΢౑ȝஅ౑ʊ൬ħ൹ʊȀƛĄஞǴ൷ഞȅඍڄඈਖ਼ப஡ԐƮ఍ࡆ౗Ēஞೀȁɽ఺ȁశఙȅெȥඉˣൽఒȄనˣ൳ఫථச୯൬ඩೕඵȥ̄ඬ൹୮ƞə൬ඣ୹தౌࡐଡவʈۮ҉ˠ঍Ǘĥƕெழ੫࢏්ைшொ୲்ఋȅշ̴̶̸̪̬̮̰̲̺̼͈͎͔͖͚̾̀͂̈́͆͊͌͐͒͘͜͢͞͠ųͤͦͨͪͬͮͰͲʹͶ͸ͺͼ;΀΂΄ΆΈΊΌΎΐΒΔΖఊࡅǞ୾ٓැוԋਉஸԋǌĹƗƳƩŜාිઈුщோෘ௏ො௒ෞ௕෡௘෤௛෧௞෪௡෭௤෰௧ෳ௪෶௭෹௯෼௲෿௵ข௸ฅ௻จ௾ఀฌఃฏఆฒఉఌߍตˣƝǸ୽ėඎҋరȭڄɽԐచఠ಻మ఺ȝ஗ȁඓҋʊ඄஛˻಺లරȁಒڄж౵ȁ̑эڄȍхӧж঩ൊѲ൧ന୬ౙѲ౛ȁΪȲҀְ຋౳౻ൢжӽ౩౓ּ౶̑ಌʱȍబ౯൞ඥ౺̑൘ڄ౿ց຃ȁ಄ցցנനցಌӽಕȁ۾఩ȁ̛நಎප൏ಇಓຐҋ̛ާெ̛Ȳଊȁಎಐ౓ҋާ౗ȁ঩໋൙঩ெಎȲಎಣໄಖ൛ఒ๥୭఺Ⱦళȁ޲Уೄൺǘசເട໤ඉ೅ȝ໨ƞ໐໧ഥുಸ൚ƞ೙Ӄ঩̑ƛǜ໱ơசӃഢ໼രȅƠള೽޲Ⱦೲ೥ާೱҀୋୋూ೟঩്ȁ೟೟ూȾȾూ঩೿ˣާ೷ඝȁƪೌǝ໲Ǖச໮ʋೕടǔഖ໲঩ඟȥȝೇȀ໦೗ඏ੢໰ಾಱഩȝ̈́Ȁಾഢ༽༶ƞǌ༄޲༆ȁೳӃ༊഻೯ӃЬീ༗໳౑ާ༒ഢ༫ൊ۾ങൄƞ̛ೱȁ൒୬གǃൗಅȲਁ൝ȝӽ۾ൢ̑ୋൊȭಕ౑ɽ୶൒ПഢǼ༬ԐƣೌˣƫசŠதஆශ஄Ƿ୽ǅ๜಼ؑஞఞ໙஡๟ජௌਖ਼ȥ๩໚஥஛ʊྔ˻ູ๲ට๴ධҋసൺȅຬ஛๺๤๽๤Ҁּӧ̑ಾൊցీ౑ӽಇౙౣඝΪжѲ܎ྸനຈ౥̑ಎຕ̑ె౪ȍీʱҀԿ౶Ѳྫ౺ȍƿ౾ౢತƞ಄ӽӽూ࿖࿓າಏਖ਼̛ັ൙ಌಜ๳ಣ໎ໍர໭༟൙ж໔࿢࿡໲ూ໌౒ഉ࿲ˣಝ࿩ʙжಶ࿨࿬ಙ൏ඞྕਖ਼఺޲ທࣴ࿜ඟ೅ʊǖ༦གည໩࿜ဍഐဌ໰໶ಿദထȍೣ೯೐೥ഢရജൂࣳസ࿨്Ҁ༔ಿȁ೵൐ဨ೴ဧ༅ိഊಥെ࿩Ƨ༢࿨Ǔഝഢ့༁ȁǒ༬঩༇ௌဈƞലȀ༧ȁ၄ȁ໵࿨ဘൾགྷ໽གངျഠЭ໱ಾအ೥༑ཌ།ಿീཆಿ౑঩༞ഢွൊཝ౔൙༒ƞའఓട஠ڄ൘̛жଊ൝ʊ۾̛ൢȍ೼ൊཱིၧ൦ˣ൒ఢഢஙకढ़శƭ඲ඝ๫ஏྃ༟չॎоلӮهىҋ࿊࿁ྍྌඞ఺ඡ໛ਖ਼உ୲ԋမඟඎഢචȁğ࿩ີஞஅʊྌඕႠ఩ߝ႙ྑ୭ə಺ȭశȭྀ୭஑ʲ಻ҫ໹඼๞ടႶௌལతஒടȄຕྏȅႭඔႌ࠻ધɜʑ๹ĶǏǥǺŶ૒ߔХয়˫Կ޴ǎȒšչӅӇ૎ఌƜƸȅƉĩɰƽţĵǺϕȾŽƠƥźđňƱƶƑǎĘƶƾŨƢįƠƖŽǉǣŁƬĪňǕා੩ෆ஭ීٜษ෗ҋ׿ෙȁෛ௑рฯ෠ௗ෣௚෦௝෩௠෬௣෯௦ෲ௩෵௬෸෺௰෽௳฀௶ฃ௹ฆ௼ฉ௿ซంฎఅฑఈఊؑĀڄƝƶႫਖ਼Ⴆఓྋ஛గྒල๤ကခྗຟೀ˻ಒຟ˻жఴ࿚ȅྡూྤڄ̑ࣙ๼൓஛ຍඥ๹ထྯᅟྲຽȁྵᅎƞྼྺຊ౓຦Ȃ྿ಅ࿂ൃ৔࿅ᅱ౲࿉୽౪ѲܢƜ࿎ƞຣȁ౿ӽᅺ࿔౒࿙޳౒ಇ۾ந࿞࿧࿮ʙິ໲࿥ᅿ಍࿨໑౓࿼ʙ࿮༺ҋಗਖ਼ಚਖ਼࿶ಟ౓࿺঩࿼಴ಶ಺ᅔ๜޲ܢڄಾࣙ໢ȍǗဋഢᇀဎᆿးടᇃ၉೯঩ɟဖȾȝჁӃ༃ȀഭടᇒགƟ༄ဠ཈ഽၙ౻ဦಕဩ༞ာछಕၞಕူᆩဲெƩဵ঩བྷထབ༩ۿှထ༯౫ഏ၅གᇸགയᇉနᇏ೅ȍၑ೯ഢሃဟ໱ၗୋᇝ഼ၛɟၝ೽ɟၠဪ္༬ၦൎൌၿᅨ൭ȁལၯཛྷ౓ၳ࿜ၶᅻ౫೟ၻဆȁ౑ၾ൑ᅒൔ̬ೌ໺ȭඑྑഢሳ൸๡ˣčርਖ਼჋ሻྑູɽႻ࿩āƝຕ඾ˣĜ൹ྔᆷ๗ᅖໞຟᅚ๲ᅝྞᅚᅡˣᅣᅬᅦౄᅨేᅱྫྷƞǟ༬ྰၧླˣᅳຉᅵ౓ᅷቩжᅺཬౘ൷౪౞ᆅ౫ಇ࿈๳࿋቞ᆊś࿑ᆏຽ࿕ᆒˣ࿙ᆖረȅᆙҋಎᆛ࿣ຼᆟ໎ಎ໐ˣಎ࿫࿵ᅗ༜໳ˣᆪ࿳ಛ൏ಞኔ࿹ኘ໘࿽ᆵቌ๝஛ᆹ๤ᆼʲሁƞİᇁടክඉȥȍĽᇆȅኴၒኰᇾ࿨ᇌ೥ᇎௌ೤Ӄĸബགዂ೭ၕ೽༈༐೯ᇞഽᇠထᇢ೹ྡྷໟሐˣᇨአ༛ெĂഎ࿨಄Ȁ೉ȅዝሩ࿨၀ᆾƞĢኮȅዧ೘ᇊൺዥආȀ໾ടዯၔᇚ༈ሊዋሌ೥ሎီሑ࿨ၢടዡཛሖዢመሬཡഢŞཤၱሟ൜ሢሟၸƞĚཹኅሪንၪሾགŗೌ೤ȭ౺ඨഢጞགŎ൷ஙሸ਎ጘȅሽҋɽቀƞቂெቄቆ࿣቉ྒྷᅓኤ๜ʊ቏ᅙਖ਼ቒ஛ྡྠತᅢእ൚ቚ౫౭ȁᅪഌ̑ŹቢᅯᆕቦനቨᅶൃྼቮᅼĿቱ൚ܹ౶ȍቶ౻࿊ᆆቺ౫Ʋቅᆍ࿒ְኀᆓȁኃˣᆗ࿝ዒᆡኊᆝ໊ေ኎ᆢኑᆤኔᆧኗ໗ኛᆬҋᆮኞ࿾࿱ᆳထኣጷృڄኧೀኩᇶຜ፥၆ఫ፥ഢƉ፥ዥ᎕ዞག᎘ኺᇋᇉധᇏ໺ཎ፥ᇔȅƒ᎓ടƑ፥ሇၖᇛዊဤഽ೟ዎഺȅዑᇥዔ࿽ഋ዗ᅫඥ᎖༣ဿ፥ዟನᎧȅ޽ൊဿኪ౫ƹ᎐གᏊያᇿഩၹ፥ዱഀᏃȁƾᎪ೮ድೳዷ്ዹୋዻᇦዢၡඥടᏅዢጃཛጅཟሚགƵᎪၰሠȁၴಅၷ౥ȍŴጓ୶ጕಌႀၬȅƮ᎖ጜԑ᎖གƫᏕƞƥ፥ሷႴȁĳጘధ፰ႣጭጯˣጱȁୱదƦධநȝబᎈᎉఱንᅞቕತቓຖਖ਼ా፼࿰ᅧፅҀፇຐᆈቛǏᎪᅰຬౕᆠౙӽፒፚ࿲ౡቾጐǕᐊᆁ፛ພ፞౴ቴᆐȂ౺ҀĆᎪ౿ಁቿಈ࿴ᑒಇಋ࿧໇ᅚಔေ፾ᑓ࿢ኝჭ൚࿺ާᅚದᆫಅҋಬਖ਼ާಯኖಲዕᎃᏄ໲࿿ኤಽᅱڄӃᆽኲƞǯᏀགᑼၒĞ᎖ᑺǬ፥ഔȁᒄᒀᎪᇍྡྷೞዔჁୋǧ፥೩ടᒑၒǦᏘཌྷ໱༈ᇡፈᇣ፰೼޲༛ƞഁ፰ൂᎶഈᑯᎹெǲᎽထěᒅགᒯၒϐൊഘʲᑺėᑽഢᒹၒčᒊኽይᑺēᎣགᓃၒĒᒘവᒚဢᎳ഼ᇟȁീᒦዢȾዘടᒴጄዋዢʙᇢၫሮȁĉᏯ൙࿀ᏲຟൠሤҀǊᐴᅒຄ൩ሙපഢĂᎪǬሴ஢ႌˤ֨൸ᒝඟ୾႗ማ൙కஙᓺྞˣԚƛ༥๪Ⴄടඓഢ႗ᓹሚഫᔄ஛Ȁည୭ቨਖ਼஝̄ցჃȅᔚག႗໢ĎᓿᏤᆡకưச൬ཚጤȅՠᔆ࿽ᔛ಴ၒƮᔪᔂᅟƞ౺ᔭ༓ᔉȅሦགᔲᔀȅĶʲᔇƞƽᔺȁᕅᔱᔳƞᕁ஄ƹசཡඎ౺ఠഡቍȀų஛ɽźᅕோట̄ᔾᔣȁᕟ್ƞᔡᔦ჉ȅᕦᔽ൷ᕩᔨፃ஌ȁƱ୽Ĥசš๤ȭ౥ೀɽĩ๤əஇᐐᇬೀ೎ᅇȁȝᐎೀʊŷ๤˻ţ๤Ȳĝᕲ౓ū๤̑ąྦྷƞľྩƞƳ๤Ѳ༞ڄցƇᖃ౒౽ೀཫ๤̛Č๤ಎല஄ᕳʙĪ๤ާᖆ஛঩൝ೀȾ࿊ዓƖᖢಾŻ๤Ӄ༣ೀୋĈ๤೟œ๤छ྅ᖭᒣƞႇೀढ़ጒೀᕅƛᖢƼƞǣ๤Ԛሺೀߝ቏ᕎᐯწķ๤Ʒƞř๤ᅉƕᅇᕳƵƞũ๤ƴц๤ᖛĵ๤ʱņ๤ᕱዧೀᔦ୴஛Ưƞŭ๤ᔲໄڄႇླྀೀƬفˣŝȅᘉຕደᗪஞŇ๤ɽ໺ೀəᕳೀȄŢ๤ȥതೀȝീᖇಸᖢ˻ƚᖢȲ໤ೀжļᖐ̑೮ೀȍቼೀҀťᖜƞŀ๤ցᔐ஛ӽĲ๤۾ငጌᖢಎᕃڄʙŲᖐާᗤೀ঩į๤༘ᖢ޲ೇᎌƞĀᖿƞŮ๤ୋፌೀ೟޽ೀछΪೀ೼ďᖐढ़ഏᗒ঎ᗕƞᕎೀԚǭ๤ߝ̈́ೀᕎż๤წ๛ೀᗤഒೀᅉŏ๤ᗬᎩ஄౪ᗰ༃஄ᖏᖛᗬೀʱĺᗸԌ๤ᔦᖰೀᗿᕅೀᔲī๤ႇಹȁᘉŅ୲ᘉ๟౪Ȁ൯ᗋȭ஠ᕹጮᕼӬ๤ȄǦᘝ೚ᖢȝጉᘣĉᖊƞ౿ೀȲǈ๤ж၀Ɲᕳ̑ŉᖖ᎕ᘴƞዂೀѲᎹᖟƞŘ๤ӽđᙀƞĥᖧƞāᖪƞဴೀʙƤᙊƞගᙍٔᖢȾୱೀ޲͔ᙕ൘ೀӃᘌᗂƞᄞڄ೟őᗈᅿڄ೼഼ᗋढ़ƜᖢᕅŤ๤ᗖŊᗙ᎒ᗜƞߝᙵƞጣೀწĐᗣƞᘉᙾƞǊᚁƞఏᚄƞᗰĔ୽ᚉဧڄʱ౪ೀᕱǵᚑ່ᗾ࿨ᚗƞආೀႇཾᘈƞႨ୭ᘉචᚣƞ೅ᚦƞŋᘔ೦ᚫྔȄŨᚰǩ๤ȝƔᖢʊ൒ᅘƞ቉ᚺᑶȁж༡ᗋ̑୾ᅧǄᖙཻᛉᒚ஛ցĕᛏƞᕯ஛۾ĞᛕᗿೀಎᘁᛛƞŪᛞ඙ڄ঩Łᙐƞō๤ಬᖼƞŶᙘĴᙛƞ྇ᙞƞǉᛴŰ๤೼ᗰ᛹ƞኴᙪඋೀᗖ๙ᙯƞġᙲઽ๤ᕎćᙸ৔ᖢᗤƎᖢᅉᅉೀᗬ൶᜖ᗰŃ᜚ᖚƞ൱ᚌᐌڄᕱƢᜣƆᖢᗿǹᘂƞᔦᜪᗌᜭந᚝ᅒƛჍ๜ធ୭ᚎరඉዧłƞᒬȀŸགៃ৔ढ़ඡƝ༡ȀǢ୽៉༟់சƘᅇ័˨្Ȁě៏ႈ஄៌ែ៛Ȁబ៞΃஄ᐚ཰ਖ਼ᅐᑳቌ఺ȥᔁ஛ȝᝥˣȝȝ̛ඒᘀਖ਼๭בˣ࿡ᅞĹᚽƞǾᖓƞᔔඝȲƽᓪҀᏺຐ౱ౙҀᐻ˻ȍՑΪ˻౰ሤȲ̰ຕȲ༛౶ж᠄౲̑஗ᆁ᠄ᆉ౓ǷᑎຐҀᔔ಄ᆇƞĊˣᠬ᠞ցᆝӽູ۾࿟̛శಎᕐʙᕐ۾ʙெ۾˻ಭኇ፸ᅚʙົ໲ᡈ຿࿩ᑖ໖ʙಭຼᘄᐟ๜঩᠄ڄȾ៾ᇶ៾ǝ፥ᠿടᡜၒǎ᎖೅៾ᡢ༳གᡦᇉ޲ʙűᇉ༹ƞᡭမ޲ǖ፥༿ടᡴ዆ད༮ཉ൏ࣳҀᓊᡭȅୋཋᢂ೥ᢁ࿱঩ᢇ໲ᇢ࿢ཕˣƠᒭʙǋ፥༴Эᐇᓩൊʙಳᕣ៾ǇᡝᇼᐇǾᒿᡫᡰ၁ƞ៾ǃᒰഢᢩ᡹ထ᡻໱ʙ഼ࣳൂᢁീ঩ᢉᓚ᝗ഢᢘዢӽ၀ཛཙሙጇടǺᓡӽ˻؂൝ȥ౟ሤжƸᓪȀ఩౑៧ሬఞഢǳᐊ៞౉ႃƞᗇ᜖ȭǧˣᓳᕔᔿȀٓƛ൤ƞƪ᛻ƞៅഢᣫᣥᣝ୽ᐚɽŵሼឦᡓ๧ю๤ʊ៱჎࿜៵ᐡ᣾ᐡ˻೤ᅠፃжᡙྥ᠀ᖖᠣᝌƞĖᓪວൎցຆຐᐻຌຽຏѲ᠎౥жĜᑂ౓᠛ቲ᠃ˣປྟᆀ౻ᠣມƞőᠧᅺᠪອᠭˣສᤥᆔ࿟ຳ፯ືᤨᑠᡈާᡊ໲ແತ໖ໆᆭᜤ࿤፵࿧ነᆡ໓ኖ໖ᎄጶᑴ஛Ⱦᡖዓᤊ໢៾ĨᢔགᥚဎᥙᏋഢᥝᡮ໲ᢁ၊ᢸမಾİᏒགᥪ዆ၞ༇Ꮫ໲་೥ୋᢊᎮˣဦᢊདᢊ༚ᑪሓˣĹ᎖ഏާĥᥠടᦅൊާ༮ഩ៾ĢᥛഢᦎၒŘᒿᡯᡱȥ៾Şᡵགᦙၒŝᒘ᥯ᇛཊᒚ഼ᢀᓐထȾᢁནᓙഢᦈዢᣁൎᏨᓝᕠᔶᓡᙁᑧཨ౒ཫᅼđᓪᣔዢၼሬྲྀടōᓲබᣱᣞ৔ᣴƞŬ᣷ៗ᣹៯᣻ᘣᤃ࿜ʊᤁຟ᧓๲ᤆᔃ៿ᤊᅤᤌᘱᤶඝжŶᤒ጖౑ᤕፐຈྷತፉᤛຑᤞƞżᤡжᤣ൚᠞ᤧຝᤪຠ൚Ʊᣬᚸ྽ᤶຩനᠮᔜന᠞ະਖ਼᤹຾ኅ໅᤼࿢᤾ᆂႪເˣໂጌᨍ໇ྤᆞ᥉ኈ፷᥌ኡާ᥏࿻ᥑ៫ᥓ᧡ᎊᢧᒷᨨƖᣬᢕಏᣬഢƇᣬᥘ໭ᣬ᎑ᨱያᦕ᎜ᢥᥨ౳ᣬᏓȁƏ᧾೮ᦠዶᥲᒝၛ᥶ဣ᥸ഽ᥺ထ᥼ဲಣၢˣƙᨲ༣༊ᨵགƄᨯടƃ᧾ᦪᦋᨳƸᨬགᩢᨸᥤᢦ៾ऍ༾གᩪၔᩄ᡼ᢄᦤ೯ᢵᦧᢥཛཔᦳᩝམወᏧ᝗጗ᣃȅீሞᦶཧൺཪሤ̑űᦽ፰ིኅཱུ᏾ȁƭ᧾ᣣᅊ౶Ȁᤊ࿜಺஌Ȁᕟƞឩ᪗ᨨڄȭᥕྑᢇఖƞǏᚭኬᚰƋᚲƞŧ᣼ƞᕱᝇᎇȲůᖐж༫ೀ̑ᗖ᧠ങቝƊᖢѲඍೀցǮ᝛᪤۾᧝Ⴊ᪩ᝣ᩶৔ᖮཛྷᖢާክᛡ᪳ᨥ᪰ᛦƞ᪷ᙕᎇӃ᪽஛ୋ᪺஛೟᫁ᙡ᩼ᛀᗌ᫇ᗏƞ᫄஛ᕅ᪦ȁᗖᫍ஛Ԛ᫋ᜅᨦȁᕎ᫙஛წ᫗ڄᗤ᫕஛ᅉ᪭ᗋᗬ᫣ڄᗰ᫠ڄᖛᎇʱ᫜஛ᕱ᫮ڄᔦ᫫ᜥᪿᕡോᖢႇ᫴ڄᘉ᪦౪ཾ᠞ᘌȀཾ჌ᨨᗋɽ᫿ྐ᫼ᐐᬅ஛ȥᬂڄȝᬋᔈᬈᐡᬐᅞᎇжᬖ᧞ᬓᕳȍ᫦ᅩ᫨ᩀ᪫᫅᫒ೀӽᬭ࿛ᬫሟ᫷ಎ᪤ᡬᖱ᪨ᖐ঩ᬘထᭂᨧᬓစᬽࢰᎃڄୋᬹᔹᬷာᬵᗌᬯڄढ़ᬲᕳᕅ᭍ᗖᭋƞԚ᪤ߝ᫷ᕎᬝР᫏ᬀᬚᜐ᭗ᗬ᭝᜗᫭ቴᖛᬹᖏʱᎇᕱ᭦ᔦ᭤ᗿ᭰ᔲ᭍ႇᬲា᭨ȁཾᢊృཾᚢஞᬝᕳɽ᫷ə᪤Ȅ᭛൹᭿ȝ᭗ʊ᭙ᐡ᭤Ȳ᭦ኟ᪻᫛ᖐȍ᭍Ҁ᭰Ѳᮓനᮑ౒᭷ಅ᫱ሟ᪤ಎ᫷ʙ᭿ާᬿ࿻ᛣ᭄೽᭦ಾ᭤Ӄ᭢೥ᎇ೟ᎇछᯍ೼᭤ढ़ᬋ᭬ᯇᗖᮨ᭱ᮁᜄ᭿ᕎ᫷წ᪤ᗤᮼᅉᮺᗬ᮸ᗰ᭨౪ᖛᬭᮅ᪲ᚏᯍᔦᎇᗿ᭦ᔲ᭤ႇᯛᘉ᭗ཾᬖఠཾᜲඌᖐɽ᪤ə᫷Ȅᮺȥᮼ៴ᝄᭆ๯ᯰᝊ᪹᭰᠂ᯗ౫ᎇҀᯍ᫃ᘺՆ᝛᭗۾ᯛ̛ᮼಎᮺʙ᫷ާᡖᕳ঩᭰Ⱦ᭍޲᮸ಾ᮶᫟᝸᭤೟ᯍछᎇ೼᭿ढ़ᯄᕅᯛᗖ᭗Ԛᮺߝᮼᕎ᪤წ᫷ᗤ᭍ᅉ᭰ᗬ᮶ᗰᬲᯬ᫨ᯯᯛᬒᜣ᭿ᗿᎇᔲᯍႇ᭤ᘉ᭦ཾᬂ᯿ᅒ౶ȭ᭨ᮜ᪯ᚫ᭍Ȅ᫷ȥ᪤ȝᮼʊᮺ˻ᯛȲ᭗ᬼ᠂ᯄȍᯍҀᎇѲ᭦ց᭤ӽ᮶۾᮸̛᭍ಎ᭰ʙ᪤ާ᧝ᰩ᭔ᖷ᭹ዓᮢಾ᭿Ӄ᭗ୋᯛ೟᭤छ᭦೼ᎇढ़ᬹᯘ᭰ᗖ᭍Ԛ᮸ߝ᮶ᕎᮼწᮺᗤ᫷ᅉ᪤᭾ᗯᯝᤩᖛ᭙ᯯ᭗ᮈᜣᮋᮯᜧᎇႇ᭍ᘉ᭰ཾᬯᱢ჋౪ȭᬲᝠɽᮺəᮼȄ᪤ᦗᅕඪƝ᛺๳ីྑඁ஛ុ஡᳕ᅒ๻ढ़Ȅళஙȥ౉ᐚʊ࿟Ȳ๻᧏᧞៮ᅧ᧓ȍȍ᧖Ҁ᧓ᐮ៺Ȯፃց᫷ӽ᠁ᖥ᧡ӧցǈᗔᓘ୬౑ʙ໖ౙൡ᧫᮵൛ΪѲಎᏵനǎᴃ౶ց᧵ӽ᧷ཥቴ̛ᤫ౒ăᴃ᧿ʙ᭐ຨ൏ʙᨄ࿢ᲊᑭေᨙȾಧ೽ᅚಾᎅӃᎅȾ໾ᑯѲᢿ޲ᴮഅਖ਼Ӄ࿺ҌᑰዓഭಷѲཚӃᢿᵀ᭗ᎈ఺೟᪤छᥗ᳒Ǩᴃᨿ୰ᴃഢĘᴃᨳᵘᇓགᵛᇉ೼Ӄᥥڅᢆௌ໺೼ǡᴃ᛺ടᵨၒǠᴠ೮ዑ೿ೳᕅӃഈҀᕅ᫰ˣᗖୋढ़ȅᗖᗖᩉ೟ᢊୋ᫠ʚᕄᎻ؃ᵙഏӃĕᴃᎤȁᶍൊӃ༞ᨳĊᵓགᶖያᵠᨻᡤƞďᴃ೼ഢᶟ዆ᵱᇛढ़ᵵཌढ़ढ़ᩴ᥹ዢӃᵽགᶑᏢာൎȾᒨ᩿᪐ƞĆᴠ൘঩Ѳ༮൝ᑮ໐౥ӽǃᴠ඀፼ඃိ൒எഢÿᵙ೤ȥļᴃȝഢᷓၒƙᘧዢȥబ᳧ƞᇘፀᳫᐟ఺̑ᳮቛᳰ౫ᳳ៷ҋᳶ᧚ᨑᛌ᳻᧟᝞᳿஫ஆ᷇൙ᴅ൏ᴈ൙ᐻᴌ໔ᴎ൙ᴑցĬᴔ౪ᴖቴᴘᤦᴚ᜖ᴜ᧻ӽŠᴠ౿ᴢᨁᴥᤳᑠᴩಣ࿰࿨ᴬိዓᴰኡ᭞ᴴሄᴷᇵዓᴻᆠ᭞ᴿᯎਖ਼޲ᵃᑱᵅˣᵇਖ਼ୋᵊጷᵌ᫹ာᥗᶝŷᶗഢḼ኱ᨨńᶎགṂၒḿᵟᩳᇉढ़᥵኿ᗌĿᵩགṏᶤာᵲᶇᶨ౻ᵸ᫏ƞᵻᵣᵾṛṚᶭᢅᶅ᭞ᚖ࿩ŉᵙ༣ӃŴṃഢṫၒų᷷ᶓᏈ៾ŧḽടṵᶚṉᢜᘀᶠགŭᵖടŬᵯᒞṕᶧឳ഼ᶪ᩶ീṡ౑ᶯᦳṰᏆᶴᓓឳᏫ᪀ȁţᶼ࿨ᶿᓤ᷂ሤӽġ᷷ȝూ᷊౱᷌ᶹɘڄᓳȥྏ౶᳒᣿ᆝ౑ẫ୽ஙẢፐẲӧʱȝԿᣨൺƒᷚክഢẾၒǯᷚཛᐝᣳຟጚҋж቏ᵋ஛ȍᷦ౻ᳵ౻᧖Ѳ᧓ᠬ໋ᷮڄӽ᫷۾᳽஛ḍഌӽƼễᴆᆂᦪ࿼ౙᠿ᧫ցಎಢΪցḓൢӽƂᷚ౶ӽ᧵۾ᴙጋ᜖ᴣࡆ౺۾Ƕễ౿ާḘ಄ާާᴧ໲ᰧአᴮ༘ḬᏬ໱ᨙᴾḳᵁ೽ḮዓցཚಾᕐӃኛᢃਖ਼೟ಳȅಾ೩ˣᴼཞ೥ᔩഽཞᆶᅔ఺छ᪤೼ᵐᨨǜᷚᶏࣚᷚཀᷚᨳǍᷚᒓߞễ೙ṋ᩶೙ᕅᶂṍढ़ǕᷚᕅഢὋ዆ᒤഋೳṜᵽҀᵿṚԚ೟ṥᯜԚᢊዑᩉԚҋᶄᶈᷟἼഏୋǊἿགὩൊୋ༛ṻǇἷᇼἺൕὂᵣṌṻǃᷚᵪȅὺၒǂễ೮ὑᇛᕅᵼཌṙᩴὟዢୋṥᢻụထᶷ౑޲ᶰᶸᓞƞǹễ൘೜ᇵ൝ȍᏇൢ۾Ʒᾏʊ౱౑᠔ሙ࿡ഢǲễᓳᷕፙȝ᪘᳨๝ẴƞᇀᓻൺǫễགᾹၒŌỶᾴᧈƝᐚ˻ᾔᤏọḶỏ᧑ᭃồҀổᷫᠯຐộፃỜᛒởڄỡඝӽĕᾏᡇၧާứ൏ᐻử࿾Ự൏ൡ᷄ƞěỶ౪ỸቴỺḊỼᤩỾᑊಅőἃ໲ἆἋḖຼἌ໗Ἆ፼ዓᕐಾἓ἖ୋḪḭ࿩ೡ᩼໱Ἕᑝ༉ἡᑲἧഽெἨˣḴ‐Ἥᳬါἲᬨᦌƞĵὲഢ†ၒĦἼᶝ‥Ȁὀ୿ὶὄᵢ὇ᨻ೤ढ़ĮὌག″ὐᗌὒṟᾆ౻ὗᢊὙᶇȅԚὝˣᾊᔻᯜὢṟഌȁĸὦ೥ģὪഢ⁏ὭဲᨳŘ‡ട⁖ያ‭ᩨƞŝύག⁞‷೼‹ᾅṝ഼ᾈᦦ⁅౑ᾌᦳ⁒ẓᾑ೽ᾔᦲᓾŔᾙထց༇ᾝዣሤ۾Đᾣိᾦሚ൒ᾩᧃᾬൺẬ῀Ỉ˻ೳịᐢ‚౫ố᳴ਖ਼ᳶ῎ỗῑᤴΐ”ڄỞᛕᤎ౒Ŷ῜ủ໲ῠừ౜നỮᅸự᷼ῨżΎ౒ỹ᧡౲῱౶ῳᠤ۾ưƙ຤ῸḔἈΏῺ᠞ᑥ࿳Ḛ޲ ᥇ḩἕ လಷἚ‒‍἟‑⁆ἣစἦἤനἩ‗ҋ೟’ᷣ஛ἱក”ṻƖ₹လᔊ⃣ഢƆ⃣ṻƓ⃣‪఻⃦ട⃨⁚ᵤ໴ᶇὈမढ़Ǝ⃣Ὅട⃹⁢ᶴὓ೥ὕṟᶀᔑ὚ᔑ⁃Ꮄာὠἕ᫠ெƙ⃩ὧು⃬གƃ⃣ཛὮᨩ៾ƀ⃣ἸℛၒƷ№ὃᵤᨳƼ⃣ὼ᫲№ᾂ‸ᾄ℁ᾇᶇᾉℊᾋ⁀℔№൅⁰ᾓᣂᶹƳ№ᾚന⁹౫ᾟ౥۾űⁿᾥຟ୬₃ᶹƬ№ᾭᅊತẺᤶʱᾲඟጒʊă⃣᪩ഢ⅗ൊ๮៥ತടᎥ࿚Ἦက఺ҀốỖਖ਼ᠬ᧖ց᧓ᤵᷮಛₛₚႪῖᨍ₞۾Ǒℵᨚൎ঩࿺ౙᨓ₦ӽᢚᅸӽἅ⁼᾵⃣౶۾᧵Ῐ౲ಎ౉౪Ḙῴ̛Ċ№౿঩´಄ᢷ₾↚᠞Ⱦᕐᴺਖ਼ಾᡈཎἕ⃒ഽ↦ἥ࿩ಾӽἩӃᡈୋᡐᇜਖ਼छᦋᶆछெ἞ᓙἬ↳ᓙⅣྕ఺೼᪤ढ़ἴ៾Ǳℓഢ⇆ၒǡ⃩ᶝ⇋Ȁ↷ᵫ℡⃵ὅṟछᡱ໺ᕅǪ⃣ᗖഢ⇚ၒǩ℩ᵣढ़ഈೳ‿ᚖҀ⁂ṚߝᲜˣߝ᱃ˣᒤ὞᫸⃙⁇࿩ǴℐഽĞ⃣⇐ȅ⇺ൊ೟Ꮉṻě⇇ട∃ၒđ⇒ ᦖᨨė⃺ག∍ၒĖ⇡ẉ⇤ṟ℆ƞ഼‽ᦦ⇱ዢ೟ℍട⇾ዢℸൎಾὛ⁳གčℼ೽ӽࣳ൝Ҁᒶൢ̛ǌⅹᾧൎȲಇ൒ಒഢĆ⅌࿜Ậ౪ʊᾱᨌ൸ʊᾶௌ༥ʊÿↈག≊ၒĺↈங≅ൻ᧔ᆑᴃʊ≏ᕧȁ≘གĹↈढ़ʊທங˻≆ᴃ˻ı№ག≧ᔿ≣≓๲წ≥∘≨ഢ≪གį⃩ȭᅜឺႾ஄ஙȲ≤༥Ȳī≋ഢ⊂․≐ತ≆ತྡńௌȀȲĦ≲ട⊐ၒĥ≞ፁၧжநນਖ਼ȍȝౙొ₱ቛ᧪ቝžਖ਼̑᠎Έᏸ₍ȍȭˢжƶ។ᇲȁ⊰ൊжᷝ౫ǡⅩ᜜₏ӽố۾᧓۾ሣῗ῏ኆሟᷮᆳᙇⅲ໲ⅴ࿨₞ʙńⅹ޲໖౑ಾᢿౙᑬ₦ಎᒶቩಎཇൢʙŊↈ←ဲ౶´ȁʱᶾቴᥔ᧻ާƽ⊱᧿ᎬᤱൂἊൂ᠞↹⁈໎೟↱छᡈᒠਖ਼ढ़Ἣ೟᳖⁆ಎᒢछ↱Პ⋿᩾ᕇ⌋ာὍ⁄൙Ꮉᵣᒢ⌌ᛋ₏ᗖ᪤᫶ℙƞŤΩག⌝ၒƓ⊱ṻš∎ഢ⌥⌡⋯೙ߝᶫᇉᕎᵹჁႲ⊱ᕎഢɭၒ್዆⇩᪽ೳწढ़ᜆҀწწᢊᗤᕅ᙮੭ƞᯤᵺṟᢊᕅᙌ˩ƞწ⁊᪯⇸ढ़Ɛ⊱⃻ᔫ⋯౑ढ़ṥᨳƄ⊱℧ു〉᫸⌭ṻƊ⊱Ⴒട⍧ၒƉ⋯೮⌺ᇛᕎ⌾ཌᕎᲪᦦ√ཛढ़⍆ഢ⍖⁓ὡ∝⇳ẕᶹदሞᲘ൐൝ӽṲൢާĿⅹ̑ಘ౑ȍಭ൒ಧഢƹ⋯ᓳж∿౓᠞ʊᨙ౑⊙ˣ᪩̑ᅚ⊝ተ⊠ᮖትⅎҀ఑ҋ⊧࿩⎦⊟ᭅ⎩፝ᐨᅫᔭжĄ⊱ၒ⎺⊵ᤨῂ౫ę⊺ፅỎớῊⅱ⋀ᏴỠ⋄Ⴊ̛⋇ፃᰥ᭓⋌ᡕᎻʙǓ⍚೽⋓໱⋖೽ᐻ⋚ወΪ⋝ᇰ౥ʙǙ⎻⋣᧵⋦౲⋩᜖⋫ỿ໲ċ⋯౿⋱ᴤ⋳‒ಾ⋶‎ୋ⋹ᑧ⌐⋽​Ꮦ␀ഽ⌃ᔹ⌅⌐⌈἖ढ़Ἡ⌌␋⌎࿩छಎ⌒ढ़⌔ᶇ⌖⃜ڄ⌘ᜂ⇄ᅵ⍠གǳ⊱ഢǣ⌣᳒ǰ⍗ག␥ၒ␢ያ⌬⇔⌯‰᫸ǫ⌳Ά⍮὜⁉⌼ᵣ⌿⍐␺⍃ᶇ⍆⍈␿ᢊ⍸⌌⍎ȅढ़⍑࿩Ƕ⌣༣ढ़Ǡ␦ഢ⑍ၒǟ⏘⍜⌛Ĝ␝ഢ⑖ᓇ⍣␬∋៾Ę⍨ᵝ␠ടė␴⍰༈⍲⇳഼⍵Ẋ℃᩶⍛᙭ᦳ⑒⍾ၧ೟ᜆ⎂ᾖĎ⋯൘⎆೷⎈೯ഭ౥ާǎ⏘⎏ၧ⎒ሙ⎕ടć⎘౓⎛жᢊ⎞ਖ਼⎠጖Œ൚⊞ᭃ᫴Ⅱ⊨ᅧང⊫ஞ⊮ௌƗ᪠Ⴅ⒢ዢ⊶ỈȍŚ⏃ᨣᆷ఺⊽ᛒ⏉⋂Ⴊ᧓̛⏎፸ቍ൏ᰦᷲᝫᷴ൏Ħ⏘⋒ၧ⋕ፐ⋘ᅸ⏟ࣳ⏡೽ಞ⏤ƞĬ⏧൏⏩₱⋨ᑶ౪⏮ῴާŢ⏲ለḔ⏶⃕⏸ḱ⏺Ḩഽ⋻ᨑᗌἫ⌀‐␄ഽ␆℉␈Ḫ␊ਖ਼ᕅ␍छ⌏℉␑⍏␔ᕅ␖⏅᫲Ḹ⌚ဇᨨŸ⑗ട│ᥞᣭ⑎┄⑛ᵣᵢ␮ᡱ೤ߝŀ␲ഢ┑⌹ᯜ⌻␺⍳౻⍁Ṛ⍄⑰ȅᗤ⍉Ṟ℄ȅ⍍⌊⑇ெŉ⑊ᵣŵ┈ȅ┬ၒŴ⑓ℳᨳũ┃ȅ┵␫┋⁜Ů①ഢ┼┕Ԛ┗⑨ᜆ⑪⑰ᩴ⍸⑯⍻ട┱⑳ൎ⑵ℹᾖť⑺೥ಎ⑽౒⎊⒁ឌ⒄ᑓ⎑⏽጗⒉៲ẩ⒍ፙж⒙⒑ҋ஌⎚஛ഒᤉ౬ቅᤤᓳ᜖ȍ᪘ᘌжȍڄ஌ྦᚈ౫ēᖙ໼᝖࿬ᛌཱྀ⏆Ĩᛒᔡೀ̛ፘᫎă⊦ᔢ፜Ṛ൘ȍᑺᆃိʱѲᣧ೤Ҁǡ⒥ຈᵫ⒥ཛҀ⊷ցƄభౖ⒬Ἧ஛ಎốʙ᧓ʙᴇ஛ާ᧓₽ᷮ↵ᨥ᫷޲⋌ⓟഌȾࣀ⁓ἣ౑೟ၩౙᵃ₦ၙ೷ΪᏣ໾౥Ⱦƶ⒥౶ᓔቴᡳḊಾಪ౶Ӄᴝ޲Ǩ▟౿೟ୋᤱဦἊဦ᠞␐ਖ਼೼ᨡढ़Ḫᕅ↱ṜҋԚᢌᵣԚெढ़঩ᾔᕅḪᗖᵈᯜ␔ߝ⓹᫸ெᕅ঩ὛԚ῅᫸ṥ↾໚఺᱅ន␛ǐ⒥◱ട☍ၒǀ⒥ṻǍ⒥⍩ߞ⒥ഢ☓ያᗤ℈೙ᅉ⇯မᗤǈ⒥ᅉഢ☥዆┛᙮ೳᗬԚᙌҀᗬᗬᢊᗰߝរȁᗰᗰᢊ⑫ᢊߝគᔑᚋ࿩Ǔ☔༣Ԛǽ☗ག♇ၒǼ▟౑Ԛ⑶ṻǹ☎ག♒ể▟೙☞ᨻ᳒ǵ⒥ᗤഢ♜ၒǴ▟೮☫ᇛᅉ☯ཌយ⑬☼ዢԚ☷ཷ♍ᗌ⑇⍹␿ጆᶹǫ▟൘೼঩ഈ൝⓷ᶡ౥޲ƫ♱ᴏၧ₪ሬ໋ഢǤ▟ᓳ⒛ᤩᠩ஧Ꮼ౶⚐ȅ▖᜜Ḇ᳿ᑋƞŦ♱۾̄ത̛ȍౙᑠኛ̛ừڄῳᆡӽᓽʙ⒙ᨍ₨ᆡናȅᰟᡌ൚ӽမ۾ŧ⒥ၷṷ♱̛⊷ʙኛⅼ▧Ⅴኦ⏇စ᧓ൂ᧖Ӄ᧓ᓊᷮᢌᛱ⋊छ⋌⇁Ꮋ೟ĺ♱ᵴၧᗖᾔౙ⌏₦ᾆᚖΪ⁬᛺౥೟Ā◎౪ဦ᜖⃞⚕ᗌᦋ౶ढ़ᴝछŲ◛ṟᕅᤱὗἊὗ᠞ԚἫߝ◹ᕎ␍წ▵␿Ὓ⊳ℳȅᕎ☧ˣᕎୋ␾წ␍ᗤ␔ᅉṣƞᗬ✖წᗬெწୋ♳ᅉ␾ȁᗬ⑇☇๥఺ᗰ᪤ᖛḺᨨŊ☦ག✭Ṁ៾Ř⒥✛⁘☚ട✰ᇉʱᅉᵢᕱ☳ᵥ౲œ⒥ᕱഢ❂ၒŒ♣អᖛគೳᔦᅉ୴Ҁᔦᔦᢊᗿᗬ᫗ƞᗿᗿ☴ᮀᢊᗬᝢˣᅉឱ࿩ŝ♄ƞᅉŇ✴ག❨ၒņ♱ᅉ♁ṻŃ✮ഢ❲ၒŹ♗౲✼„Ŀ⒥ʱഢ❼ၒž❉ᖛ❋ᇛᕱ❏ཌᕱᕱᩴ☹⑮❦ᰐག❭ൊߝᖛൎᕎᗽᾕᦳŵ♹᫸ୋᜆ൝޲♏ሤछĵ♱⏢ൎʙἩ൒ᴿ┾♱ʙ୯ᙦާኛ₥፸⚰ႪẬႪ⎩᥏ൢҀĝ⛩౻⒙൘ᆄՑ⚖౭⚘ಶမѲǺᖻፑᣄ⟌ཛѲ⊷ӽň፯࠻✥಻఺ʙố▱᥾ᨠᖴ⏌࿨঩ᷮᵈᨧ᫷ಾ⋌◗Ꮋ޲Ɗ⟏◀ᜦዢछᇢౙἦ₦ഺ೿Ϊ◐⒀೽Ɛ⟌౶ᒡቴ►⋧೯ᘄ౪◞᧻ಾǁ⟏౿छᵍᴤዑἊዑ᠞⌉ҋढ़ᎅᕅ↦ᗖᨡ‿ҋ◼⓱◾ˣᕅȾὛᗖ↦⛾ਖ਼⇫ਖ਼ᕎ⌒⓽⌴⍊Ⱦᶅߝ✇⑰᭦⓼␺ᯣ⃠᳒ƪ⟌☘༠⟌ഢǙ⟌ṻƧ⟌⌴ട⡃ၒ⡀ያ☡⇔ᗬ⍶ჁᅉˍȀ✵ȅ⡑གơ⟏೮┠␺༈☵➏౻➍ᢊᖛᕎ♁❊Ṛ┛☻អ⠜ᮀ⍒ƭ⡁༣ߝǖ⡄ဌ⠾ടǕ⟭᫸⍆ṻǒ⠻ག⡻ၒǈ⟏☠᫸⑝֛⟌☧ൈ⡴ߞ⡘␿ᗤ⍑☭᫸រ഼☲⑬⡧ዢߝ♁὎⡷ढ़⑄౑ᕅ☷➙ᓾǄ⟏൘ढ़Ⱦᵽ൝ʙ೼⛥ለ⡷⚇ᢽ⃐൒ಛഢਲ╢⊣ᤩѲ≂ᡈ஌Ѳ஗ᐚӽŦ⟕⛄↿஛⟚᭓▲໲᧖঩᧓↚⟣ፃ޲⟦Ⓕ᭞₞ᛧ⡷ዊൎ⟱ፐ⟴ᅸ⟶⣛ഽ⟺޲Ǫ⟽౪⟿᜖⠁౲Ӄ⠄೥ᴝಾŞ⠊ṔḔ⠏⌐⛭ȁ⠓⍏⠖⃐⓽⠚ᩐȁ⠝ҋᕅႲ⠠ထ⠣⣸ᯜ⛿Ẓ✊⤇⠬࿩◸⁉⣼✉᫺⤍⟗๦᫽ḸᲮṳ‟⡼•⡁᳒Ă⡲ᓰ⢉ȁĵ⢁➏⇯⃴⡍␯ᅉĽ⟌⡓ȁ⤪዆⡚⢎ᮀ☶ᒝ⡠ˣ⡢✗⤶អᢊ⢕⤈➕⇭⡫࿩ć⡮᫸Ĳ⤞ട⥅ၒı⡷ߝ⡹᳒Į⤙ട⥏⊔⤣⡋ᡱᶝĪ⢆ག⥘⤯␿⤱ᗬ⤳∘⤸✿Ⓧ␺⍂⢖⤸ᓾ⥊ൊ⢛ၧ⢞═ᦳġ⢣ᵣ⢦ᓤ⢩ᵣൢಾǟ⢭ᑰᅰἣ⢱ᶹŚ⣢ಅ൬቉ಎ◕₏ާố⣊ေ঩᧖Ⱦ᧓དᷮᔩᆻ⋊Ӄ⋌⠆ഌಾŅ⡷ဩൎ೼ᒢౙ↷᧫⟿ഋΪ޲⠌ሤಾŋ⦂↩᜖⟩⛮⎆᜖⠍⏯ᵵᗩ፦⁣ḔᒤἊᒤ᠞ढ़↦◶ਖ਼ᗖ✅Ԛᎅ⠨ҋ⠪⧁⑰ெ᰿⤍ᯜ✅ߝ␍ᕎᶷ᭸⧓ᯜწெ⠦⍿⠳ਖ਼წ⍿⤒య஛ᗤ᪤ᅉ✫៾Ɩ⦶⡅჎⦶ṻţ⟌⧗ട⧭ၒ⧧ያ⤧ᵢᗰ⥦မᚋ⦶ᗰഢ൞዆♪ᙌೳ⤷ᚋҀ➄Ṛʱწ☿౲ʱ␼┡᭸➘⤐⤾ெŨ⥃ᕎƓ⦶⧯ྣ⦶ề⦶ཛᕎ⑇ᨳƆ⧨ག⨢⧴╆„ƌ⦶⤬ಀ⨛ടƋ⨝೮⨀ᇛᗰ⡣ཌ⤵⥤⡚ᦩ⑰☿⨜ൊ⥮ൎᗖ⡤∧ഢƂ⨝൘ᕅ޲ᚖ൝ާ⑔ൢӃŀ⡷ↄၧ۾↵൒ᡐഢƻ⦶౶̛ᐚȅ቉▯៪⒭⟟ố⦏ᑦȾ᧖޲᧓ၞᷮ␋ᑷ⋊ୋ⋌⦳ඝӃƦ⨝౑⋾ൎढ़⌒ౙᶡ᧫ಾछഈΪಾ⦸⩎ᜎ⩚౪Ӄ᧵⦘⠂ᯐቴ⣳ᠤୋǟ⨝౿⇣ḔẉἊẉ᠞☀⧉⠥ḥȅߝḪ⧒⧜Ẕ⁁␺⧘໱⧚✀⠩↺᭸☄ᗤ☄ߝ♞⤿ಾ⑶␺⧚⍇⑶⧟ྖڄᲰᜓ␛ǆ⨘ག⫀ၒǶ⧫᳒ǃ⦶♞ട⫈⫄⨝೙⧷⇔ᖛ⍉မᗰǾ⦶ᖛഢ⫖዆⢓រೳ⨈⡫Ҁʱ⨌ˣᕱᗤ⤾ᯰ➋❠➏␼❗⨏ὤǉ⧫༣წǳ⫉␞⨭ȅǲ⩶␺⍎ᨳǦ⫁ഢ⫾ያ⫐⢄Ǭ⧻ག⬅ၒǫ⨰⥢⡞⨂␺គ഼⨆ᩴ♪⨺წ⨒ട⫹ൊ⩁ၧԚ⨊⩃ടǢ⩆ṟಾ᪽൝☁ṟൢୋơ⫺⩔ၧ̛ᢿ൒➻∅⪇൙Ə୾቉῟⣂☈ᨥố⩩ἐⓁ⦔⛉໱ᷮၩ᫡⋊೟⋌⪏ᵀĆ⫺⓰ൎᕅᶷౙ᳖₦ᶨᵽΪẎ⚀೥Č⬴℘⦲ⓒာಹ౪⛕⏯೟ŀ⪓ᶇ⛲ᴤṙἊṙ᠞⤌◭⟯⪟␂ᕎ↦⌽ਖ਼⪯⠧␿ெߝӃ⪵ᕎἫ✝⭷⤏➏⠲✋࿩ᕎӃ␾ᗤ⪵✈⍆⪺ྊڄᗬ᪤ᗰ⧥ƞŗ⫵ഢ⮗✱ƞĤ⦶⢇ȅ⮝ၒ⮚ᇉ⫒⇔✻␯ᖛğ⦶❾ട⮪዆➍ᚋೳ⫥⡩Ҁ➊Ṛ❎౲ᕨឰṚ⢓ᢊ❡⮂᫗ெĩ⧫ഏᗤŔ⮞ག⯇ൊᗤ☷ṻő⮘ട⯏ၒŇ⫎អ⫓᳒ō⫗ག⯙᾽⬋⮰ᇛʱ⫦ཌ⫢⑬⮽ዢᗤᗽጠ⫺⬝ၧ➔⥯ᓾŃ⬢ԚӃὡ൝⠯ᯜൢ೟ā⫺⬯ၧ➧Ꮻᆳഢż⨝ᘌᴌᔿցၩᅰಇ஌ಪᮙ̛ᔲඟȭಎ╷᳛ጩˣΪሣ࿁౪̛ŽỈʙቡᇩᎇ⠵޲ốಾ⭂ᰰ஛⛌ᴽ೯⛏ፃ೟᫷⛓⃟₞೿ᝃዢ⛚⩀ṝᅲᶇᐻ⛡ᅸ⛤ሤ೟Ť⬴⛫ᤩ⣳౲♻ቴ⭩⏯छǘⰵ᧿ᗖ⛸ᴤ⛺⍊␙⪥⤆✁⌍✄⮂⠲ᅉ⮅➏ெ✎┞᭸✒⣻➏✖✘⪣✛ˣ⮁✟Ɫȅ✣⬺✦஛✨ᗲ⠸ᨨڈȀ⮟ᏖⰵഢƮⰵᨳⱾ⡒ᔽⱎ೙⮧✽⤸⇗౲Ʒⰵ❄ടⲋၒƶⱎ೮⨆❌⮻➈౻❒Ṛ❕➐❘ⲝ❛☺ˣ❞ਖ਼⮿⍒ƁⱿഏᅉƫⰵ⨫Ⲫൊ❯⤗ƟⰵⱺᷟⲄ❹♚ᨨƥⰵ⮬ΫⱼടƤⲒ⡥ⲕ➇⮹഼⮶➌❜ዢᅉ⯁ടⲭ⥧⫧౑➗⯯གǛⱎ൘ߝ➞ᓤ➡◾౥छƙⱎ౑⯿ཛ➩ሙ➬༪ⱎⰘሟ໔ආց۾క⢾ƞŌ⣁⩡▨⋉⟛⟠₽⣉⟠⣌ᑯⒸ⣏ከ⣑೯⣓Ԍⳟ↲⣗ဪተ⣚ቩ⣜ⴊ⣞ሤ޲ǃⰵ⟾⋤౪⣦ʱ⣨ቴ⪋ᠤಾķⱎ⠋ഽᤱ⣱℉ⱆ⣵⑅Ḡᶇ⠘ᨖ⪥◻ⱥ⣿࿩⠡✉⠤ਖ਼⠦⡪⠫⑰ⴵᗖ⠭Ṟ⯷⭲ⱞ⠴Ὲڄᯢᜍ␛ĝⰵ⠼ƞⵄᒽⱿᶝčⰵ⧩ȁⵌ⡊⢃ᇉ⧵❀ᅉĖⲫགⵗၒĕⳀ⤰⨳⢐⤴Ⳉȅ⨃⤹ᖛ⤻␻✍⡩⤿⨼ˣǠⱿ⡯ᠭⵍᶘⲽȅĉⴄ⥌⤗ľⵅག⵺ⵑ☢ᶝăⲲགⶁ⥜⢍ᇛ⥟⡞⢒Ⲉᦦ⤼౑⢗ᦳ⵶⥫♵ⰶ⡞⑷ᦳĺⳕ⥳ṝ⢨ᗌ⢫ಾǸⴄ⢮ཛ⩒ሬ⢲ടĳ⶙ᅺ܎ᗦӽ῍⏋ᲇ἖⚫⒟᷵ƈƓȀᐺടⶵᅮ⊷۾౑᨜⦇␗ຼ⦊⳺࿨⦎⟠⦑ಷⒸಾ᫷⦖᝸₞ಾŖⴄ⦝ዢ⦟ፐ⦢₦⦤ᅸ⦧–౥ಾŜⴑⴔⴓⴁḊ⦱ᤩ⩲ᠤ↮ⶶ⦷ာᤱ⦺⇰ᗌ⦽⤄⧀ҋ⧂ⴲ⴦⧆⵩ⴷ⧊⍊޲ᶅԚ⧏⌍⪢ҋწ⧕Ԛ⧗ᔑⳚ⤈✙⇵⮏ႝ᭺⧣ⱶ៾Ŷ⵲ഢ⸓ၒŦⵊᨨ⸘Ȁ⨙ȁ⸛ⵓ⨧⃴⬃❀ᗬůⰵ⧼ട⸦ၒŮⳀ⨲༈ⵤ౻⬒Ḋ⨉Ḋ⫣┟⑀Ⱬ⮹⵩⨒ˣŹⵯ⑰ţⰵ⸝ƞ⹁ၒŢⴄ⨟⌛ş⸔ട⹋⧲ⷪ⤦⨧ᨳƛⷪ⨫⹔⧿➏⨁ᮀ⨵⥡⨷ീ⨹ዢᕎ⨼ട⹇⨾ⶕཛ⬛♶ᾖƒ⹐⩇೽⩊໲⩍౥Ӄőⴄⶤ᦮⭱⩖ᶹƋ⹐ᓳྶຕց╦Ḩᴕƞዚ൮ᨀ౗ⶭሟ⋃ᮺಎᱡ፫᷼Ⴔցĝⷪⶸȅ⺔ⶻỈ۾ǰ࿧ⷀ⠵⦉๤⦋ᇩ⦍ᨥ⦐ထ⦒ፃⷋᙘ⦗Ⓗಾƪ⹐౑ⷓཛⷕȅ⦡ᅴ⦦ഽ⦥೽⦨⥸ឰⷪ౶⦭ᤩ⦯⠂ⷥ౶ⷧ౺ӃǤ⹐౿⦸ⷭᗌ⦻ⷰ⍏⦿἖ⷵ⭰⧅⤉ⴶ⧉ⴹ⓽ⷽᔑ⸀⧑⪤⧔ⷶ⸇ⱖ⇵⧛⸃⸌₏⧢ᗧ⃠ᶝǻⷪⵎюⷪṻǈⷪ⹃⻵ၒ⻯⨦⍶⸢⵨⧹ƞǃⷪ⸨ώ⹐⨱⹙ᇛ⸰⨅⤺⸳⥀⨋├⸸ȅწ⨐⑰⸼ߞ⻳ഏᕎǸ⻶ག⼚ൊ⹉ᡚƞǵ⻰ག⼢⬉⹐೙ⵔṻǱ⹕ག⼫ၒǰ⼅➏ᅉ⹚⨴⥨഼⹞⢌➎⹢ᦳ⼝ⶔ⢟౑⹩ⶖᓾǧ⹭ᶇ⩉ᓤ⩌ⰻ⹳ᐈ⺰౒▿ಅ⩕╞གǠ⹽ፑፙցᱡʊỚ⚘ལ⺇ⶪኂỔ⏋᮶ᲈਖ਼ⶲ⊭᷵Ų⺕ག⽩⺙⅞۾⒕⶿ⱱ⟘▰⛇࿨⣋ⷅ⺥⩦᳷ዓⷊ⦕ⴀⴙစÿ⽍⺲⩷ᩐ⺶ᐻⷙቩⷛ೩ⷝƞą⺿ⷡ᧵⻃౲⻅⛪⚙೯Ź⻋Å⻎೼⻐⭣␁⻓◷⭱ȁ⧄⭹ⴵ⧈ⷴⷻṞ⻝⪥⻟⪫⧕⸄⻣࿩⧙⵩⸋⧞⻪Ḹ⧤⤗ŏ⼣ഢ⾼⮛ŝ⼛ഢ⿁ၒ⾿⸠⻼⫏⻾໺ᗬŘ⼂ག⿍⮢⼱⸮⬎⹜⼊ⵦ⼌⨊⯤⨍⡦⸺⤽ὤĢ⻳༣ᕎŌ⿂ട⿤ၒŋ⽍⼟⁜ŀ⾽ട⿭⻻ᶜᨨŅ⼬ഢ⿴⹘⼳ⵟ⹜⼷ⵢ⹟⼐Ⳑ⥀ഢ⿩⹦⼿ṟ⩂ᏬⰂ⽅⩈⁀⩋ᵣὍ⽋ĺ⽍⹷ᣀ⹹⽒ഢŵ⽕⹿ᤩ⽘⚑໎஌໎൯⽟ᆔⶮ⋃ᮾṚ⺐ᴊˢᴁᎦౚടǈ〬ཛցⶼސ⺝⽲⤓ڄ⺠ᛡ⽷⺤ᡗ⷇⺧ⷉ⳿ⷌ⽿⺭ష〰⺱⪞⾅⦠ာ⾈⺹ⷚ⣯⺽ƚ〬⻀ⷢ⾓ʱ⾕ⴟ᧻ӃǏ〰⻌ⷬᴤⷮഀ⻑ⴥ⾡⧉⧃ⷷ⻘⾨⍊⻛ṟ⾬⾤⾣᫸⻠⾰⻡⧖⾳೽⧚ᕎ⾶〶⧠⸏⻬␛ƴ〬⻱みၒƤ〬ṻਨ⸜གょགや⿱⧶⻾೤ᗬƬ〬⼃᚝〰⼆⿹ⸯ⑰⨄⡥ᢊ⫟⿙౲⿛ⵧ⼓ᕎ⼕੭ゅ⼘ƞơ〬⹃オ⼞⡛⁜ǖむဌ〰⼨⹒ᶝǛ〬⨫ジ⿸♵ೳ⼵ᚋ⿼Ⲡ⨸⿿⨻ᦳキ⼾⛛⥨⽂⡽〰⹮⽇ግ⽉』೯Əう⽎⩓〕⩗ടǋ〰⹾᪕⚘⽙⺃Ῥ╞቉̛⟖₏⣅ೀ⟜້⣈⟟〻⽻⪞⛆⣐⟨Ⓗ޲ǳフ⣖⟰ⴇ⟳⺷ዏെ⟸ⴍൢ޲ǹげ⣣ⷢⴕ⠃ⴘ⾗ಾĮぜ⣯ⴠာ⠐ぞち⓯⴦⠗⧉⣺⴫◽⤀┤⤂⍊⪝⤆⾧⻘ⴸ⤋ထ⠰⮃へぺ⪻᭸⠷⮕Ą〬ⵆㄮ┆ㄱ⧊ടㄳ⃴⥕⿇ᨻ໺ᅉčス∨〬ഢČゖ⼹⤱⡝រҀ⨷ȁ⸰ㅊ⼋⼑⵨⿞⡪⵬ஜェ᫸āゲഢㅖ➓Ɫṻľㄯ⵼ㅀടĵゴ⤤⿲៾ĺ〬ⲳㅧⶅ⡛⢏⥠ⶊ⥣ീⶍ᫸⢘ടㅙዢ⥬⭏⹧⬟ȅıネ⶚⢧൏⢪⦩Նフⶢ⥽ሙⶦȅĪ㄄౒ᱡ൘ӽȥ⚷໺ӽĥ〬ౣᦇㅠᢂᚃⶣ⎿ᐚ̛೙ᎀᨖ⸍ᅕⒼ⩤〾⩧⛆⩪೽⩬ፃӃ᫷⩰ᗅⒽӃŏフ⩸ㅷ⤇⩼ー⩿ឳ⪂Å⪅ŕㆌ⪉ㄉᴙ⪍⛬⾗ ㆛⪔ぢ಄⪗⍏ⱊ⌌✅ⴱ⭰◹⪠⾯⪣⸅⪦ᔑಾ⪩ヰ⑰⭅┘⮂⪰⭺⪳⎁⪶⮂⪹₏⪽ល⻭ᨨŠカག㇮⮛ŭ〬⫊ȅㇳၒㇱᇉ⸣⃴⮥┎ᮀŨ〬⫘ട㈀⫛⤸⫝౲⸴౻⿚⫤␿⫧Ⳇ⫪❺⸷⫭␺⯩ˣŲゅ⫲৔ᚃㇵ஄ᚃ⌵㆛౑წ⫼᳒ƙᚃ⹃㈥ၒƐ㆛⿉⧸ᶝƕᚃゔ൞㆛೮⫝̸⼈⬏ཌ⸲⥤⬔ዢ⬖ᦳȌ⬚ナཛ⯬⹪ᦳƌ㆛൘ᗖ⬤ᓤ⬧⇜౥ୋŊフ⬭ᦰ⪞⬱ᶹƅ㆛ᓳᐺፙ῔᣿ⅰஙӽ῁㆞ƞŐ᥆ᡒⷁ࿨ㆦ⺦ㆨᨧㆪ⣠‒Ⓒㆮ᝸⩱ㆲᜎ㈠ⓦၧ⩺ፐ⩽₦ㆻ⪁໱⪄⽋Ʋᚃ◖ⷢ⪋౲㇅ⱅ㇇ƞǦ㇉ᵣ⭣㇌ᵣ⪘ᵣ⪚は㇒ᔑ㇔἖⸂⸹㇘⻤の㇛⤿ⱘ㇟⭶ҋ⭸⡪⪲⭲⪴⸹⪷␿㇨㉧㇪஛ᗬ⮕ǽ㈦♉ᚃᨳ㊳Ȁ㈜Ԍ㈫ᮀ⥦ㇼ⸸Ⴡᗰǆᚃ㈂ȅ㋃ၒǅ㈳⬌㈇ゞᒝ㈋ȅ⮳㈎ᯰ⮾⫫ˣ᱉⪣㈕ȅǏ㊶㈙Ǻ㈛ག㋞ၒǹ㉶㈢⌛Ƕ㊴ഢ㋧ၒǭ㊼⸣ᨳǲ㈰ំ㋊㈵゙㈉⬑ㅍീ㈻ཛ㈽ᓾ㋣㉀⡤♎⼍ㅻΣ㉇⬣⁉⬦ᶇ㉍೥Ƨ㉶㉒᩽⬰⴩གǢ㊃ங̛ూ൝⋁ጌ㉙ⅎඕ"),
        [(#{38, 623, 872, 229} + 779131956)] = ("\98"),
        [(614095247 - #("titto sex chat llm when?"))] = ("\117\110\112\97\99"),
        [(401388743 - #("Grazie Dario"))] = ("\107")
    }
)
