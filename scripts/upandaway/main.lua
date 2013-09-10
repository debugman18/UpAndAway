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


local function evergreens_ret(inst)
	inst:AddTag"evergreen_ret"
	
	if GetPlayer().goneUp == true then
		print "Testing goneUp."
	end	
	
end

--Changes the title displayed on the main menu.
local function UpdateMainScreen(self)
	self.updatename:SetString("Up and Away")
end

-- This works under both game versions (due to api_abstractions.lua)
-- It will actually call AddGenericClassPostConstruct defined there.
AddClassPostConstruct("screens/mainscreen", UpdateMainScreen)

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
