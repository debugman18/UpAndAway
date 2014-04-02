---
-- Main file. Run through modmain.lua
--
-- @author debugman18
-- @author simplex


BindModModule 'modenv'
-- This just enables syntax conveniences.
BindTheMod()


local Pred = wickerrequire 'lib.predicates'

require 'mainfunctions'

modrequire('api_abstractions')()

modrequire 'profiling'
modrequire 'debugtools'
modrequire 'strings'
modrequire 'patches'
modrequire 'postinits'
modrequire 'actions'

modrequire 'asset_compiler'

modrequire 'lib.save_safeguard'

do
	local oldSpawnPrefab = _G.SpawnPrefab
	function _G.SpawnPrefab(name)
		if name == "cave" and Pred.IsCloudLevel() then
				name = "cloudrealm"
		end
		return oldSpawnPrefab(name)
	end
end

AddSimPostInit(function(inst)
	local alphawarning = inst.HUD and inst.HUD.controls and inst.HUD.controls.alphawarning
	if alphawarning then
		alphawarning:SetString("Up and Away is a work in progress!")
	end
end)

AddGamePostInit(function()
	local ground = GetWorld()
	if ground and Pred.IsCloudLevel() then
		for _, node in ipairs(ground.topology.nodes) do
			local mist = SpawnPrefab("cloud_mist")
			mist:AddToNode(node)
			if mist:IsValid() and mist.components.emitter then
				mist.components.emitter:Emit()
			end
		end
	end
end)

local function winter_perk(inst)
	if GetPlayer().prefab == "winnie" then
		TUNING.MIN_CROP_GROW_TEMP = -100
	end	
end	

--[[
-- This is just to prevent changes in out implementation breaking old saves.
--]]
AddPrefabPostInit("world", function(inst)
	local Climbing = modrequire 'lib.climbing'

	local metadata_key = "upandaway_metadata"
	if not inst.components[metadata_key] then
		inst:AddComponent(metadata_key)
	end
	
	if inst.components[metadata_key]:Get("height") == nil then
		inst.components[metadata_key]:Set("height", Climbing.GetLevelHeight())
	end
end)

local function UpMenu()
	local UpMenuScreen = require "screens/upmenuscreen"
	GLOBAL.TheFrontEnd:PushScreen(UpMenuScreen())
end	

--Changes the main menu.
local function DoInit(self)
	--do
		--return
	--end

	local Image = require "widgets/image"
	local ImageButton = require "widgets/imagebutton"
	local Text = require "widgets/text"	



	--[[
	--This displays the current version to the user.	
	self.motd.motdtext:SetPosition(0, 10, 0)
	self.motd.motdtitle:SetString("Version Information")
	self.motd.motdtext:EnableWordWrap(true)   
	self.motd.motdtext:SetString("You are currently using version '" .. modinfo.version .. "' of Up and Away. Thank you for testing!")
	
	--This adds a button to the MOTD.
	self.motd.button = self.motd:AddChild(ImageButton())
    self.motd.button:SetPosition(0, -80, 0)
    self.motd.button:SetText("More Info")
    self.motd.button:SetOnClick( function() VisitURL("http://forums.kleientertainment.com/index.php?" .. TheMod.modinfo.forumthread) end )    
	self.motd.button:SetScale(.8)
	self.motd.motdtext:EnableWordWrap(true)
	
	--Adds a mod credits button.
	self.modcredits_button = self.motd:AddChild(ImageButton())
    self.modcredits_button:SetPosition(0, -150, 0)
    self.modcredits_button:SetText("Credits")
    self.modcredits_button:SetOnClick( function() Credits() end )	
    self.modcredits_button:SetScale(.8)
    ]]
	
	--We can change the background image here.
	self.bg:SetTexture("images/up_new.xml", "ps4_mainmenu.tex")
	self.bg:SetTint(100, 100, 100, 1)
    self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)	
	self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)
	
	--We can change the shield image here.
    self.shield:SetTexture("images/uppanels.xml", "panel_shield.tex")
    self.shield:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.shield:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)


	--This renames the banner.
	self.updatename:SetString("Up and Away")
	self.banner:SetPosition(0, -170, 0)	
	self.banner:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.banner:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.banner:SetTint(0,0,0,0)

	--Adds our own mod button.
	self.upandaway_button = self.updatename:AddChild(ImageButton("images/ui.xml", "update_banner.tex"))
	self.upandaway_button:SetPosition(0, -8, 0)	
	self.upandaway_button:SetOnClick( function() UpMenu() end )	

    self.up_name = self.upandaway_button:AddChild(Text(GLOBAL.BUTTONFONT, 30))
    self.up_name:SetPosition(0,8,0)	
    self.up_name:SetString("Up and Away")	
	self.up_name:SetColour(0,0,0,1)
	--]]
		
	--[[
	
	--We can change the pig to something else.
	self.daysuntilanim:GetAnimState():SetBuild("main_up")
	self.daysuntilanim:SetPosition(20,-170,0)
	
	self.UpdateDaysUntil = function(self)	
		local choices = {
			["idle"] = 10,  
			["scratch"] = 1,  
			["hungry"] =  1,  
			["eat"] = 1, 
		}	
		self.daysuntilanim:GetAnimState():PlayAnimation(GLOBAL.weighted_random_choice(choices), true)
	end

	self.daysuntilanim.inst:ListenForEvent("animover", function(inst, data) self:UpdateDaysUntil() end)

	-]]	
	
	--self:UpdateDaysUntil()
	
	--We can change wilson to somebody else.
    --self.wilson = self.left_col:AddChild(UIAnim())
    --self.wilson:GetAnimState():SetBank("corner_dude")
    --self.wilson:GetAnimState():SetBuild("corner_up")
    --self.wilson:GetAnimState():PlayAnimation("idle", true)
    --self.wilson:SetPosition(0,-370,0)	

	self:MainMenu()
	self.menu:SetFocus()
