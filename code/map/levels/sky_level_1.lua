modrequire "lib.climbing"

-- This includes the standard 'table' library.
local table = wickerrequire "utils.table"

-- This is the level data.
local sky_level_1 = {
    id="SKY_LEVEL_1",
    name="Cloudrealm",
    nomaxwell=true,
    desc="A mysterious land; Up and Away. There is a chill in the air.",
	location = "cloudrealm",

    overrides={
        {"location",		"cave"}, -- This is for non-DST only.
        {"world_size", 		"small"}, 

        {"day", 			"onlydusk"}, 

        {"waves", 			"on"},
        {"branching",		"more"},
        {"looping",		    "default"},

        -- The only effect the following has is preventing snow on the
        -- ground.
        {"season_start", 	"summer"},		

        {"season", 			"onlywinter"},
        {"weather", 		"never"},

        {"boons",			"always"},

        {"roads", 			"never"},	

        {"islands", 		"few"},	

        {"deerclops", 		"never"},
        {"hounds", 			"never"},	
        {"rain",			"never"},

        -- This is stuff to prevent weather bugs.
        {"wildfires",       "never"},
        {"autumn",          "noseason"},
        {"spring",          "noseason"},
        {"summer",          "noseason"},
        
        {"start_setpeice", 	"BeanstalkTop"},				
        {"start_node",		"BeanstalkSpawn"},
    },
    
    tasks = {
        "Cloud_Innocent_Generic_Biome",
        "Cloud_Generic_Biome",
        "Cloud_Sunflower_Biome",
        "Cloud_Innocent_Aurora_Biome",
        "Cloud_Aurora_Biome",
        "Cloud_Innocent_Rainbow_Biome",
        "Cloud_Rainbow_Biome",
        "Cloud_Innocent_Snow_Biome",
        "Cloud_Snow_Biome",
        "Gnome_Snow_Biome",
    },
    
    set_pieces = {
        -- This is the octocopter.
        ["OctocopterWreckage"] = { count=1, tasks={"Cloud_Aurora_Biome"} },	
        ["Cloudhenge"] = { count=1, tasks={"Cloud_Generic_Biome"} },	
        ["WitchGrove"] = { count=1, tasks={"Cloud_Snow_Biome"} },

        -- This disperses owls.
        ["OwlColony"] = { count=1, tasks={"Cloud_Snow_Biome"} },	
        ["StrixShrine"] = { count=3, tasks={"Cloud_Aurora_Biome"} },	

        -- This is the scarecrow/cheshire.
        ["CheshireHunting"] = { count=5, tasks={"Cloud_Rainbow_Biome"} },

        -- These are the octocopter parts.
        ["OctocopterPart1"] = { count=1, tasks={"Cloud_Aurora_Biome"} },
        ["OctocopterPart2"] = { count=1, tasks={"Cloud_Rainbow_Biome"} },
        ["OctocopterPart3"] = { count=1, tasks={"Cloud_Snow_Biome"} },	
    },

    numrandom_set_pieces = 10,
    random_set_pieces = 
    {
        "CloudBase1",
        "HiveTrees1",
        "CloudHoles",
    },

    ordered_story_setpieces = {
        "CheshireHunting",
        "Cloudhenge",
        "StrixShrine",
        "WitchGrove",
        "OctocopterPart1",
        "OctocopterPart2",
        "OctocopterPart3",
        "OctocopterWreckage",				
    },

    required_prefabs = {
        "goose",
        "hive_marshmallow",
        "gnome_plot",
        "crystal_lamp",
        "beanlet",
        "cauldron",
        "scarecrow",
        "octocopter",
        "part1spawner",
        "part2spawner",
        "part3spawner",
        "bean_giant",
        "semiconductor",
    },
}
---------------------------------------------------------------

TheMod:AddCloudLevel(sky_level_1)

