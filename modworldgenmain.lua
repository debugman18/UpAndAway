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

modimport 'configloader.lua'
LoadConfigurationFile 'rc.lua'


GLOBAL.require("constants")
local GROUND = GLOBAL.GROUND

GLOBAL.require("map/levels")
GLOBAL.require("map/tasks")
GLOBAL.require("map/rooms")
local LEVELTYPE = GLOBAL.LEVELTYPE
local AddLevel = GLOBAL.AddLevel
local AddTask = GLOBAL.AddTask
local AddRoom = GLOBAL.AddRoom
local CAMPAIGN_LENGTH = 5

--This also does the following.
local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
TRANSLATE_TO_PREFABS["purpleskyflower"] = {"purple_skyflower"}
TRANSLATE_TO_PREFABS["yellowskyflower"] = {"yellow_skyflower"}
TRANSLATE_TO_PREFABS["orangeskyflower"] = {"orange_skyflower"}

local MULTIPLY = GLOBAL.require("map/forest_map").MULTIPLY
MULTIPLY["everywhere"] = 100

local Forest = GLOBAL.require("map/forest_map")

--Controls setpeices.
local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
Layouts["BeanstalkTop"] = StaticLayout.Get("map/static_layouts/beanstalk_top")

--This is the preset for testing purposes.
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
			{"roads", 			"never"},	
			
			{"boons",			"always"},
			{"spiders", 		"never"},
			{"deerclops", 		"never"},
			{"hounds", 			"never"},	
			{"rabbits",         "never"},
			{"trees",           "never"},
			{"rocks",           "never"},	
			{"carrots",         "never"},	
			{"beefalo",         "never"},	
			{"grass",           "never"},	
			{"pigs",            "never"},
			
			{"world_complexity", "verycomplex"},	
						
			--This is custom content.
			{"purpleskyflower",    "everywhere"},
			{"orangeskyflower",    "everywhere"},
			{"yellowskyflower",    "everywhere"},
			
			{"start_setpeice", 	"BeanstalkTop"},				
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
		},
		
		override_triggers = {

			["BeanstalkTop"] = {	
			
				{"ColourCube", "fungus_cc"}, 
				
				},
		},		
})

--This is the level that is generated.
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
			{"roads", 			"never"},	
			
			{"boons",			"always"},
			{"spiders", 		"never"},
			{"deerclops", 		"never"},
			{"hounds", 			"never"},	
			{"rabbits",         "never"},
			{"trees",           "never"},
			{"rocks",           "never"},	
			{"carrots",         "never"},	
			{"beefalo",         "never"},	
			{"grass",           "never"},	
			{"pigs",            "never"},
			
			{"world_complexity", "verycomplex"},	
						
			--This is custom content.
			{"purpleskyflower",    "everywhere"},
			{"orangeskyflower",    "everywhere"},
			{"yellowskyflower",    "everywhere"},
			
			{"start_setpeice", 	"BeanstalkTop"},				
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
		},
		
		override_triggers = {

			["BeanstalkTop"] = {	
			
				{"ColourCube", "fungus_cc"}, 
				
				},
		},		
})

AddRoom("BeanstalkSpawn", {
	colour={r=.010,g=.010,b=.10,a=.50},
	value = GROUND.MARSH,
	contents =  {
		distributepercent = 1,
		distributeprefabs = {
			skeleton = 1,
		}
	}
})

AddTask("BeanstalkSpawn", {
	room_choices={
		["BeefalowPlain"] = 5,
	},
	room_bg=GROUND.MARSH,
	background_room="BGMarsh",
	colour={r=0.0,g=0,b=0.0,a=0.5},
})

local function SurvivalLevelInit(level)
	table.insert(level.tasks, "BeanstalkSpawn")
end

--[[
AddTask("BeanstalkStart", {
		locks=LOCKS.NONE,
		keys_given=KEYS.NONE,
		room_choices={
			["BeanstalkDown"] = 1,
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
