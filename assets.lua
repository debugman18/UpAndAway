use "asset_utils"

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
		--"player_drink.zip",
	},

	--[=[
	InventoryImageAssets {
		"skyflower_petals",
		"datura_petals",
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
		"greentea",
		"blacktea",
		"tea_leaves",
		"blacktea_leaves",
		"golden_egg",
		"cotton_vest",
		"mushroom_hat",
		"kettle_item",
		"nil",

		"smores",
		"cloud_jelly",
		"manta_leather",
		"refined_black_crystal",
		"refined_white_crystal",
		"wind_axe",
		"beanstalk_wall_item",
		"beanstalk_chunk",
		"golden_sunflower_seeds",
		"greenbean",
		"dragonblood_sap",
		"ambrosia",

		"blackstaff",
		"whitestaff",
		"cloud_fruit",
		"cloud_fruit_cooked",
		"cumulostone",
		"dragonblood_log",
		"winnie_staff",
		"marshmallow",
		"gustflower_seeds",
		"bee_marshmallow",
		"thunder_log",
		"thunderboards",
		"beanlet_shell",

		"octocopterpart1",
		"octocopterpart2",
		"octocopterpart3",
		"golden_petals",
		"cotton_candy",
		"cloud_algae_fragment",
		"cloud_coral_fragment",
		"crystal_lamp",

		"crystal_wall_item",

		"refiner",

		"magnet",
		"grabber",
		"research_lectern",
		"cotton_hat",
		"weather_machine",

		"skyflies",

		"skyflies_pink",
		"skyflies_green",
		"skyflies_blue",
		"skyflies_red",
		"skyflies_orange",
		"skyflies_purple",

		"rubber",
		"weaver_bird",
		"dug_tea_bush",

		"cotton_hat",

		"greenbean_cooked",
		"beanlet_armor",

		"pineapple",
		"pineapple_rotten",
		"pineapple_seeds",

		"thunder_pinecone",

		--Tea images.
	    "whitetea",
	    "petaltea",
	    "mixedpetaltea",
	    "evilpetaltea",
	    "floraltea",
	    "skypetaltea",
	    "daturatea",
	    "cloudfruittea",
	    "greenertea",
	    "berrytea",
	    "berrypulptea",
	    "cottontea",
	    "goldtea",
	    "candytea",

	    "oolongtea",
	    "chaitea",
	    "spoiledtea",
	    "jellytea",
	    "redjellytea",
	    "bluejellytea",
	    "greenjellytea",
	    "redmushroomtea",
	    "bluemushroomtea",
	    "greenmushroomtea",
	    "dragontea",
	    "herbaltea",
	    "marshmallowtea",
	    "ambrosiatea",
	    "algaetea",

	    "redjelly",
	    "greenjelly",
	    "crystalcandy",
	},

	-- These are .tex's without a matching atlas.
	InventoryImageTextures {
		--"nil",
	},

	--[[
	-- These are atlases without a proper .tex yet.
	--
	-- When they get one, the entries should be moved to
	-- InventoryImageAssets.
	--]]
	InventoryImageAtlases {
		--"nil",
	},
	]=]--

	{
		Asset("SOUNDPACKAGE", "sound/project.fev"),
		Asset("SOUND", "sound/project_bank00.fsb"),
		
		Asset("SOUNDPACKAGE", "sound/sheep.fev"),
		Asset("SOUND", "sound/sheep_bank01.fsb"),	
	},

	ImageAssets {
		"ua_inventoryimages",
		"ua_minimap",

		"uppanels",
		"bg_up",
		"bg_gen",
		"up_new",

		--[=[
		--Minimap icons.
		"winnie",
		"beanstalk",
		"beanstalk_exit",
		"shopkeeper",
		"cloud_coral",
		"scarecrow",
		"jellyshroom_red",
		"jellyshroom_blue",
		"jellyshroom_green",
		"cauldron",
		"cloudcrag",
		"octocopter",
		"dragonblood_tree",
		"hive_marshmallow",
		"cloud_bush",
		"thunder_tree",
		"tea_bush",
		"crystal_lamp",
		"cloud_fruit_tree",
		"kettle",
		"gummybear_den",
		"cloud_algae",
		
		"weather_machine",
		"beanlet_hut",
		"refiner",
		"research_lectern",
		"weavernest",

		--"bean_giant_statue",
		]=]--
	},

	--Winnie assets.
	ImageAssets "saveslot_portraits" {
		"winnie",
	},

	ImageAssets "avatars" {
		"avatar_winnie",
		"avatar_ghost_winnie",
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

-- The return statement is just for using this file externally.
return Assets
