
----------------------------------
-- Custom Level mod example
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

GLOBAL.require("map/levels")
GLOBAL.require("map/tasks")
GLOBAL.require("map/rooms")
local LEVELTYPE = GLOBAL.LEVELTYPE
local AddLevel = GLOBAL.AddLevel
local AddTask = GLOBAL.AddTask
local AddRoom = GLOBAL.AddRoom
local CAMPAIGN_LENGTH = 5

local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
TRANSLATE_TO_PREFABS["carrot"] = {"beanstalk"}

local Forest = GLOBAL.require("map/forest_map")

--[[
Forest.MULTIPLY = 
{
	["never"] = 0,
	["rare(0.1)"] = 0.1,
	["rare(0.15)"] = 0.15,
	["rare(0.2)"] = 0.2,
	["rare(0.3)"] = 0.3,
	["rare"] = 0.5,
	["default"] = 1,
	["often"] = 1.5,
	["mostly"] = 2.2,
	["always"] = 3,		
}

Forest.TRANSLATE_TO_PREFABS = 
{
    ["skymushrooms"] = {"orange_mushroom", "purple_mushroom", "yellow_mushroom"},
	["beanstalks"] = {"beanstalk"},
}
--]]

--This also does the following.


--This is the preset version.
AddLevel(LEVELTYPE.SURVIVAL, {
		id="SKY_LEVEL_1",
		name="Sky",
		nomaxwell=true,
		hideminimap = true,
		desc="Up and Away.",
		min_playlist_position=CAMPAIGN_LENGTH+1,
		max_playlist_position=CAMPAIGN_LENGTH+1,		

		overrides={
			{"world_size", 		"huge"},
			{"day", 			"onlyday"}, 
			{"waves", 			"off"},
			{"branching",		"never"},
			{"looping",		    "always"},
			{"islands", 		"always"},				
			{"season_start", 	"summer"},
			{"season", 			"onlywinter"},
			{"weather", 		"never"},
			{"boons",			"always"},
			{"spiders", 		"never"},
			{"deerclops", 		"never"},
			{"hounds", 			"never"},	
			{"roads", 			"never"},	
			{"creepyeyes", 		"always"},
			{"rabbits",         "never"},
			{"trees",           "always"},
			{"rocks",           "always"},	
			{"carrots",         "never"},	
			{"beefalo",         "never"},	
			{"grass",           "never"},	
			{"world_complexity", ""},	
			{"pigs",            "never"},
			
			--This is custom content.
			{"skymushrooms",    "always"},
			{"beanstalks",      "always"},
			
			{"start_setpeice", 	"DefaultPlusStart"},				
		},
		
		tasks = {
				"Speak to the king",
				"Tentacle-Blocked The Deep Forest",
		},
		
		numoptionaltasks = 4,
		optionaltasks = {
				"Forest hunters",
				"The hunters",
				"Magic meadow",
				"Hounded Greater Plains",
		},
		
		set_pieces = {
				["ResurrectionStone"] = { count=1, tasks={ "Speak to the king", "Forest hunters" } },
				["WormholeGrass"] = { count=8, tasks={"Tentacle-Blocked The Deep Forest", "Speak to the king", "Forest hunters", "Befriend the pigs", "The hunters", "Magic meadow", "Frogs and bugs"} },
		},
		
		override_triggers = {

			["DefaultPlusStart"] = {	
			
				{"ColourCube", "fungus_cc"}, 
				
				},
		},		
})

--This is the preset for testing purposes.
AddLevel(LEVELTYPE.ADVENTURE, {
		id="SKY_LEVEL_1",
		name="Sky",
		nomaxwell=true,
		hideminimap = true,
		desc="Up and Away.",
		min_playlist_position=CAMPAIGN_LENGTH+1,
		max_playlist_position=CAMPAIGN_LENGTH+1,		

		overrides={
			{"world_size", 		"huge"},
			{"day", 			"onlyday"}, 
			{"waves", 			"off"},
			{"branching",		"never"},
			{"looping",		    "always"},
			{"islands", 		"always"},				
			{"season_start", 	"summer"},
			{"season", 			"onlywinter"},
			{"weather", 		"never"},
			{"boons",			"always"},
			{"spiders", 		"never"},
			{"deerclops", 		"never"},
			{"hounds", 			"never"},	
			{"roads", 			"never"},	
			{"creepyeyes", 		"always"},
			{"rabbits",         "never"},
			{"trees",           "always"},
			{"rocks",           "always"},	
			{"carrots",         "never"},	
			{"beefalo",         "never"},	
			{"grass",           "never"},	
			{"world_complexity", ""},	
			{"pigs",            "never"},
			
			--This is custom content.
			{"skymushrooms",    "always"},
			{"beanstalks",      "always"},
			
			{"start_setpeice", 	"DefaultPlusStart"},				
		},
		
		tasks = {
				"Speak to the king",
				"Tentacle-Blocked The Deep Forest",
		},
		
		numoptionaltasks = 4,
		optionaltasks = {
				"Forest hunters",
				"The hunters",
				"Magic meadow",
				"Hounded Greater Plains",
		},
		
		set_pieces = {
				["ResurrectionStone"] = { count=1, tasks={ "Speak to the king", "Forest hunters" } },
				["WormholeGrass"] = { count=8, tasks={"Tentacle-Blocked The Deep Forest", "Speak to the king", "Forest hunters", "Befriend the pigs", "The hunters", "Magic meadow", "Frogs and bugs"} },
		},
		
		override_triggers = {

			["DefaultPlusStart"] = {	
			
				{"ColourCube", "fungus_cc"}, 
				
				},
		},		
})


--[[AddTask("BeanstalkStart", {
		locks=LOCKS.NONE,
		keys_given=KEYS.NONE,
		room_choices={
			["Beanstalk"] = 1,
		 }, 
		room_bg=GROUND.GRASS,
		background_room="BGGrass",
		colour={r=0,g=0,b=0,a=1}
	}
)

AddRoom("BeanstalkDown", {
	colour={r=.010,g=.010,b=.10,a=.50},
	value = GROUND.GRASS,
	contents =  {
		distributepercent = 0.4,
		distributeprefabs = {
			evergreen_sparse = 10,
		}
	}
})

local function MakePickTaskPreInit(task)
	task.room_choices["BeanstalkDown"] = 1
end

local function SurvivalLevelInit(level)
	table.insert(level.tasks, "BeanstalkStart")
end
--]]