end

-- This works under both game versions (due to api_abstractions.lua)
-- It will actually call AddGenericClassPostConstruct defined there.
AddClassPostConstruct("screens/mainscreen", DoInit)

--This gives us custom worldgen screens.	
local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
	--Check for cloudrealm.
	local Climbing = modrequire 'lib.climbing'

	TheSim:LoadPrefabs {"MOD_UpAndAway"}


	DebugSay "update worldgen!"

	-- The old version only worked for the 1st save slot, because
	-- there's no selected slot in the SaveIndex when this runs.
	if Climbing.IsCloudLevelNumber(world_gen_options.level_world) then

		DebugSay "update worldgen passed!"
		
		--Changes the background during worldgen.
		--self.bg:SetTexture("images/bg_gen.xml", "bg_plain.tex")
		self.bg:SetTexture("images/bg_up.xml", "bg_plain.tex")
		self.bg:SetTint(140, 140, 100, 1)
		self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
		self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
		self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
		self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
		self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)	
		
		--The shadow hands can be changed.
		--[[
		local hand_scale = 1.5
		self.hand1:GetAnimState():SetBuild("creepy_hands")
		self.hand1:GetAnimState():SetBank("creepy_hands")
		self.hand1:GetAnimState():SetTime(math.random()*2)
		self.hand1:GetAnimState():PlayAnimation("idle", true)
		self.hand1:SetPosition(400, 0, 0)
		self.hand1:SetScale(hand_scale,hand_scale,hand_scale)	
	
		self.hand2 = self.bottom_root:AddChild(UIAnim())
		self.hand2:GetAnimState():SetBuild("creepy_hands")
		self.hand2:GetAnimState():SetBank("creepy_hands")
		self.hand2:GetAnimState():PlayAnimation("idle", true)
		self.hand2:GetAnimState():SetTime(math.random()*2)
		self.hand2:SetPosition(-425, 0, 0)
		self.hand2:SetScale(-hand_scale,hand_scale,hand_scale)	
		--]]

		STRINGS.UPUI =
		{
			CLOUDGEN = {
			
				VERBS = 
				{
					"Deploying",
					"Decompressing",
					"Herding",
					"Replacing",
					"Assembling",
					"Insinuating",
					"Reticulating",
					"Inserting",
					"Framing",
				},
				
				NOUNS=
				{
					"clouds",
					"sheep",
					"candy",
					"giants",
					"snowflakes",
					"skeletons",
					"static batteries",
					"castles",
					"beans",
					"nature",		
				},
			},
		}	
	
		print("This is the worldgen screen.")

		--We can replace the worldgen animation and strings.
		self.worldanim:GetAnimState():SetBank("generating_cloud")
		self.worldanim:GetAnimState():SetBuild("generating_cloud")
		self.worldanim:GetAnimState():PlayAnimation("idle", true)
		
		self.worldgentext:SetString("GROWING BEANSTALK")	
		self.verbs = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.VERBS)
		self.nouns = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.NOUNS)
		
	end
