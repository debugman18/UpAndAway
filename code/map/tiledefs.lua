local Terraforming = modrequire "lib.terraforming"
local Climbing = modrequire "lib.climbing"

local new_tiles = TheMod:GetConfig("NEW_TILES")

require 'util'
require 'map/terrain'

-- Count the entries in a non-indexed table.
local function QuantifyTable(table, name)
	local count = 0
	
	for k,v in pairs(table) do
    	count = count + 1
	end

	TheMod:DebugSay(count.." tiles of table "..tostring(name).." counted.")

	return count
end

-- Ignore these (and this many) tiles.
local IGNORE_TILES = TheMod:GetConfig("IGNORE_TILES")

-- Check to see how many tiles there are.
local GROUND_COUNT = _G.GROUND
local GROUND_COUNT_QUANTIFY = QuantifyTable(GROUND_COUNT, "GROUND_COUNT")

-- Ignore this many tiles, since they're invalid, noise or walls.
local IGNORE_TILES_QUANTIFY = QuantifyTable(IGNORE_TILES, "IGNORE_TILES")

-- Our "real" tile count.
local TILE_COUNT = GROUND_COUNT_QUANTIFY - IGNORE_TILES_QUANTIFY

-- We will manually set this.
local LAST_KNOWN_COUNT = TheMod:GetConfig("LAST_KNOWN_COUNT")
TheMod:DebugSay("Found "..tostring(TILE_COUNT).." tiles.")

-- Add new tiles.
local CURRENT_ID = LAST_KNOWN_COUNT + 1

for i, v in ipairs(new_tiles) do
    local v_upper = v:upper()
    TheMod:AddTile(v_upper, CURRENT_ID, v, {noise_texture = "noise_" .. v .. ".tex"}, {noise_texture = "mini_noise_" .. v .. ".tex"})

    -- Let there be dirt.
    -- Terraforming.MakeTileUndiggable(GROUND[v_upper])

    CURRENT_ID = CURRENT_ID + 1
end