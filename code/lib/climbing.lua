--FIXME: not MP compatible

---
-- Functions for adding, entering, exiting and failing (dying in) a cloud realm,
-- as well as a few utility functions.
--
-- @class module
-- @name upandaway.lib.climbing
--

BindGlobal()


local Levels = require "map/levels"
require "map/level"

local Game = wickerrequire "game"

-- A table of predicates (functions returning true or false).
-- We both use existing ones and insert mod-specific predicates here,
-- to have them in a centralized location accessible throughout the code.
local Pred = wickerrequire "lib.predicates"

wickerrequire "plugins.addpopulateworldpreinit"


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

local cloud_level_object_set = {}

function IsCloudLevelObject(obj)
    return cloud_level_object_set[obj]
end
Pred.IsCloudLevelObject = IsCloudLevelObject

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
    cloud_level_object_set[L] = true
    Levels.cave_levels[current_level] = L
    TheMod:DebugSay("Added Cloud Level to cave_levels[", current_level, "]")
end
TheMod:EmbedAdder("CloudLevel", AddCloudLevel)

---

local function get_saveindex_topology(slot, cavenum)
	local SG = assert( _G.SaveGameIndex )

	local t = {}

	if slot == nil then
		slot = SG:GetCurrentSaveSlot() or 1
	end

	t.level_type = SG:GetCurrentMode(slot)
	if t.level_type == "cave" or t.level_type == "cloudrealm" then
		if cavenum == nil then
			cavenum = SG:GetCurrentCaveNum(slot)
		end
		t.cavenum = cavenum

		t.level_number = SG:GetCurrentCaveLevel(slot, t.cavenum)
	end

	return t
end

local function get_savedata_topology(savedata)
	local topo = assert(savedata.map and savedata.map.topology)

	local SG = rawget(_G, "SaveGameIndex")

	local t = {}

	t.level_type = topo.level_type
	if t.level_type == "cave" or t.level_type == "cloudrealm" then
		if SG then
			t.cavenum = SG:GetCaveNumber()
		end

		t.level_number = topo.level_number
	end

	return t
end

local function ptable(t)
	local pieces = {}
	for k, v in pairs(t) do
		table.insert(pieces, tostring(k).." = "..tostring(v))
	end
	return "{"..table.concat(pieces, ", ").."}"
end

local cached_saveindex_topology = nil

local cached_savedata_topology = nil
TheMod:AddPopulateWorldPreInit(function(savedata)
	--TheMod:Say "CLIMBING SAVEDATA"
	cached_savedata_topology = get_savedata_topology(savedata)
	cached_saveindex_topology = nil
end)

local function get_current_topology()
	--TheMod:Say "get_current_topology"
	if cached_savedata_topology ~= nil then
		--TheMod:Say("savedata: ", ptable(cached_savedata_topology))
		return cached_savedata_topology
	end

	if cached_saveindex_topology == nil then
		local SG = assert( _G.SaveGameIndex )

		local slot = SG:GetCurrentSaveSlot()
		cached_saveindex_topology = get_saveindex_topology(slot)
	end
	--TheMod:Say("savindex: ", ptable(cached_saveindex_topology))
	return cached_saveindex_topology
end

local function get_topology(slot, cavenum)
	if not slot then
		return get_current_topology()
	else
		return get_saveindex_topology(slot, cavenum)
	end
end

---

local function is_current(slotnum, cavenum)
    if slotnum then
        if slotnum ~= SaveGameIndex:GetCurrentSaveSlot() then return false end

        if cavenum then
			local mode = SaveGameIndex:GetCurrentMode()
            if moce ~= "cave" and mode ~= "cloudrealm" then return false end
            if SaveGameIndex:GetCurrentCaveNum(slotnum) ~= cavenum then return false end
        end
    end

    return true
end


local function get_default_height(slot, cavenum)
    -- wicker imports the SaveGameIndex.
	local lt = get_topology(slot, cavenum)
    if lt == "cave" then
        return -1
	elseif lt == "cloudrealm" then
		return 1
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
	local lt = get_topology(slot, cavenum).level_type
    if lt == "cave" or lt == "cloudrealm" then
        return level_to_height(get_topology(slot, cavenum).level_number)
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
IsCloudRealm = IsCloudLevel
Pred.IsCloudLevel = IsCloudLevel
Pred.IsCloudRealm = IsCloudRealm

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
	if not IsHost() then
		return error("ClimbTo() should only be used in the host.", 2)
	end

    assert( Pred.IsNumber(height), "The given height is not a number." )
    assert( height == math.floor(height), "The given height is not an integer." )

	local topo = get_current_topology()

    if not cavenum then
        if topo.level_type ~= "cave" and topo.level_type ~= "cloudrealm" then
            return error("Attempt to climb outside of a cave level without giving a cave number.", 2)
        end
        cavenum = topo.cavenum
    end


    if height > GetMaxHeight() then
        height = GetMaxHeight()
    end
    if height < GetMinHeight() then
        height = GetMinHeight()
    end

    local current_height = GetLevelHeight()

    if height == current_height then
        TheMod:DebugSay("There are no more levels to climb to in this direction.")
        return
    end


    local function onsaved()
        StartNextInstance({
            reset_action = _G.RESET_ACTION.LOAD_SLOT,
            save_slot = SaveGameIndex:GetCurrentSaveSlot(),
        }, true)
    end

    local levelchange_cb

    if height == 0 then
        levelchange_cb = function()
            TheMod:DebugSay("Returning to survival...")
            SaveGameIndex:LeaveCave(onsaved)
        end
    else
        -- Target level
        local level = height_to_level(height)
        levelchange_cb = function()
            TheMod:DebugSay("Climbing to height ", height, " (level ", level, ")...")
            SaveGameIndex:EnterCave(onsaved, nil, cavenum, level)
        end
    end

    local function cb()
        Game.Reflection.EnableModInCache()
        return levelchange_cb()
    end

    SaveGameIndex:GetSaveFollowers(_G.GetPlayer())
    SaveGameIndex:SaveCurrent(cb, height < current_height and "descend" or "ascend", cavenum)
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
