TheMod = GLOBAL.require("upandaway" .. '.wicker.init')(env)

local CFG = TUNING.UPANDAWAY


local new_tiles = CFG.NEW_TILES


--These assets are for all of the added inventory items.
local RawAssets = {

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

	--Asset( "ATLAS", "images/inventoryimages/cloud_cotton.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/cloud_cotton.tex" ),

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
}

Assets = RawAssets


--This loads all of the new prefabs.

local RawPrefabFiles = {
	"cloudrealm",
	"cloud_mist",
	
	"shopkeeper",
	"sheep",	
	"eel",
	
	--"crystal_deposit",
	--"crystal_shard",
	--"crystal_moss",
	--"crystal_wall",	
	--"crystal_cap",
	--"crystal_lamp",	
	--"sunflower",
	--"sunflower_seeds",
	--"moonflower",
	--"moonflower_seeds",	
	
	"skyflower",
	"skyflower_petals",
	"beanstalk",
	"beanstalk_exit",
	
	--"beanstalk_wall",	
	
	"beanstalk_chunk",	
	"magic_beans",
	
	--"magic_bean_sprout",	
	
	--"magic_bean_giant",
	--"magic_beanlet",
	
	--"cloud_rock",
	
	"cloud_cotton",	
	
	--"cloud_bomb",	
	--"cloud_storage",	
	
	"cloud_turf",	
	"cloud_bush",
	
	--"cloud_berries",

	--"pineapple_bush",
	--"pineapple_fruit",
	
	"golden_egg",
	
	--"golden_amulet",
	--"golden_golem",
	--"monolith",
	--"research_lectern",
	--"wind_axe",
	--"kite",
	--"duckraptor",
	--"duckraptor_mother",	
	--"duckraptor_baby",		
	--"lionant",	
	
	--"rainbowcoon",
	--"cotton_candy",
	--"cotton_vest",
}


local new_tiles = CFG.NEW_TILES

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


PrefabFiles = RawPrefabFiles



TheMod:Run("main")
