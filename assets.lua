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
		"golden_egg",
	},

	InventoryImageTextures {
		"nil",
	},

	--[[
	-- These are atlases without a proper .tex yet.
	--
	-- When they get one, the entries should be moved to
	-- InventoryImageAssets.
	--]]
	InventoryImageAtlases {
		"kettle_item",
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

		--Minimap icons.

		Asset( "IMAGE", "images/winnie.tex" ),
		Asset( "ATLAS", "images/winnie.xml" ),	
		
		Asset( "IMAGE", "images/beanstalk.tex" ),
		Asset( "ATLAS", "images/beanstalk.xml" ),			

		Asset( "IMAGE", "images/beanstalk_exit.tex" ),
		Asset( "ATLAS", "images/beanstalk_exit.xml" ),	

		Asset( "IMAGE", "images/shopkeeper.tex" ),
		Asset( "ATLAS", "images/shopkeeper.xml" ),	

		Asset( "IMAGE", "images/cloud_algae.tex" ),
		Asset( "ATLAS", "images/cloud_algae.xml" ),	

		Asset( "IMAGE", "images/scarecrow.tex" ),
		Asset( "ATLAS", "images/scarecrow.xml" ),

		Asset( "IMAGE", "images/jellyshroom_red.tex" ),
		Asset( "ATLAS", "images/jellyshroom_red.xml" ),

		Asset( "IMAGE", "images/jellyshroom_blue.tex" ),
		Asset( "ATLAS", "images/jellyshroom_blue.xml" ),

		Asset( "IMAGE", "images/jellyshroom_green.tex" ),
		Asset( "ATLAS", "images/jellyshroom_green.xml" ),

		Asset( "IMAGE", "images/cauldron.tex" ),
		Asset( "ATLAS", "images/cauldron.xml" ),	

		Asset( "IMAGE", "images/cloudcrag.tex" ),
		Asset( "ATLAS", "images/cloudcrag.xml" ),	

		Asset( "IMAGE", "images/octocopter.tex" ),
		Asset( "ATLAS", "images/octocopter.xml" ),	

		Asset( "IMAGE", "images/dragonblood_tree.tex" ),
		Asset( "ATLAS", "images/dragonblood_tree.xml" ),	

		Asset( "IMAGE", "images/hive_marshmallow.tex" ),
		Asset( "ATLAS", "images/hive_marshmallow.xml" ),		

		Asset( "IMAGE", "images/cloud_bush.tex" ),
		Asset( "ATLAS", "images/cloud_bush.xml" ),	

		--Asset( "IMAGE", "images/cloud_fruit_tree.tex" ),
		--Asset( "ATLAS", "images/cloud_fruit_tree.xml" ),

		--Asset( "IMAGE", "images/bean_giant_statue.tex" ),
		--Asset( "ATLAS", "images/bean_giant_statue.xml" ),

		--Asset( "IMAGE", "images/weather_machine.tex" ),
		--Asset( "ATLAS", "images/weather_machine.xml" ),

		--Asset( "IMAGE", "images/refiner.tex" ),
		--Asset( "ATLAS", "images/refiner.xml" ),

		--Asset( "IMAGE", "images/kettle.tex" ),
		--Asset( "ATLAS", "images/kettle.xml" ),									
	},

	-- Dummy end, just so we can put commas after everything.
	{}
)

-- The return statement is just for using this file externally.
return Assets
