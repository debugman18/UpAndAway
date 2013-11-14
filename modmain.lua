TheMod = GLOBAL.require("upandaway" .. '.wicker.init')(env)

local CFG = TUNING.UPANDAWAY


local new_tiles = CFG.NEW_TILES


--These assets are for everything.
local RawAssets = {
	--Asset("SOUNDPACKAGE", "sound/music_mod.fev"),
	--Asset("SOUND", "sound/music_mod.fsb"),

	Asset( "ANIM", "anim/generating_cloud.zip" ),

	Asset( "ATLAS", "images/inventoryimages/skyflower_petals.xml" ),
	Asset( "IMAGE", "images/inventoryimages/skyflower_petals.tex" ),

	Asset( "ATLAS", "images/inventoryimages/datura_petals.xml" ),
	Asset( "IMAGE", "images/inventoryimages/datura_petals.tex" ),
	
	--Asset( "ATLAS", "images/inventoryimages/crystal_shard.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/crystal_shard.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/crystal_moss.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/crystal_moss.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/crystal_wall.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/crystal_wall.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/crystal_cap.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/crystal_cap.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/sunflower_seeds.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/sunflower_seeds.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/moonflower_seeds.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/moonflower_seeds.tex" ),
	
	--Asset( "ATLAS", "images/inventoryimages/beanstalk_wall.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/beanstalk_wall.tex" ),

	Asset( "ATLAS", "images/inventoryimages/beanstalk_chunk.xml" ),
	Asset( "IMAGE", "images/inventoryimages/beanstalk_chunk.tex" ),

	Asset( "ATLAS", "images/inventoryimages/magic_beans.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/magic_beans_cooked.xml" ),
	Asset( "IMAGE", "images/inventoryimages/magic_beans_cooked.tex" ),	

	Asset( "ATLAS", "images/inventoryimages/cloud_cotton.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cloud_cotton.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/candy_fruit.xml" ),
	Asset( "IMAGE", "images/inventoryimages/candy_fruit.tex" ),	

	Asset( "ATLAS", "images/inventoryimages/golden_egg.xml" ),
	Asset( "IMAGE", "images/inventoryimages/golden_egg.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/pineapple_fruit.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/pineapple_fruit.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/cushion_fruit.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/cushion_fruit.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/wind_axe.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/wind_axe.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/golden_amulet.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/golden_amulet.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/kite.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/kite.tex" ),
	
	Asset("SOUNDPACKAGE", "sound/project.fev"),
	Asset("SOUND", "sound/project_bank00.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/sheep.fev"),
	Asset("SOUND", "sound/sheep_bank01.fsb"),	

	--Asset("ATLAS", "modicon.xml"),
	--Asset("IMAGE", "modicon.tex"),
	
	Asset("ATLAS", "images/uppanels.xml"),		
	Asset("IMAGE", "images/uppanels.tex"),	

	Asset("ATLAS", "images/bg_up.xml"),		
	Asset("IMAGE", "images/bg_up.tex"),	

	Asset("ATLAS", "images/bg_gen.xml"),		
	Asset("IMAGE", "images/bg_gen.tex"),	

	--Winnie assets.
    Asset( "IMAGE", "images/saveslot_portraits/winnie.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/winnie.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/winnie.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/winnie.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/winnie_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/winnie_silho.xml" ),

    Asset( "IMAGE", "bigportraits/winnie.tex" ),
    Asset( "ATLAS", "bigportraits/winnie.xml" ),		
}

GLOBAL.require "screens/popupdialog"
GLOBAL.require "screens/newgamescreen"
GLOBAL.require "widgets/statusdisplays"

Assets = RawAssets

--This loads all of the new prefabs.

local RawPrefabFiles = {
	"winnie",
	"winnie_staff",

	"cloudrealm",
	"cloud_mist",
	"cloud_lightning",
	
	"shopkeeper",
	"sheep",	

	"vine",

	"bee_marshmallow",
	"hive_marshmallow",
	
	"candy_fruit",
	"marshmallow",
	
	"skyflies",
	"flying_fish",
	
	"goose",	
	"longbill",
	
	"crystal_spire",
	"crystal_fragment",
	
	"skyflower",
	"skyflower_petals",

	"beanstalk",
	"beanstalk_exit",

	"thunder_tree",
	
	"balloon_hound",
	"beanlet_shell",
	"cheshire",
	"chimera",
	"cloud_algae",
	"cloud_algae_fragment",
	"cloud_coral",
	"cloud_coral_fragment",
	"flying_fish_pond",
	"alien",
	"greenbean",
	"jellyshroom",
	"manta",
	"manta_leather",
	"quartz_torch",
	"refiner",
	"scarecrow",
	
	"beanstalk_chunk",	
	"magic_beans",
	
	--"bean_sprout",	
	
	"cloud_cotton",	
	
	--"cloud_bomb",	
	
	"cloud_turf",	
	"cloud_bush",
	"cloudcrag",

	--"pineapple_bush",
	--"pineapple_fruit",
	
	"golden_egg",
	
	--"golden_amulet",

	--"wind_axe",
	--"kite",

	"duckraptor",

	--"duckraptor_mother",	
	--"duckraptor_baby",
	
	"antlion",	
	
	"lionblob",

	"owl",
	"crystal_relic",
	"crystal_relic_fragment",

	"cotton_vest",

	"research_lectern",	

	--"bean_giant",	
	--"beanstalk_wall",	
	--"cloud_wall",

	"smores",
	"weather_machine",	
	"skytrap",	

	--"crystal_moss",
	--"crystal_wall",	
	--"crystal_crown",

	"crystal_lamp",		
	"cotton_candy",	
	"rainbowcoon",	
	"ball_lightning",
	"magnet",
	"grabber",
	"cotton_candy",
	"smores",
	"rubber",
	"crystal_black_fragment",
	"crystal_white_fragment",
	"crystal_water_fragment",
	"crystal_quartz_fragment",
	"golden_sunflower",
	"golden_sunflower_seeds",
	"gustflower",
	"gustflower_seeds",		

	"beanlet_zealot",	
	"octocopter",	
	"live_gnome",
	"crystal_black",
	"crystal_white",	
	"beanlet",	
	"golden_golem",	
	"monolith",		
	"crystal_water",
	"crystal_quartz",	
	"sky_lemur",		
	"cotton_hat",	

	"whirlwind",
	"bean_giant_statue",
	"cumulostone",
	"dragonblood_tree",
	"dragonblood_sap",
	"crystal_light",
	"bird_paradise",
	"cauldron",
	"cloud_bomb",
	"cloud_fruit_tree",
	"cloud_fruit",
	"cloud_wall",
	"crystal_wall",
	"beanstalk_wall",
	"crystal_armor",
	"crystal_axe",
	"golden_amulet",
	"kite",
	"golden_rose",
	"golden_petals",

}

--RemapSoundEvent("dontstarve/music/music_FE", "upandaway/music/music_FE")

local new_tiles = CFG.NEW_TILES

--Removing this for the moment to test new turfs.

--[[
if CFG.DEBUG then
	table.insert(RawPrefabFiles, "turf_test")

	AddSimPostInit(function(inst)
		local inv = inst.components.inventory
		
		for _, v in ipairs(new_tiles) do
			if inv and not inv:Has("turf_" .. v, 1) then
				inv:GiveItem( GLOBAL.SpawnPrefab("turf_" .. v) )
			end
		end
	end)
end
--]]

PrefabFiles = RawPrefabFiles

TheMod:Run("main")
