--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP


local CAMPAIGN_LENGTH = 5

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
		{"rock",           "never"},	
		{"carrot",         "never"},	
		{"berrybush", 		"never"},				
		{"beefalo",         "never"},	
		{"grass",           "never"},	
		{"pigs",            "never"},
		{"sapling",        "never"},
		
		{"world_complexity", "verycomplex"},	
					
		--This is custom content.
		{"skyflower",     "up_everywhere"},
		{"cloud_bush",    "up_moreplaces"},
		{"sheep",         "up_fewplaces"},
		
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
}



--This is the level that is generated.

local adventure_sky_level_1 = DeepCopy(sky_level_1)

TheMod:AddLevel(LEVELTYPE.ADVENTURE, adventure_sky_level_1)



--This is the preset for testing purposes.

local survival_sky_level_1 = DeepCopy(sky_level_1)

-- Removes the start set "peice".
table.TrimArray(survival_sky_level_1.overrides, function(v) return v[1] ~= "start_setpeice" end)

TheMod:AddLevel(LEVELTYPE.SURVIVAL, survival_sky_level_1)