end

--AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

--[[
-- This is quite ugly, but we need the ctor parameters.
--]]
do
	local WorldGenScreen = require "screens/worldgenscreen"
	local mt = getmetatable(WorldGenScreen)

	local old_ctor = WorldGenScreen._ctor
	WorldGenScreen._ctor = function(...)
		old_ctor(...)
		UpdateWorldGenScreen(...)
	end
	local old_call = mt.__call
	mt.__call = function(class, ...)
		local self = old_call(class, ...)
		UpdateWorldGenScreen(self, ...)
		return self
	end
end

local function OnUnlockMound(inst)
	if not inst:IsValid() then return end

	local tree = SpawnPrefab("beanstalk_sapling")
	if tree then
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	TheMod:DebugSay("[", inst, "] unlocked.")
	inst:Remove()
end

local function addmoundtag(inst)
	inst:AddTag("mound")
    inst:AddComponent("lock")
    inst.components.lock.locktype = "beans"
    inst.components.lock.isstuck = false
    inst.components.lock:SetOnUnlockedFn(OnUnlockMound)  
end	

--Changes "activate" to "talk to" for "shopkeeper".
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.ACTIVATE and bufaction.target and bufaction.target.prefab == "shopkeeper" then
			return "Talk To"
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

--Changes "Unlock" to "Plant" for beans and mounds.
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.UNLOCK and bufaction.target and bufaction.target.prefab == "mound" then
			return "Plant"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)

--Changes "Give" to "Refiner" for the refiner.
AddSimPostInit(function(inst)
	local oldactionstringoverride = inst.ActionStringOverride
	function inst:ActionStringOverride(bufaction)
		if bufaction.action == GLOBAL.ACTIONS.GIVE and bufaction.target and bufaction.target.prefab == "refiner" then
			return "Refine"
		end
		if oldactionstringoverride then
			return oldactionstringoverride(inst, bufaction)
		end
	end
end)

AddPrefabPostInit("mound", addmoundtag)

table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "winnie")

--This adds our minimap atlases.
AddMinimapAtlas("images/winnie.xml")
AddMinimapAtlas("images/beanstalk.xml")
AddMinimapAtlas("images/beanstalk_exit.xml")
AddMinimapAtlas("images/cloud_algae.xml")
AddMinimapAtlas("images/shopkeeper.xml")
AddMinimapAtlas("images/scarecrow.xml")

AddMinimapAtlas("images/cloudcrag.xml")
AddMinimapAtlas("images/octocopter.xml")
AddMinimapAtlas("images/dragonblood_tree.xml")
AddMinimapAtlas("images/hive_marshmallow.xml")
AddMinimapAtlas("images/cauldron.xml")
AddMinimapAtlas("images/thunder_tree.xml")
AddMinimapAtlas("images/jellyshroom_red.xml")
AddMinimapAtlas("images/jellyshroom_green.xml")
AddMinimapAtlas("images/jellyshroom_blue.xml")
AddMinimapAtlas("images/cloud_bush.xml")
--AddMinimapAtlas("images/cloud_coral.xml")
--AddMinimapAtlas("images/cloud_fruit_tree.xml")
--AddMinimapAtlas("images/bean_giant_statue.xml")
--AddMinimapAtlas("images/weather_machine.xml")
--AddMinimapAtlas("images/refiner.xml")
--AddMinimapAtlas("images/kettle.xml")

AddModCharacter("winnie")

local oldMakeNoGrowInWinter = _G.MakeNoGrowInWinter
 
function _G.MakeNoGrowInWinter(inst)
    -- We need to delay the actual work because spawning the player happens late.
    inst:DoTaskInTime(0, function(inst)
        if _G.GetPlayer().prefab ~= "winnie" or not (inst.components.pickable and inst.components.pickable.transplanted) then
            return oldMakeNoGrowInWinter(inst)
        end
    end)
end

--This adds our 'Fable' tech tree. Thanks to @Heavenfall for the code.
--assert( type(level) == "table", "Invalid recipe level specified. If you wish to use TECH.NONE, do it explicitly." )

GLOBAL.TECH.NONE.FABLE = 0
GLOBAL.TECH.FABLE_ONE = {FABLE = 3}

