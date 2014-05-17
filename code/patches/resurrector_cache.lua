--[[
-- Fixes the pattern matching related bug in SaveIndex:ClearCurrentResurrectors().
--]]

require "saveindex"

local SaveIndex = _G.SaveIndex


local fake_string = Lambda.InjectInto({}, pairs(_G.string))
fake_string.find = (function()
	local find = fake_string.find
	return function(s, pattern, init)
		return find(s, pattern, init or 1, true)
	end
end)()

local fake_global = setmetatable({
	string = fake_string,
}, {
	__index = _G,
	__newindex = _G,
})


setfenv(SaveIndex.ClearCurrentResurrectors, fake_global)
