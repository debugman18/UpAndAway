GetPlayer = GLOBAL.GetPlayer
SaveIndex = GLOBAL.SaveIndex
modimport 'configloader.lua'
LoadConfigurationFile 'rc.lua'

local CFG = TUNING.UPANDAWAY

GLOBAL.require 'upandaway.strings'


local new_tiles = CFG.NEW_TILES


--These assets are for all of the added inventory items.
local RawAssets = {

	--Asset( "ATLAS", "images/inventoryimages/skyflower_petals.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/skyflower_petals.tex" ),

	--Asset( "ATLAS", "images/inventoryimages/datura_petals.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/datura_petals.tex" ),
	
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

	--Asset( "ATLAS", "images/inventoryimages/cloud_fluff.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/cloud_fluff.tex" ),

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

for _, v in ipairs(new_tiles) do
	table.insert(RawAssets, Asset( "IMAGE", "levels/textures/noise_" .. v .. ".tex" ))
	table.insert(RawAssets, Asset( "IMAGE", "levels/textures/mini_noise_" .. v .. ".tex" ))
	table.insert(RawAssets, Asset( "FILE", "levels/tiles/" .. v .. ".xml" ))
	table.insert(RawAssets, Asset( "IMAGE", "levels/tiles/" .. v .. ".tex" ))
end

Assets = RawAssets


--This loads all of the new prefabs.

local RawPrefabFiles = {
	"shopkeeper",
	"sheep",	
	
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
	--"cloud_fluff",	
	--"cloud_bomb",	
	--"cloud_storage",	
	
	"cloud_turf",	
	
	--"cushion_plant",
	--"cushion_fruit",	
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

	"turf_test",
}


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


local function evergreens_ret(inst)
	inst:AddTag"evergreen_ret"
	
	if GetPlayer().goneUp == true then
		print "Testing goneUp."
	end	
	
end

local function onUp(inst)

		SetHUDPause(true)
		--Define the new world objects we are placing.
		local beanstalk = SpawnPrefab("beanstalk")

		--Define the old world objects we are replacing.
		local evergreens_ret = TheSim:FindFirstEntityWithTag("evergreen_ret")
		
		--Make sure that the player climbed the beanstalk.
		if GetPlayer().goneUp == true and GetPlayer().goneUpRemember == false then
			
			--Place the new world objects.			
			beanstalk.Transform:SetPosition(evergreens_ret.Transform:GetWorldPosition())
			
			--Remove the old world objects.
			evergreens_ret:Remove()
		end	
		
		SetHUDPause(false)
		GetPlayer().goneUpRemember = true
end

AddPrefabPostInit('evergreen', evergreens_ret)	 

--Changes the title displayed on the main menu.
local function UpdateMainScreen(self)
	self.updatename:SetString("Up and Away")
end
AddGlobalClassPostConstruct("screens/mainscreen", "MainScreen", UpdateMainScreen)

--Changes "activate" to "talk to" for "shopkeeper".
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.ACTIVATE and bufaction.target and bufaction.target.prefab == "shopkeeper" then
			return "Talk to"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)



--Changes "activate" to "climb down" for "beanstalk_exit".
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.ACTIVATE and bufaction.target and bufaction.target.prefab == "beanstalk_exit" then
			return "Climb Down"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)
