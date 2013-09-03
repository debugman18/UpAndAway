--[[
-- Functions for adding, entering, exiting and failing (dying in) a cloud realm,
-- as well as a few utility functions.
--]]

--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


local Levels = require 'map/levels'
require 'map/level'

-- A table of predicates (functions returning true or false).
-- We both use existing ones and insert mod-specific predicates here,
-- to have them in a centralized location accessible throughout the code.
local Pred = wickerrequire 'lib.predicates'


-- Direction of level number inserting. It should be +-1, indicating whether
-- we are adding levels after the ruins or before everything (through negative
-- indexes).
local LEVEL_NUMBER_DIRECTION = -1
assert( math.abs(LEVEL_NUMBER_DIRECTION) == 1 )


--[[
-- start_level is the first level number for cloud levels.
--]]
local start_level, current_level
if LEVEL_NUMBER_DIRECTION > 0 then
	start_level = #Levels.cave_levels + 1
else
	start_level = -1
end
current_level = start_level - LEVEL_NUMBER_DIRECTION -- We start with an empty interval.


local function is_cloud_level_number(level_number)
	if not Pred.IsNumber(level_number) then return false end

	if LEVEL_NUMBER_DIRECTION > 0 then
		return start_level <= level_number and level_number <= current_level
	else
		return current_level <= level_number and level_number <= start_level
	end
end


function AddCloudLevel(data)
	TheMod:AddLevel(LEVELTYPE.CAVE, data)

	local L = table.remove(Levels.cave_levels)
	current_level = current_level + LEVEL_NUMBER_DIRECTION
	if Levels.cave_levels[current_level] ~= nil then
		return error( ("The cave level #%d is already occupied by %q!"):format(current_level, Levels.cave_levels[current_level].id or "") )
	end
	Levels.cave_levels[current_level] = L
	TheMod:DebugSay("Added Cloud Level to cave_levels[", current_level, "]")
end
TheMod:EmbedAdder("CloudLevel", AddCloudLevel)


--[[
-- GetLevelHeight() returns the "height" of the level we are currently in. The height is 0 for
-- a survival map, 1 for the first cloud level, 2 for the second one, etc. For
-- the first cave level, it is -1, for the second one it is -2, etc.
--
-- This is primarily meant to be used as a test for whether we are in a cloud
-- level or not.
--
-- Works both under normal game and under worldgen (using different methods).
--
-- At worldgen, the level number is used. At normal game, the level number is
-- used except when we are at a cloud level, where the level id is used instead.
-- The level id is given preference because the level number can possibly change
-- for compatibility reasons, so this allows us to keep our system compatible
-- with older saves.
--
-- GetRawLevelHeight() gives the value based on the level number alone.
--
-- level_to_height is a utility function which maps a cave level number to its height.
--]]

local function get_default_height()
	-- wicker imports the SaveGameIndex.
	if SaveGameIndex:GetCurrentMode() == "cave" then
		return -1
	else
		return 0
	end

end

local function level_to_height(lvl)
	if is_cloud_level_number(lvl) then
		return 1 + (lvl - start_level)*LEVEL_NUMBER_DIRECTION
	elseif Pred.IsNumber(lvl) then
		return -lvl
	else
		return get_default_height()
	end
end

-- Returns 0 if we're not in a cave.
local function height_to_level(h)
	if not Pred.IsNumber(h) or h == 0 then return 0 end

	assert( h == math.floor(h), "The given height is not an integer." )

	if h > 0 then
		-- Cloud
		return start_level + (h - 1)*LEVEL_NUMBER_DIRECTION
	else
		-- Cave
		return -h
	end
end

-- This works even if there are no cloud levels (returning 0).
function GetMaxHeight()
	return level_to_height(current_level)
end

function GetMinHeight()
	if LEVEL_NUMBER_DIRECTION > 0 then
		-- This case relies quite a bit on the implementation.
		return -(start_level - 1)
	else
		return -#Levels.cave_levels
	end
end

function GetRawLevelHeight()
	-- wicker imports the SaveGameIndex.
	if SaveGameIndex:GetCurrentMode() == "cave" then
		return level_to_height(SaveGameIndex:GetCurrentCaveLevel())
	else
		return 0
	end
end

function GetLevelHeight()
	if not Pred.IsWorldGen() then
		local world = rawget(_G, "GetWorld") and GetWorld()
		local metadata_key = GetModname() .. "_metadata"
		if world and world.components[metadata_key] then
			local height = world.components[metadata_key]:Get("height")
			if height ~= nil then
				return height
			end
		end
	end
	return GetRawLevelHeight()
end

function IsCloudLevel()
	return GetLevelHeight() >= 1
end
Pred.IsCloudLevel = IsCloudLevel

-- Returns the next level number (for climbing up).
-- Returns nil if there are none.
-- 0 means survival map.
function GetNextLevel()
	local h = GetLevelHeight() + 1
	if h <= GetMaxHeight() then
		return height_to_level(h)
	end
end

-- Returns the previous level number (for climbing down).
-- Returns nil if there are none.
-- 0 means survival map.
function GetPreviousLevel()
	local h = GetLevelHeight() - 1
	if h >= GetMinHeight() then
		return height_to_level(h)
	end
end


--[[
-- Climbs to the given height (see also Climb() below). It should be an integer.
--
-- cavenum is the number of the TARGET "cave". If not given, the current cave
-- number is used.
]]--
function ClimbTo(height, cavenum)
	assert( Pred.IsNumber(height), "The given height is not a number." )
	assert( height == math.floor(height), "The given height is not an integer." )

	if not cavenum then
		if SaveGameIndex:GetCurrentMode() ~= "cave" then
			return error("Attempt to climb outside of a cave level without giving a cave number.")
		end
		cavenum = SaveGameIndex:GetCurrentCaveNum()
	end


	if height > GetMaxHeight() then
		height = GetMaxHeight()
	end
	if height < GetMinHeight() then
		height = GetMinHeight()
	end

	if height == GetLevelHeight() then
		TheMod:DebugSay("There's no more levels to climb to in this direction.")
		return
	end


	local function onsaved()
		StartNextInstance({
			reset_action = RESET_ACTION.LOAD_SLOT,
			save_slot = SaveGameIndex:GetCurrentSaveSlot(),
		}, true)
	end

	if height == 0 then
		TheMod:DebugSay("Returning to survival...")
		SaveGameIndex:SaveCurrent(function()
			SaveGameIndex:LeaveCave(onsaved)
		end)
	else
		-- Target level
		local level = height_to_level(height)
		SaveGameIndex:SaveCurrent(function()
			TheMod:DebugSay("Climbing to height ", height, " (level ", level, ")...")
			SaveGameIndex:EnterCave(onsaved, nil, cavenum, level)
		end)
	end
end

--[[
-- Direction should be a number. Its sign dictates the direction.
--]]
function Climb(direction, cavenum)
	assert( Pred.IsNumber(direction), "The climbing direction should be a number." )

	if direction > 0 then
		direction = 1
	elseif direction < 0 then
		direction = -1
	else
		-- assert( direction == 0 )
		return
	end

	return ClimbTo(GetLevelHeight() + direction, cavenum)
end


return _M
