--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

-- This just enables syntax conveniences.
BindTheMod()

-- These embed the corresponding methods in TheMod.
wickerrequire 'api.plugins.addtile'
wickerrequire 'api.plugins.addsaveindexpostinit'


modrequire('api_abstractions')()


----------------------------------
-- Custom Level mod example
--
--
--
--  AddLevel(newlevel)
--		Inserts a new level into the list of possible levels. This will cause the level
--		to show up in Customization -> Presets if it's a survival level, or into the
--		random playlist if it's an adventure level.
--
--	AddLevelPreInit("levelname", initfn)
--		Gets the raw data for a level before it's processed, allowing for modifications
--		to its tasks, overrides, etc.
--
--	AddLevelPreInitAny(initfn)
--		Same as above, but will apply to any level that gets generated, always.
--
--	AddTask(newtask)
--		Inserts a task into the master tasklist, which can then be used by new or modded
--		levels in their "tasks".
--
--	AddTaskPreInit("taskname", initfn)
--		Gets the raw data for a task before it's processed, allowing for modifications to
--		its rooms and locks.
--
--	AddRoom(newroom)
--		Inserts a room into the master roomlist, which can then be used by new or moded
--		tasks in their "room_choices".
--
--	AddRoomPreInit("roomname", initfn)
--		Gets the raw data for a room before it's processed, allowing for modifications to
--		its prefabs, layouts, and tags.
--
-----------------------------------

modrequire 'map.tiledefs'
modrequire 'map.layouts'
modrequire 'map.rooms'
modrequire 'map.tasks'
modrequire 'map.levels'


--[[
-- Type ClimbTo(0) in the console to return to the surface.
--]]
if TheMod:Debug() then
	GLOBAL.ClimbTo = (modrequire 'worldgen.climbing').ClimbTo
end


--This also does the following.
local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
TRANSLATE_TO_PREFABS["skyflowers"] = {"skyflower"}
TRANSLATE_TO_PREFABS["sheep"] = {"sheep"}
TRANSLATE_TO_PREFABS["cloudbush"] = {"cloud_bush"}

-- Should we really change the MULTIPLY table for all map generation?!

-- It is part of the API now, and these values are only called when the level is created. I'll change the values for testing purposes until
-- realm_map is implemented, or whatever is decided on.

--[[
-- They are used on EVERY level creation, not just ours. And it screws up the
-- parameters for testing real worldgen.
--
-- Anyway, I commented them out again since I'm working on the worldgen.
-- They are meant as a tweak on existing maps, not on new ones! They may help
-- with testing, I guess, but I think editing the rooms directly is better.
--]]
--[[
local MULTIPLY = GLOBAL.require("map/forest_map").MULTIPLY
MULTIPLY["up_everywhere"] = 60
MULTIPLY["up_moreplaces"] = 15
MULTIPLY["up_fewplaces"] = 3
]]--
