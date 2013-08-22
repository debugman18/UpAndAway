local prefabs = 
{
	--Vanilla prefabs.
	"goldnugget",
	"skeleton",
	"marble",
	
	--Mod prefabs.
	"beanstalk_chunk",
	"golden_egg",
	"cloud_turf",
	"magic_beans",
}

local assets =
{
    Asset("ANIM", "anim/beanstalk.zip"),
	--Asset("ANIM", "anim/beanstalk_chopped.zip" ),	
    Asset("SOUND", "sound/tentacle.fsb"),
}

local function onsave(inst, data)
	data.chopped = inst.chopped
end           

local function onload(inst, data)
	inst.chopped = data and data.chopped

	if data and data.chopped then
		chopped(inst)
	end
end  

--Fixes silly string.
local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end

local function BeanstalkAdventure(cb, slot, start_world)
	local playerdata = {}
	local player = GetPlayer()
	local self = SaveGameIndex
	if player then
		playerdata = player:GetSaveRecord().data
		playerdata.leader = nil
		playerdata.sanitymonsterspawner = nil
        
	end 
		
	self.data.slots[self.current_slot].current_mode = "adventure"
	
	if self.data.slots[self.current_slot].modes.adventure then
		self.data.slots[self.current_slot].modes.adventure.playerdata = playerdata
	end
		
	self.data.slots[slot].modes.adventure = {world = start_world}
	self:Save(cb)
end

--Makes the beanstalk climbable.
local function OnActivate(inst)
	
	SetHUDPause(true)

	
	local function startadventure()
		
		local function onsaved()
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
			SaveGameIndex.data.slots[SaveGameIndex:GetCurrentSaveSlot()].modes.adventure = {world = 8}
		end

		local level = 8
		local slot = SaveGameIndex:GetCurrentSaveSlot()
		local character = GetPlayer().prefab
		
		SetHUDPause(false)	
				
		--SaveGameIndex:SaveCurrent(function() SaveGameIndex:FakeAdventure(onsaved, slot, level) end)
		SaveGameIndex:SaveCurrent(function() BeanstalkAdventure(onsaved, slot, level) end)
	end
	
	local function rejectadventure()
		SetHUDPause(false) 
		inst.components.activatable.inactive = true
		TheFrontEnd:PopScreen()
	end		
	
	local options = {
		{text="YES", cb = startadventure},
		{text="NO", cb = rejectadventure},  
	}

	TheFrontEnd:PushScreen(PopupDialogScreen(
	
	"Up and Away", 
	"The land above is strange and foreign. Do you want to continue?",
	
	options))
	
end


--This changes the screen some if the player is far.
local function onfar(inst)
	--TheCamera:SetDistance(100)
end

--This changes the screen some if the player is near.
local function onnear(inst)
	--TheCamera:SetDistance(100)
end

local function chopbeanstalk(inst, chopper, chops)
    if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
end

chopped = function(inst)
    inst:RemoveComponent("workable")
	inst:RemoveComponent("activatable")
    inst.AnimState:PushAnimation("idle_hole","loop")
	inst.chopped = true	
end

local function chopdownbeanstalk(inst, chopper)
    inst:RemoveComponent("workable")
	inst:RemoveComponent("activatable")
    local pt = Vector3(inst.Transform:GetWorldPosition())

    inst:DoTaskInTime(.4, function() 
		local sz = 10
		GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.25, 0.03, sz, 6)
    end)

    inst.AnimState:PlayAnimation("retract",false)
    inst.AnimState:PushAnimation("idle_hole","loop")	
	inst.components.lootdropper:DropLoot(pt)
	inst.chopped = true
end

local function fn(Sim)

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()	
	local light = SpawnPrefab("exitcavelight")	
	
    inst.entity:AddSoundEmitter()

    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_idle_LP","loop")

    --inst.Physics:SetCollisionGroup(COLLISION.GROUND)
    trans:SetScale(1.5,1.5,1.5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "tentapillar.png" )

	anim:SetBank("tentaclepillar")
	anim:SetBuild("beanstalk")
	
    inst.AnimState:PushAnimation("idle", "loop")	

	light.Transform:SetPosition(inst.Transform:GetWorldPosition())	

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 30)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    ---------------------  
	
	inst:AddComponent("activatable")
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.OnActivate = OnActivate	
	inst.components.activatable.quickaction = true
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetOnWorkCallback(chopbeanstalk)
    inst.components.workable:SetOnFinishCallback(chopdownbeanstalk)
	
    inst:AddComponent("inspectable")
	
    -------------------
    inst:AddComponent("lootdropper")
		
	--Beanstalk chunk drops.
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 1.0)	
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.75)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
	inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)

	--Skeleton drops.
	inst.components.lootdropper:AddChanceLoot("skeleton", 0.6)
	inst.components.lootdropper:AddChanceLoot("skeleton", 0.2)
		
	--Gold nugget drops.
	inst.components.lootdropper:AddChanceLoot("goldnugget", 0.7)
	inst.components.lootdropper:AddChanceLoot("goldnugget", 0.5)
		
	--Marble drops.
	inst.components.lootdropper:AddChanceLoot("marble", 0.8)
	inst.components.lootdropper:AddChanceLoot("marble", 0.8)
		
	--Cloud turf drops.
	inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
	inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
	inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
		
	--Magic bean drops.
	inst.components.lootdropper:AddChanceLoot("magic_beans", 0.21)
	inst.components.lootdropper:AddChanceLoot("magic_beans", 0.18)	
	
	inst.chopped = false
	inst.OnSave = onsave
	inst.OnLoad = onload	
    return inst		
end

return Prefab( "common/monsters/beanstalk", fn, assets, prefabs )