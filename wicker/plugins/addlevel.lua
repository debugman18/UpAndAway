local levels = require "map/levels"

local type = type
local ipairs = ipairs
local pairs = pairs

--- 

local leveltype_map = {
	[_G.LEVELTYPE.ADVENTURE] = "story_levels",
	[_G.LEVELTYPE.SURVIVAL] = "sandbox_levels",
	[_G.LEVELTYPE.CAVE] = "cave_levels",
	[_G.LEVELTYPE.TEST] = "test_levels",
	[_G.LEVELTYPE.CUSTOM] = "custom_levels",
}

-- Returns a table in the format of worldgenoverride.lua
local function GetLevelWorldgenOverrides(id, flatten)
	assert( id )

	local leveltype = assert( levels.GetTypeForLevelID(id) )

	local GetGroupForItem = assert( require "map/customise".GetGroupForItem )

	local data
	local levellist = assert( levels[leveltype_map[leveltype]] )
	for _, mbdata in pairs(levellist) do
		if mbdata.id == id then
			data = mbdata
			break
		end
	end

	assert( data )

	local overrides = {}

	for _, p in ipairs(data.overrides or {}) do
		local gname
		if flatten then
			gname = "overrides"
		else
			gname = GetGroupForItem(p[1])
		end
		local g = overrides[gname]
		if g == nil then
			g = {}
			overrides[gname] = g
		end
		g[p[1]] = p[2]
	end

	overrides.override_enabled = true
	overrides.preset = data.id

	return overrides
end

local function AddLevel(leveltype, data, ...)
	assert(data.id)
	assert(data.location, "DST requires level data to specify a location")

   return modenv.AddLevel(leveltype, data, ...)
end

TheMod:EmbedFunction("GetLevelWorldgenOverrides", GetLevelWorldgenOverrides)
TheMod:EmbedAdder("Level", AddLevel)

return AddLevel