if IsDST() and TheMod:Debug() then
	local sky_level_1_debug = table.Tree.InjectInto({}, sky_level_1)
	
	sky_level_1_debug.location = "forest"
	sky_level_1_debug.id = sky_level_1_debug.id.."_DEBUG"
	sky_level_1_debug.name = sky_level_1_debug.name.." (DEBUG)"

	TheMod:AddCloudLevel(sky_level_1_debug)
end

local survival_sky_level_1 = {
    id="SKY_LEVEL_SURVIVAL_1",
    name="Cloudrealm",
    nomaxwell=true,
    desc="Jump right into the mod. Experimental. World generation may take a long time.",
    location = "cloudrealm",
    overrides = {
            {"location",        "cloudrealm"},
            {"world_size",      "large"}, 

            {"day",             "onlydusk"}, 

            {"waves",           "on"},
            {"branching",       "more"},
            {"looping",         "default"},

            {"season_start",    "summer"},      

            {"season",          "onlywinter"},
            {"weather",         "never"},

            {"roads",           "never"},   

            {"islands",         "few"}, 

            {"deerclops",       "never"},
            {"hounds",          "never"},   
            {"rain",            "never"},

            {"wildfires",       "never"},
            {"autumn",          "noseason"},
            {"spring",          "noseason"},
            {"summer",          "noseason"},
            
            {"start_setpeice",  "BeanstalkTopSurvival"},                
            {"start_node",      "BeanstalkSpawn"},
        },

        tasks = {
            "Cloud_Innocent_Generic_Biome",
            "Cloud_Generic_Biome",
            "Cloud_Sunflower_Biome",
            "Cloud_Innocent_Aurora_Biome",
            "Cloud_Aurora_Biome",
            "Cloud_Innocent_Rainbow_Biome",
            "Cloud_Rainbow_Biome",
            "Cloud_Innocent_Snow_Biome",
            "Cloud_Snow_Biome",
            "Gnome_Snow_Biome",
        },
        
        set_pieces = {
            -- This is the octocopter.
            ["OctocopterWreckage"] = { count=1, tasks={"Cloud_Aurora_Biome"} }, 
            ["Cloudhenge"] = { count=1, tasks={"Cloud_Generic_Biome"} },    
            ["WitchGrove"] = { count=1, tasks={"Cloud_Snow_Biome"} },

            -- This disperses owls.
            ["OwlColony"] = { count=1, tasks={"Cloud_Snow_Biome"} },    
            ["StrixShrine"] = { count=3, tasks={"Cloud_Aurora_Biome"} },    

            -- This is the scarecrow/cheshire.
            ["CheshireHunting"] = { count=5, tasks={"Cloud_Rainbow_Biome"} },

            -- These are the octocopter parts.
            ["OctocopterPart1"] = { count=1, tasks={"Cloud_Aurora_Biome"} },
            ["OctocopterPart2"] = { count=1, tasks={"Cloud_Rainbow_Biome"} },
            ["OctocopterPart3"] = { count=1, tasks={"Cloud_Snow_Biome"} },  
        },

        numrandom_set_pieces = 10,
        random_set_pieces = 
        {
            "CloudBase1",
            "HiveTrees1",
            "CloudHoles",
        },

        ordered_story_setpieces = {
            "CheshireHunting",
            "Cloudhenge",
            "StrixShrine",
            "WitchGrove",
            "OctocopterPart1",
            "OctocopterPart2",
            "OctocopterPart3",
            "OctocopterWreckage",               
        },

        required_prefabs = {
            "goose",
            "hive_marshmallow",
            "gnome_plot",
            "crystal_lamp",
            "beanlet",
            "cauldron",
            "scarecrow",
            "octocopter",
            "part1spawner",
            "part2spawner",
            "part3spawner",
            "bean_giant",
            "semiconductor",
        },        
    }
table.TrimArray(survival_sky_level_1.overrides, function(v) return v[1] ~= "start_setpeice" end)
TheMod:AddLevel(LEVELTYPE.SURVIVAL, survival_sky_level_1)
