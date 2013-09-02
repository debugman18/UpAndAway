GLOBAL.require 'map/terrain'

local tiledefs = GLOBAL.require 'worldtiledefs'
local GROUND = GLOBAL.GROUND
local GROUND_NAMES = GLOBAL.GROUND_NAMES

local resolvefilepath = GLOBAL.resolvefilepath

local assert = GLOBAL.assert
local error = GLOBAL.error
local type = GLOBAL.type

--[[
-- The return value from this function should be stored and
-- reused between saves (otherwise the tile information saved in the map may
-- become mismatched if the order of ground value generation changes).
--]]
local function getNewGroundValue(id)
	local used = {}

	for k, v in pairs(GROUND) do
		used[v] = true
	end

	local i = 1
	while used[i] and i < GROUND.UNDERGROUND do
		i = i + 1
	end

	if i >= GROUND.UNDERGROUND then
		-- The game assumes values greater than or equal to GROUND.UNDERGROUND
		-- represent walls.
		return error("No more values available!")
	end

	return i
end


-- Lists the structure for a tile specification by mapping the possible fields to their
-- default values.
local tile_spec_defaults = {
	noise_texture = "images/square.tex",
	runsound = "dontstarve/movement/run_dirt",
	walksound = "dontstarve/movement/walk_dirt",
	snowsound = "dontstarve/movement/run_ice",
}

-- Like the above, but for the minimap tile specification.
local mini_tile_spec_defaults = {
	name = "map_edge",
	noise_texture = "levels/textures/mini_dirt_noise.tex",
}

--[[
-- name should match the texture/atlas specification in levels/tiles.
-- (it's not just an arbitrary name, it defines the texture used)
--]]
function AddTile(id, numerical_id, name, specs, minispecs)
	assert( type(id) == "string" )
	assert( numerical_id == nil or type(numerical_id) == "number" )
	assert( type(name) == "string" )
	assert( GROUND[id] == nil, ("GROUND.%s already exists!"):format(id))

	specs = specs or {}
	minispecs = minispecs or {}

	assert( type(specs) == "table" )
	assert( type(minispecs) == "table" )

	-- Ideally, this should never be passed, and we would wither generate it or load it
	-- from savedata if it had already been generated once for the current map/saveslot.
	if numerical_id == nil then
		numerical_id = getNewGroundValue()
	else
		for k, v in pairs(GROUND) do
			if v == numerical_id then
				return error(("The numerical value %d is already used by GROUND.%s!"):format(v, tostring(k)))
			end
		end
	end


	GROUND[id] = numerical_id
	GROUND_NAMES[id] = name


	local real_specs = { name = name }
	for k, default in pairs(tile_spec_defaults) do
		if specs[k] == nil then
			real_specs[k] = default
		else
			-- resolvefilepath() gets called by the world entity.
			real_specs[k] = specs[k]
		end
	end

	table.insert(tiledefs.ground, {
		GROUND[id], real_specs
	})


	local real_minispecs = {}
	for k, default in pairs(mini_tile_spec_defaults) do
		if minispecs[k] == nil then
			real_minispecs[k] = default
		else
			real_minispecs[k] = minispecs[k]
		end
	end

	AddPrefabPostInit("minimap", function(inst)
		local handle = GLOBAL.MapLayerManager:CreateRenderLayer(
			GROUND[id],
			resolvefilepath( ("levels/tiles/%s.xml"):format(real_minispecs.name) ),
			resolvefilepath( ("levels/tiles/%s.tex"):format(real_minispecs.name) ),
			resolvefilepath( real_minispecs.noise_texture )
		)
		inst.MiniMap:AddRenderLayer( handle )
	end)


	return real_specs, real_minispecs
end
