--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

-- This just enables syntax conveniences.
BindTheMod()


local Pred = wickerrequire 'lib.predicates'


require 'mainfunctions'


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
pcall(function() _G.package.loaded["widgets/SavingIndicator"] = require "widgets/savingindicator" end)
pcall(function() _G.package.loaded["widgets/StatusDisplays"] = require "widgets/statusdisplays" end)
if type(require "screens/mainscreen") == "table" then
	AddClassPostConstruct("screens/mainscreen", UpdateMainScreen)
else
	AddGlobalClassPostConstruct("screens/mainscreen", "MainScreen", UpdateMainScreen)
end

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
