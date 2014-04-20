---
-- Functions for adding, entering, exiting and failing (dying in) a cloud realm,
-- as well as a few utility functions.
--
-- @class module
-- @name upandaway.lib.climbing
--

BindGlobal()


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


function IsCloudLevelNumber(level_number)
	if not Pred.IsNumber(level_number) then return false end

	if LEVEL_NUMBER_DIRECTION > 0 then
		return start_level <= level_number and level_number <= current_level
	else
		return current_level <= level_number and level_number <= start_level
	end
end
Pred.IsCloudLevelNumber = IsCloudLevelNumber


---
-- Adds a new cloud level. Also embedded as TheMod:AddCloudLevel().
--
-- @param data A table describing the level, as in the second parameter of AddLevel.
--
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


local function is_current(slotnum, cavenum)
	if slotnum then
		if slotnum ~= SaveGameIndex:GetCurrentSaveSlot() then return false end

		if cavenum then
			if SaveGameIndex:GetCurrentMode() ~= "cave" then return false end
			if SaveGameIndex:GetCurrentCaveNum(slotnum) ~= cavenum then return false end
		end
	end

	return true
end


local function get_default_height(slot, cavenum)
	-- wicker imports the SaveGameIndex.
	if cavenum or SaveGameIndex:GetCurrentMode(slot) == "cave" then
		return -1
	else
		return 0
	end

end

-- Maps a cave level number to its height.
-- The parameters slot and cavenum are only used if lvl is not given.
local function level_to_height(lvl, slot, cavenum)
	if IsCloudLevelNumber(lvl) then
		return 1 + (lvl - start_level)*LEVEL_NUMBER_DIRECTION
	elseif Pred.IsNumber(lvl) then
		return -lvl
	else
		return get_default_height(slot, cavenum)
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

---
-- @description Returns the maximum height among all registered levels.
--
-- This works even if there are no cloud levels (returning 0).
function GetMaxHeight()
	return level_to_height(current_level)
end

---
-- Returns the minimum height among all registered levels (including default ones).
function GetMinHeight()
	if LEVEL_NUMBER_DIRECTION > 0 then
		-- This case relies quite a bit on the implementation.
		return -(start_level - 1)
	else
		return -#Levels.cave_levels
	end
end

---
-- As GetLevelHeight(), but based on the level number alone.
--
-- @see GetLevelHeight
function GetRawLevelHeight(slot, cavenum)
	-- wicker imports the SaveGameIndex.
	if SaveGameIndex:GetCurrentMode(slot) == "cave" then
		return level_to_height(SaveGameIndex:GetCurrentCaveLevel(slot, cavenum))
	else
		return 0
	end
end

---
-- @description Returns the height of the level we are currently in.
--
-- The height is 0 for a survival map, 1 for the first cloud level, 2 for the
-- second one, etc. For the first cave level, it is -1, for the second one it
-- is -2, etc.
-- <br /><br />
-- This is primarily meant to be used as a test for whether we are in a cloud
-- level or not.
-- <br /><br />
-- Works both under normal game and under worldgen (using different methods).
-- <br /><br />
-- At worldgen, the level number is used. At normal game, we check for the
-- existence of a height value stored as metadata in the world entity. If it
-- exists, that value is adopted, otherwise the level number is used as in
-- worldgen.
-- <br />
-- Savedata is given preference because the level number can possibly change,
-- so this allows us to keep our system compatible with older saves.
--
-- @param slot (optional) Save slot to check.
-- @param cavenum (optional) Cave number to check.
--
function GetLevelHeight(slot, cavenum)
	if not Pred.IsWorldGen() and is_current(slot, cavenum) then
		local LevelMeta = modrequire "lib.level_metadata"
		local height = LevelMeta.Get("height")
		if height ~= nil then
			return height
		end
	end
	return GetRawLevelHeight(slot, cavenum)
end

---
-- @description Returns whether we are in a cloud level or not.
--
-- First, it checks if the world entity has the "cloudrealm" tag. If it does, returns
-- true. If not, checks if the level height is positive.
--
-- @param slot (optional) Save slot to check.
-- @param cavenum (optional) Cave number to check.
--
-- @return A boolean
function IsCloudLevel(slot, cavenum)
	if not Pred.IsWorldGen() and is_current(slot, cavenum) then
		local ground = GetWorld()
		if ground and ground:HasTag("cloudrealm") then
			return true
		end
	end
	return GetLevelHeight(slot, cavenum) >= 1
end
Pred.IsCloudLevel = IsCloudLevel

---
-- @description Returns the next level number (for climbing up).
--
-- Returns nil if there are none.
-- 0 means survival map.
function GetNextLevel()
	local h = GetLevelHeight() + 1
	if h <= GetMaxHeight() then
		return height_to_level(h)
	end
end

---
--@description Returns the previous level number (for climbing down).
--
-- Returns nil if there are none.
-- 0 means survival map.
function GetPreviousLevel()
	local h = GetLevelHeight() - 1
	if h >= GetMinHeight() then
		return height_to_level(h)
	end
end


---
-- @description Climbs to the given height. It should be an integer.
--
-- @param height The target height.
-- @param cavenum The number of the target "cave". If not given, the current cave
-- number is used, raising an error if we're not in a cave level.
--
-- @see Climb
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

---
-- @description Climbs in a direction.
--
-- @param direction A number. Its sign dictates the direction.
--
-- Calls ClimbTo to do the actual work.
--
-- @see ClimbTo
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
