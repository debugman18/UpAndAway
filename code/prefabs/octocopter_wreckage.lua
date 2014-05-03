BindGlobal()

local PopupDialogScreen = require "screens/popupdialog"

local assets = {
	Asset("ANIM", "anim/sky_octopus_wreckage.zip"), 	
	Asset("ANIM", "anim/sky_octopus.zip"), 

	Asset("ANIM", "anim/octocopterpart1.zip"),
	Asset("ANIM", "anim/octocopterpart2.zip"),
	Asset("ANIM", "anim/octocopterpart3.zip"),

	Asset( "ATLAS", "images/inventoryimages/octocopterpart1.xml" ),
	Asset( "IMAGE", "images/inventoryimages/octocopterpart1.tex" ),	

	Asset( "ATLAS", "images/inventoryimages/octocopterpart2.xml" ),
	Asset( "IMAGE", "images/inventoryimages/octocopterpart2.tex" ),	

	Asset( "ATLAS", "images/inventoryimages/octocopterpart3.xml" ),
	Asset( "IMAGE", "images/inventoryimages/octocopterpart3.tex" ),			
}

local function RepairOctocopter(inst)

	inst.AnimState:PushAnimation("wrecked_fixed", false)

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

    inst:AddComponent("inspectable")

	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ItemTradeTest)
	inst.components.trader.onaccept = ItemGet

	inst.collectedParts = {octocopterpart1 = false, octocopterpart2 = false, octocopterpart3 = false}

	GetWorld():PushEvent("octocoptercrash")

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

	--Rotor Blade

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("octocopterpart1")
    inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/octocopterpart1.xml"

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

	--Rotor Plate

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("octocopterpart2")
    inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/octocopterpart2.xml"

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

	--Rotor Hub

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("octocopterpart3")
    inst.AnimState:PlayAnimation("closed")

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/octocopterpart3.xml"

	inst:AddTag("octocopter_part")
	inst:AddComponent("tradable")    
	inst:AddTag("irreplaceable")

	return inst
end	

local function part1spawner(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()	
	GetWorld().octocopterpart1 = inst
	inst:ListenForEvent("octocoptercrash", 
		function(inst) 
			local part1 = SpawnPrefab("octocopterpart1")
			part1.Transform:SetPosition(GetWorld().octocopterpart1.Transform:GetWorldPosition())
			print(GetWorld().octocopterpart1.Transform:GetWorldPosition())
		end, GetWorld()
		)
	return inst
end

local function part2spawner(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()	
	GetWorld().octocopterpart2 = inst
	inst:ListenForEvent("octocoptercrash", 
		function(inst) 
			local part2 = SpawnPrefab("octocopterpart2")
			part2.Transform:SetPosition(GetWorld().octocopterpart2.Transform:GetWorldPosition())
			print(GetWorld().octocopterpart2.Transform:GetWorldPosition())
		end, GetWorld()
		)
	return inst
end

local function part3spawner(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()	
	GetWorld().octocopterpart3 = inst
	inst:ListenForEvent("octocoptercrash", 
		function(inst) 
			local part3 = SpawnPrefab("octocopterpart3")
			part3.Transform:SetPosition(GetWorld().octocopterpart3.Transform:GetWorldPosition())
			print(GetWorld().octocopterpart3.Transform:GetWorldPosition())
		end, GetWorld()
		)
	return inst
end

return {
	Prefab ("cloudrealm/octocopter_wreckage", fn, assets),

	Prefab ("cloudrealm/octocopterpart1", part1fn, assets),
	Prefab ("cloudrealm/octocopterpart2", part2fn, assets),	
	Prefab ("cloudrealm/octocopterpart3", part3fn, assets),	

	Prefab ("cloudrealm/part1spawner", part1spawner, assets),
	Prefab ("cloudrealm/part2spawner", part2spawner, assets),	
	Prefab ("cloudrealm/part3spawner", part3spawner, assets),			
}	