---
-- Main file. Run through modmain.lua
--
-- @author debugman18
-- @author simplex


--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

-- This just enables syntax conveniences.
BindTheMod()


local Pred = wickerrequire 'lib.predicates'

require 'mainfunctions'

modrequire('api_abstractions')()

modrequire 'debugtools'

modrequire 'strings'

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
	local Climbing = modrequire 'worldgen.climbing'

	local metadata_key = GetModname() .. "_metadata"
	if not inst.components[metadata_key] then
		inst:AddComponent(metadata_key)
	end
	
	if inst.components[metadata_key]:Get("height") == nil then
		inst.components[metadata_key]:Set("height", Climbing.GetLevelHeight())
	end
end)

local function Credits()
	local ModCreditsScreen = require "screens/modcreditsscreen"
	GLOBAL.TheFrontEnd:PushScreen(ModCreditsScreen())
end

--Changes the main menu.
local function UpdateMainScreen(self)

	local Image = require "widgets/image"
	local ImageButton = require "widgets/imagebutton"
	local Text = require "widgets/text"	

	--This displays the current version to the user.	
	self.motd.motdtext:SetPosition(0, -20, 0)
	self.motd.motdtitle:SetString("Version Information")
	self.motd.motdtext:EnableWordWrap(true)   
	self.motd.motdtext:SetString("You are currently using version '" .. CFG.VERSION .. "' of Up and Away. Thank you for testing!")
	
	--This adds a button to the MOTD.
	self.motd.button = self.motd:AddChild(ImageButton())
    self.motd.button:SetPosition(0, -100, 0)
    self.motd.button:SetText("More Info")
    self.motd.button:SetOnClick( function() 
		GLOBAL.VisitURL("http://forums.kleientertainment.com/index.php?" .. TheMod.modinfo.forumthread)
	end )
	self.motd.motdtext:EnableWordWrap(true) 
	
	--Adds a mod credits button.
	self.modcredits_button = self.bottom_left_stuff:AddChild(ImageButton())
    self.modcredits_button:SetPosition(0, -150, 0)
    self.modcredits_button:SetText("Mod Credits")
    self.modcredits_button:SetOnClick( function() Credits() end )	
	
	--We can change the background image here.
	self.bg:SetTexture("images/bg_up.xml", "bg_plain.tex")
	self.bg:SetTint(100, 100, 100, 1)
	
	--We can change the shield image here.
	self.shield:SetTexture("images/uppanels.xml", "panel_shield.tex")
	
	--This renames the banner.
	STRINGS.UI.MAINSCREEN.UPDATENAME = "Up and Away"
	self.updatename:SetString(STRINGS.UI.MAINSCREEN.UPDATENAME)
	self.banner:SetPosition(0, -170, 0)	
		
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
	
	self:UpdateDaysUntil()
	self:MainMenu()
	self.menu:SetFocus()
	
end

-- This works under both game versions (due to api_abstractions.lua)
-- It will actually call AddGenericClassPostConstruct defined there.
AddClassPostConstruct("screens/mainscreen", UpdateMainScreen)
	
--This gives us custom worldgen screens.	
local function UpdateWorldGenScreen(self)
	--Check for cloudrealm.	"cloudrealm"
	local Pred = wickerrequire 'lib.predicates'

	if Pred.IsCloudLevel() then
	
		--Changes the background during worldgen.
		self.bg:SetTexture("images/bg_up.xml", "bg_plain.tex")
		self.bg:SetTint(100, 100, 100, 1)
		
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
		--self.worldanim:GetAnimState():SetBuild("generating_cave")
		--self.worldanim:GetAnimState():SetBank("generating_cloudrealm")
		
		self.worldanim:GetAnimState():SetBuild("generating_world")
		self.worldanim:GetAnimState():SetBank("generating_world")
		
		self.worldgentext:SetString("GROWING BEANSTALK")	
		self.verbs = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.VERBS)
		self.nouns = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.NOUNS)
		
	end
end

AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

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