for k,v in pairs(GLOBAL.TUNING.PROTOTYPER_TREES) do 
    GLOBAL.TUNING.PROTOTYPER_TREES[k].FABLE = 0
	GLOBAL.TUNING.PROTOTYPER_TREES.FABLE= {SCIENCE = 0,MAGIC = 0,ANCIENT = 0,FABLE=1}
end	

local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

--These are the inventory icons for recipe ingredients.
local cloud_cotton = Ingredient( "cloud_cotton", 1)
cloud_cotton.atlas = "images/inventoryimages/cloud_cotton.xml"

local crystal_fragment_relic = Ingredient("crystal_fragment_relic", 1)
crystal_fragment_relic.atlas = "images/inventoryimages/crystal_fragment_relic.xml"

--These are the recipes and the icons for the recipe output.
local cotton_vest = Recipe("cotton_vest", { Ingredient("silk", 4), Ingredient("cloud_cotton", 4, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.DRESS, TECH.FABLE_ONE)

cotton_vest.atlas = "images/inventoryimages/cotton_vest.xml"

local cotton_hat = Recipe("cotton_hat", { Ingredient("silk", 2), Ingredient("cloud_cotton", 6, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.DRESS, TECH.FABLE_ONE)

cotton_hat.atlas = "images/winnie.xml"

local weather_machine = Recipe("weather_machine", { Ingredient("gears", 4), Ingredient("crystal_fragment_relic", 6, "images/inventoryimages/crystal_fragment_relic.xml") }, RECIPETABS.SCIENCE, TECH.FABLE_ONE)

weather_machine.atlas = "images/winnie.xml"

local research_lectern = Recipe("research_lectern", { Ingredient("silk", 2), Ingredient("cloud_cotton", 6, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.SCIENCE, TECH.SCIENCE_TWO)

research_lectern.atlas = "images/winnie.xml"

local cotton_candy = Recipe("cotton_candy", { Ingredient("cloud_cotton", 6, "images/inventoryimages/cloud_cotton.xml"), Ingredient("candy_fruit", 6, "images/inventoryimages/candy_fruit.xml") }, RECIPETABS.FARM, TECH.SCIENCE_TWO)

cotton_candy.atlas = "images/winnie.xml"

local grabber = Recipe("grabber", { Ingredient("magnet", 2, "images/inventoryimages/cloud_cotton.xml"), Ingredient("cane", 1), Ingredient("rubber", 4, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.TOOLS, TECH.FABLE_ONE)

grabber.atlas = "images/winnie.xml"

local magnet = Recipe("magnet", { Ingredient("gears", 2), Ingredient("crystal_fragment", 3, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.SCIENCE, TECH.FABLE_ONE)

magnet.atlas = "images/winnie.xml"

local crystal_lamp = Recipe("crystal_lamp", { Ingredient("beanlet_shell", 1, "images/inventoryimages/cloud_cotton.xml"), Ingredient("crystal_fragment", 4, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.LIGHT, TECH.FABLE_ONE)

crystal_lamp.atlas = "images/winnie.xml"

local refined_black_crystal = Recipe("refined_black_crystal", { Ingredient("black_crystal_fragment", 9, "images/inventoryimages/crystal_fragment_black.xml") }, RECIPETABS.REFINE, TECH.FABLE_ONE)

refined_black_crystal.atlas = "images/inventoryimages/crystal_fragment_black.xml"

local refined_white_crystal = Recipe("refined_white_crystal", { Ingredient("white_crystal_fragment", 9, "images/inventoryimages/crystal_fragment_white.xml") }, RECIPETABS.REFINE, TECH.FABLE_ONE)

refined_white_crystal.atlas = "images/inventoryimages/crystal_fragment_white.xml"

local black_crystal_staff = Recipe("blackstaff", { Ingredient("spear", 1), Ingredient("refined_black_crystal", 1, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.MAGIC, TECH.FABLE_ONE)

black_crystal_staff.atlas = "images/winnie.xml"

local white_crystal_staff = Recipe("whitestaff", { Ingredient("spear", 1), Ingredient("refined_white_crystal", 1, "images/inventoryimages/cloud_cotton.xml") }, RECIPETABS.MAGIC, TECH.FABLE_ONE)

white_crystal_staff.atlas = "images/winnie.xml"
--]]
