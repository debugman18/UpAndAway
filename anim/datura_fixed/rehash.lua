local function hash(str)
	local hash = 0
	for c in str:gmatch(".") do
		local v = c:lower():byte()
		hash = bit32.band((v + bit32.lshift(hash, 6) + bit32.lshift(hash, 16) - hash), 0xFFFFFFFF)
	end
	return hash
end

local function hashstr(str)
	local h = hash(str)
	local t = {}
	for i = 1, 4 do
		table.insert(t, string.char(bit32.band(h, 0xff)))
		h = bit32.rshift(h, 8)
	end
	assert( h == 0 )
	return table.concat(t)
end

print(("%x"):format(hash("datura")))
