TheMod = GLOBAL.require("upandaway" .. '.wicker.init')(env)
modimport "asset_utils.lua"


--These assets are for everything.
Assets = GLOBAL.JoinArrays(
	--[[
	{
		Asset("SOUNDPACKAGE", "sound/music_mod.fev"),
		Asset("SOUND", "sound/music_mod.fsb"),
	},
	]]--
	
	AnimationAssets {
		"generating_cloud",
		"temperature_meter",
	},

	InventoryImageAssets {
		"skyflower_petals",
		"datura_petals",
		--"crystal_shard",
		--"crystal_moss",
		--"crystal_wall",
		--"crystal_cap",
		--"sunflower_seeds",
		--"moonflower_seeds",
		--"beanstalk_wall",
		"beanstalk_chunk",
		"magic_beans",
		"magic_beans_cooked",
		"cloud_cotton",
		"candy_fruit",
		"crystal_fragment_light",
		"crystal_fragment_water",
		"crystal_fragment_relic",
		"crystal_fragment_quartz",
		"crystal_fragment_black",
		"crystal_fragment_white",
		"crystal_fragment_spire",
		--"pineapple_fruit",
		--"cushion_fruit",
		--"wind_axe",
		--"golden_amulet",
		--"kite",
		"greentea",
		"blacktea",
		"tea_leaves",
		"blacktea_leaves",
	},
	
	{
		Asset("SOUNDPACKAGE", "sound/project.fev"),
		Asset("SOUND", "sound/project_bank00.fsb"),
		
		Asset("SOUNDPACKAGE", "sound/sheep.fev"),
		Asset("SOUND", "sound/sheep_bank01.fsb"),	
	},

	ImageAssets {
		"uppanels",
		"bg_up",
		"bg_gen",
		"up_new",
	},

	--Winnie assets.
	ImageAssets "saveslot_portraits" {
		"winnie",
	},

	ImageAssets "selectscreen_portraits" {
		"winnie",
		"winnie_silho",
	},

	{
		Asset( "IMAGE", "bigportraits/winnie.tex" ),
		Asset( "ATLAS", "bigportraits/winnie.xml" ),		
	},

	-- Dummy end, just so we can put commas after everything.
	{}
)

GLOBAL.require "screens/popupdialog"
GLOBAL.require "screens/newgamescreen"
GLOBAL.require "widgets/statusdisplays"

--This loads all of the new prefabs.

PrefabFiles = {
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
	"crystal_fragment_relic",

	"crystal_fragment_spire",

	"cotton_vest",

	"research_lectern",	

	"bean_giant",	
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

	"crystal_fragment_black",
	"crystal_fragment_white",
	"crystal_fragment_water",
	"crystal_fragment_quartz",

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
	"crystal_fragment_light",
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

	"colored_corn",

	"tea",
	"tea_leaves",
	"tea_bush",
	"kettle",
}

--RemapSoundEvent("dontstarve/music/music_FE", "upandaway/music/music_FE")


--Removing this for the moment to test new turfs.

--[[
if TheMod:Debug() then
	local new_tiles = TheMod:GetConfig("NEW_TILES")

	table.insert(PrefabFiles, "turf_test")

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


TheMod:Run("main")
