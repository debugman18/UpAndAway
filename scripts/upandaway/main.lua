---
-- Main file. Run through modmain.lua
--
-- @author debugman18
-- @author simplex


--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


BindModModule 'modenv'
-- This just enables syntax conveniences.
BindTheMod()


local Pred = wickerrequire 'lib.predicates'

require 'mainfunctions'

modrequire('api_abstractions')()

modrequire 'profiling'
modrequire 'debugtools'
modrequire 'strings'
modrequire 'postinits.burning'


local CFG = TUNING.UPANDAWAY

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


--[[
-- This is just to prevent changes in out implementation breaking old saves.
--]]
AddPrefabPostInit("world", function(inst)
	local Climbing = modrequire 'lib.climbing'

	local metadata_key = GetModname() .. "_metadata"
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
local function UpdateMainScreen(self)
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
	self.bg:SetTexture("images/bg_up.xml", "bg_plain.tex")
	self.bg:SetTint(100, 100, 100, 1)
	
	--We can change the shield image here.
	self.shield:SetTexture("images/uppanels.xml", "panel_shield.tex")
	
	--This renames the banner.
	STRINGS.UI.MAINSCREEN.UPDATENAME = "Up and Away"
	self.updatename:SetString(STRINGS.UI.MAINSCREEN.UPDATENAME)
	self.banner:SetPosition(0, -170, 0)	

	--Adds our own mod button.
	self.upandaway_button = self.updatename:AddChild(ImageButton())
	--self.upandaway_button:SetPosition(-550, -130, 0)
	self.upandaway_button:SetPosition(0,0,0)
	self.upandaway_button:SetText("Up and Away")
	self.upandaway_button:SetOnClick( function() UpMenu() end )	
	--self.upandaway_button:SetScale(.8)
		
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
	self:MainMenu()
	self.menu:SetFocus()
	
end

-- This works under both game versions (due to api_abstractions.lua)
-- It will actually call AddGenericClassPostConstruct defined there.
AddClassPostConstruct("screens/mainscreen", UpdateMainScreen)

--This gives us custom worldgen screens.	
local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
	--Check for cloudrealm.	"cloudrealm"
	local Climbing = modrequire 'lib.climbing'

	DebugSay "update worldgen!"

	-- The old version only worked for the 1st save slot, because
	-- there's no selected slot in the SaveIndex when this runs.
	if Climbing.IsCloudLevelNumber(world_gen_options.level_world) then

		DebugSay "update worldgen passed!"
		
		--Changes the background during worldgen.
		self.bg:SetTexture("images/bg_gen.xml", "bg_plain.tex")
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
	
		--We can replace the worldgen animation and strings.
		self.worldanim:GetAnimState():SetBank("generating_cave")
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

local function OnUnlock(inst)
    local tree = SpawnPrefab("beanstalk")
    if not inst.components.lock:IsLocked() and tree then
        tree.Transform:SetPosition(inst.Transform:GetWorldPosition() )
        print "Unlocked"
    end
    print "Locked"
end

local function addmoundtag(inst)
	inst:AddTag("mound")
    inst:AddComponent("lock")
    inst.components.lock.locktype = "beans"
    inst.components.lock.isstuck = false
    inst.components.lock:SetOnUnlockedFn(OnUnlock)  
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

AddPrefabPostInit("mound", addmoundtag)

table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "winnie")

AddModCharacter("winnie")
