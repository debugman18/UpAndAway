--[[
-- Usage: scriptname.lua <ORIGINAL-BANK> <TARGET-BANK>
--
-- Reads the anim.bin from stdin, prints to stdout.
--
-- (requires Lua 5.2)
--]]

local original_bank = assert(arg[1])
local target_bank = assert(arg[2])


-- Returns hash as number.
local function hash(str)
	local hash = 0
	for c in str:gmatch(".") do
		local v = c:lower():byte()
		hash = bit32.band((v + bit32.lshift(hash, 6) + bit32.lshift(hash, 16) - hash), 0xFFFFFFFF)
	end
	return hash
end

-- Returns hash as 4 chars string.
local function hashstr(str, reverse)
	local h = hash(str)
	local t = {}
	for i = (reverse and 4 or 1), (reverse and 1 or 4), (reverse and -1 or 1) do
		t[i] = string.char(bit32.band(h, 0xff))
		h = bit32.rshift(h, 8)
	end
	assert( h == 0 )
	return table.concat(t)
end

local function qt(s)
	return ("%q"):format(s)
end

local input_str = io.read("*a")
input_str = input_str:gsub(original_bank, target_bank)
input_str = input_str:gsub(qt(hashstr(original_bank, true)), qt(hashstr(target_bank, true)))
io.write(input_str)
