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

--Fixes silly string.
local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end


--Makes the beanstalk climbable.
local function OnActivate(inst)

	--GetPlayer():DoTaskInTime(2, function()
	
	SetHUDPause(true)
	
	local function startadventure()
		
		local function onsaved()
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
			SaveGameIndex.data.slots[SaveGameIndex:GetCurrentSaveSlot()].modes.adventure = {world = 1}
		end
		
	
		local level = 8
		local slot = SaveGameIndex:GetCurrentSaveSlot()		
		local customoptions = {
			preset = {"SKY_LEVEL_1"},
		}

		local character = GetPlayer().prefab		
		SetHUDPause(false)	
		
		SaveGameIndex:FakeAdventure(onsaved, slot, level)	

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
	
	--end)
	
end

--Beanstalks drop loot.
local function DropLoot(inst) 

    if inst.isChopped == true then

        local loot = {}
				
		--Remove any previous (random) loot table.
        inst.components.lootdropper:SetLoot(loot)
		
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

    end
	
end

--This changes the screen some if the player is far.
local function onfar(inst)
	TheCamera:SetDistance(100)
end

--This changes the screen some if the player is near.
local function onnear(inst)
	TheCamera:SetDistance(100)
end

local function OnWork(inst, worker, workleft)
	local pt = Point(inst.Transform:GetWorldPosition())
	if workleft <= 0 then
		--inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		inst.components.lootdropper:DropLoot(pt)
	end
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
	
	inst.AnimState:PlayAnimation("emerge") 
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)	
	
    inst:AddComponent("inspectable")
	
    -------------------
    inst:AddComponent("lootdropper")
	
    return inst		
end

return Prefab( "common/monsters/beanstalk", fn, assets, prefabs )