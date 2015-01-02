---
-- Main worldgen file. Run through modworldgenmain.lua.
--
-- @author debugman18
-- @author simplex



BindModModule "modenv"
-- This just enables syntax conveniences.
BindTheMod()

wickerrequire "plugins.ensureuniqueid"

-- This allows us to store +-infinity in savedata.
wickerrequire "plugins.savable_infinity"

-- These embed the corresponding methods in TheMod.
wickerrequire "plugins.addtile"
wickerrequire "plugins.addsaveindexpostinit"


modrequire "api_abstractions"


LoadConfiguration "tuning.lua"
if _G.kleifileexists(MODROOT .. "rc.defaults.lua") then LoadConfiguration "rc.defaults.lua" end
LoadModConfigurationData() -- modinfo.lua stuff
if _G.kleifileexists(MODROOT .. "dev.rc.defaults.lua") then LoadConfiguration "dev.rc.defaults.lua" end
if _G.kleifileexists(MODROOT .. "rc.lua") then LoadConfiguration "rc.lua" end
if _G.kleifileexists(MODROOT .. "dev.rc.lua") then LoadConfiguration "dev.rc.lua" end


modrequire "worldgen_patches"

modrequire "modcompat"


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

modrequire "map.tiledefs"

modrequire "map.layouts"
modrequire "map.rooms"
modrequire "map.tasks"
modrequire "map.levels"

local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
TRANSLATE_TO_PREFABS["skyflowers"] = {"skyflower"}
TRANSLATE_TO_PREFABS["sheep"] = {"sheep"}
TRANSLATE_TO_PREFABS["cloud_bush"] = {"cloud_bush"}
TRANSLATE_TO_PREFABS["hive_marshmallow"] = {"hive_marshmallow"}
TRANSLATE_TO_PREFABS["bee_marshmallow"] = {"bee_marshmallow"}
TRANSLATE_TO_PREFABS["goose"] = {"goose"}
TRANSLATE_TO_PREFABS["cloudcrag"] = {"cloudcrag"}
TRANSLATE_TO_PREFABS["skyflies"] = {"skyflies"}
TRANSLATE_TO_PREFABS["crystal_relic"] = {"crystal_relic"}

local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")


--[[
-- We'll just use an existing layout here, but feel free to add your own in a
-- scripts/map/static_layouts folder.
Layouts["ShopkeeperStall"] = StaticLayout.Get("map/static_layouts/shopkeeper_stall")

AddRoomPreInit("PigKingdom", function(room)
    if not room.contents.countstaticlayouts then
        room.contents.countstaticlayouts = {}
    end
    room.contents.countstaticlayouts["ShopkeeperStall"] = 1
end)

GLOBAL.require("constants")
local GROUND = GLOBAL.GROUND

AddRoom("Shopkeeper", {
    colour={r=.010,g=.010,b=.10,a=.50},
    value = GROUND.MARSH,
    contents =  {
            countprefabs= {
                shopkeeper = 1,
                gravestone = function () return 4 + math.random(4) end,
                marblepillar = function () return 1 + math.random(3) end
        }
    }
})
]]--

--[[
local function InsertShopkeeper(task)
    -- Insert the custom room we created above into the task.
    -- We could modify the task here as well.
    task.room_choices["Shopkeeper"] = 1
end
AddTaskPreInit("One of everything", InsertShopkeeper)
]]--
