BindGlobal()

--[[
-- This is without the "octocopter" prefix.
--]]
local PART_NAMES = {
	"part1", --Rotor Blade
	"part2", --Rotor Plate
	"part3", --Rotor Hub
}

local assets = {
	Asset("ANIM", "anim/sky_octopus_wreckage.zip"), 	
	Asset("ANIM", "anim/sky_octopus.zip"),
}

for i, partname in ipairs(PART_NAMES) do
	table.insert(assets, Asset("ANIM", "anim/octocopter"..partname..".zip"))
	table.insert(assets, Asset("ATLAS", inventoryimage_atlas("octocopter"..partname)))
	table.insert(assets, Asset("ATLAS", inventoryimage_texture("octocopter"..partname)))
end

------------------------------------------------------------------------

--[[
-- This returns the octocopter_wreckage prefab.
--
-- Note that now the "octocoptercrash" event is pushed within octocopter.lua.
--]]
local function MakeOctocopterWreckage()
	local FULL_PART_NAMES = {}
	for i, partname in ipairs(PART_NAMES) do
		FULL_PART_NAMES[i] = "octocopter"..partname
	end

	local FULL_PART_NAME_SET = {}
	for i, v in ipairs(FULL_PART_NAMES) do
		FULL_PART_NAME_SET[v] = true
	end

	---

	local function OnComplete(inst)
		inst:AddTag("complete")
		inst:RemoveComponent("trader")
		inst.AnimState:PushAnimation("wrecked_fixed", false)
	end

	local function RepairOctocopter(inst)
		local PopupDialogScreen = require "screens/popupdialog"

		OnComplete(inst)

		local function prealphawarning()
			TryPause(false) 
			TheFrontEnd:PopScreen()
		end

		TryPause(true)
		local options = {
			{text="Well, okay.", cb = prealphawarning},
		}

		TheFrontEnd:PushScreen(PopupDialogScreen(
			"Sorry, this segment isn't finished!", 
			"Normally, this would take you to the next level. That isn't ready yet, though. So have this popup message instead!",
			options))	
	end	

	local function AttemptRepair(inst)
		local collected = assert( inst.collectedParts )
		for _, prefab in ipairs(FULL_PART_NAMES) do
			if not collected[prefab] then
				return
			end
		end
		RepairOctocopter(inst)
	end

	local function ItemGet(inst, giver, item)
		if FULL_PART_NAME_SET[item.prefab] then
			inst.collectedParts[item.prefab] = true
			inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_addpart", "teleportato_addpart")
			AttemptRepair(inst)
		end
	end

	local function ItemTradeTest(inst, item)
		return FULL_PART_NAME_SET[item.prefab]
	end

	local function OnLoad(inst, data)
		if not data then return end

		if data.collectedParts then
			inst.collectedParts = data.collectedParts
		end

		if data.complete then
			OnComplete(inst)
		end
	end

	local function OnSave(inst, data)
		data.collectedParts = inst.collectedParts
		
		if inst:HasTag("complete") then
			data.complete = true
		end
	end

	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()

		inst.AnimState:SetBank("sky_octopus_wreckage")
		inst.AnimState:SetBuild("sky_octopus_wreckage")
		inst.AnimState:PlayAnimation("wrecked_idle", true)

		--inst.AnimState:SetBank("sky_octopus")
		--inst.AnimState:SetBuild("sky_octopus")
		--inst.AnimState:PlayAnimation("death")

		local physics = inst.entity:AddPhysics()  
		MakeObstaclePhysics(inst, 1.5)

		inst.Transform:SetScale(1.4, 1.4, 1.4)

		inst.entity:AddMiniMapEntity()
		inst.MiniMapEntity:SetIcon("octocopter.tex")

		------------------------------------------------------------------------
		SetupNetwork(inst)
		------------------------------------------------------------------------

		inst:AddComponent("inspectable")

		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ItemTradeTest)
		inst.components.trader.onaccept = ItemGet

		---

		inst.collectedParts = {}

		---

		inst.OnSave = OnSave
		inst.OnLoad = OnLoad

		---
		
		return inst
	end	

	return Prefab("cloudrealm/octocopter_wreckage", fn, assets)
end

------------------------------------------------------------------------

-- This returns an octocopter part prefab.
-- 'partname' is the prefab's name *without* the "octocopter" prefix.
local function MakeOctocopterPart(partname)
	local full_partname = "octocopter"..partname

	local function partfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank("icebox")
		inst.AnimState:SetBuild(full_partname)
		inst.AnimState:PlayAnimation("closed")

		inst:AddTag("octocopter_part")
		inst:AddTag("irreplaceable")
		inst:AddTag("nonpotatable")

		------------------------------------------------------------------------
		SetupNetwork(inst)
		------------------------------------------------------------------------

		inst:AddComponent("inspectable")
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = inventoryimage_atlas(full_partname)

		inst:AddComponent("tradable")    

		return inst
	end

	return Prefab("cloudrealm/"..full_partname, partfn, assets)
end

------------------------------------------------------------------------

-- This returns an octocopter part spawner prefab.
-- 'partname' is the prefab's name *without* the "octocopter" prefix.
local function MakeOctocopterPartSpawner(partname)
	local full_spawnername = partname.."spawner"
	local full_partname = "octocopter"..partname

	local function partspawnerfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()	

		inst:AddTag("NOCLICK")

		------------------------------------------------------------------------
		SetupNetwork(inst)
		------------------------------------------------------------------------

		inst:ListenForEvent("octocoptercrash", 
			function(wrld) 
				local part = assert( SpawnPrefab(full_partname) )
				Game.Move(part, inst)
				inst:Remove()
			end,
			GetWorld())

		return inst
	end

	return Prefab("cloudrealm/"..full_spawnername, partspawnerfn, assets)
end

------------------------------------------------------------------------

local ret = {MakeOctocopterWreckage()}

for i, partname in ipairs(PART_NAMES) do
	table.insert(ret, MakeOctocopterPart(partname))
	table.insert(ret, MakeOctocopterPartSpawner(partname))
end

return ret
