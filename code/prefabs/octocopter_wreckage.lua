BindGlobal()

local PopupDialogScreen = require "screens/popupdialog"

local assets = {
	Asset("ANIM", "anim/sky_octopus.zip"), 	
	Asset("ANIM", "anim/sewing_kit.zip"),
}

local function RepairOctocopter(inst)

    local function prealphawarning(inst)
        SetPause(false) 
        TheFrontEnd:PopScreen()
    end

    SetPause(true)
    local options = {
        {text="Well, okay.", cb = prealphawarning},
    }

    TheFrontEnd:PushScreen(PopupDialogScreen(

    "Sorry, this segment isn't finished!", 
    "Normally, this would take you to the next level. That isn't ready yet, though. So have this popup message instead!",

    options))	
end	

local function TestForRepair(inst)
	local partsCount = 0
	for part,found in pairs(inst.collectedParts) do
		if found == true then
			partsCount = partsCount + 1
			print(partsCount)
		end
	end
	if partsCount == 3 then
		print("Completed repair.")
		RepairOctocopter(inst)
	end
end

local function ItemGet(inst, giver, item)
	if inst.collectedParts[item.prefab] ~= nil then
		inst.collectedParts[item.prefab] = true
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_addpart", "teleportato_addpart")
		TestForRepair(inst)
	end
end

local function ItemTradeTest(inst, item)
	if item:HasTag("octocopter_part") then
		return true
	end
	return false
end

local function OnLoad(inst, data)
	inst.collectedParts = data.collectedParts
end

local function OnSave(inst, data)
	data.collectedParts = inst.collectedParts
end

local function fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("sky_octopus")
	inst.AnimState:SetBuild("sky_octopus")
	inst.AnimState:PlayAnimation("idle", true)

	inst.Transform:SetScale(1.4, 1.4, 1.4)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("octocopter.tex")

    inst:AddComponent("inspectable")

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ItemTradeTest)
	inst.components.trader.onaccept = ItemGet

	inst.collectedParts = {octocopterpart1 = false, octocopterpart2 = false, octocopterpart3 = false}

	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	
	return inst
end	

local function part1fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sewing_kit")
    inst.AnimState:SetBuild("sewing_kit")
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddTag("octocopter_part")
	inst:AddComponent("tradable")    
	inst:AddTag("irreplaceable")	

	return inst
end	

local function part2fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sewing_kit")
    inst.AnimState:SetBuild("sewing_kit")
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddTag("octocopter_part")
	inst:AddComponent("tradable")    
	inst:AddTag("irreplaceable")

	return inst
end	

local function part3fn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sewing_kit")
    inst.AnimState:SetBuild("sewing_kit")
    inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")

	inst:AddTag("octocopter_part")
	inst:AddComponent("tradable")    
	inst:AddTag("irreplaceable")

	return inst
end	

return {
	Prefab ("cloudrealm/octocopter_wreckage", fn, assets),

	Prefab ("cloudrealm/octocopterpart1", part1fn, assets),
	Prefab ("cloudrealm/octocopterpart2", part2fn, assets),	
	Prefab ("cloudrealm/octocopterpart3", part3fn, assets),		
}	