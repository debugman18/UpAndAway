--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


modrequire 'lib.climbing'


local LEVELTYPE = GLOBAL.LEVELTYPE


-- This embeds all entries in the standard table, so nothing is lost.
local table = wickerrequire 'utils.table'


-- Copies a table t into a table u.
local function DeepInject(t, u)
	for k, v in pairs(t) do
		if type(v) == "table" then
			if type(u[k]) ~= "table" then
				u[k] = {}
			end
			DeepInject(v, u[k])
		else
			u[k] = v
		end
	end
	return u
end

local function DeepCopy(t)
	return DeepInject(t, {})
end


-- This is the level template
local sky_level_1 = {
	id="SKY_LEVEL_1",
	name="Sky",
	nomaxwell=true,
	--hideminimap = true,
	desc="Up and Away.",

	overrides={
		{"location",		"cave"},

		{"world_size", 		"huge"},
		--{"world_size", 		"tiny"},
		{"day", 			"onlydusk"}, 
		{"waves", 			"on"},
		{"branching",		"never"},
		{"looping",		    "always"},

		-- The only effect the following has is preventing snow on the
		-- ground.
		{"season_start", 	"summer"},

		{"season", 			"onlywinter"},
		{"weather", 		"never"},
		{"boons",			"never"},
		{"roads", 			"never"},	
		{"islands", 		"never"},				
		{"deerclops", 		"never"},
		{"hounds", 			"never"},	
		{"rain",			"never"},

		--[[
		{"spiders", 		"never"},
		{"rabbits",         "never"},
		{"trees",           "never"},
		{"rock",           "never"},	
		{"carrot",         "never"},	
		{"berrybush", 		"never"},				
		{"beefalo",         "never"},	
		{"grass",           "never"},	
		{"pigs",            "never"},
		{"sapling",        "never"},
		{"world_complexity", "verycomplex"},	
		]]--
					
		--This is custom content.
		{"skyflower",     "up_everywhere"},
		{"cloud_bush",    "up_moreplaces"},
		{"sheep",         "up_fewplaces"},
		
		{"start_setpeice", 	"BeanstalkTop"},				
		{"start_node",		"BeanstalkSpawn"},
	},
	
	tasks = {
		"Cloud_Generic_Biome",
		"Cloud_Aurora_Biome",
	},
	
	numoptionaltasks = 0,
	optionaltasks = {
	},
	
	set_pieces = {
		["TestBeanstalk"] = { count=10, tasks={"Cloud_Aurora_Biome"} },	
	},

	ordered_story_setpieces = {
		--"TeleportatoRingLayout",
		--"TeleportatoBoxLayout",
		--"TeleportatoCrankLayout",
		--"TeleportatoPotatoLayout",
		--"AdventurePortalLayout",
		--"TeleportatoBaseLayout",
	},

	required_prefabs = {
		"crystal_relic",  
		"goose",
	},

}



--[[
--This is the level that is generated.

local adventure_sky_level_1 = DeepCopy(sky_level_1)

TheMod:AddLevel(LEVELTYPE.ADVENTURE, adventure_sky_level_1)
]]--


local cave_sky_level_1 = DeepCopy(sky_level_1)
TheMod:AddCloudLevel(cave_sky_level_1)

--[[
--I'm not sure we will want/need this in the future. With ClimbTo(), this is obsolete.

--This is the preset for testing purposes.

local survival_sky_level_1 = DeepCopy(sky_level_1)

-- Removes the start set "peice".
table.TrimArray(survival_sky_level_1.overrides, function(v) return v[1] ~= "start_setpeice" end)

TheMod:AddLevel(LEVELTYPE.SURVIVAL, survival_sky_level_1)
--]]
