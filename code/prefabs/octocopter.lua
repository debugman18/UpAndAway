BindGlobal()

local assets =
{
	Asset("ANIM", "anim/sky_octopus.zip"),
}

local prefabs =
{
   --"beak",
   --"feather",
}

local loot = 
{
    --"beak",
    --"feather",
}

local SLEEP_DIST_FROMHOME = 1
local SLEEP_DIST_FROMTHREAT = 20
local MAX_CHASEAWAY_DIST = 40
local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function Retarget(inst)

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > TUNING.KNIGHT_TARGET_DIST*TUNING.KNIGHT_TARGET_DIST) and not
    (inst.components.follower and inst.components.follower.leader) then
        return
    end
    
    local newtarget = FindEntity(inst, TUNING.KNIGHT_TARGET_DIST, function(guy)
        return (guy:HasTag("character") or guy:HasTag("monster") ) and inst.components.combat:CanTarget(guy)
    end)
    return newtarget
end

local function KeepTarget(inst, target)
    if (inst.components.follower and inst.components.follower.leader) then
        return true
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    local targetPos = Vector3(target.Transform:GetWorldPosition() )
    return homePos and distsq(homePos, targetPos) < MAX_CHASEAWAY_DIST*MAX_CHASEAWAY_DIST
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and attacker:HasTag("chess") then return end
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("chess") end, MAX_TARGET_SHARES)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("sky_octopus")
	inst.AnimState:SetBuild("sky_octopus")
	inst.AnimState:PlayAnimation("idle", true)
	inst.Transform:SetFourFaced()

	inst:AddComponent("inspectable")

    local brain = require "brains/octocopterbrain"
    inst:SetBrain(brain)

    inst:AddTag("epic")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetAttackPeriod(TUNING.KNIGHT_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 5
    inst.components.locomotor.directdrive = true
    
    inst:SetStateGraph("SGoctocopter")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000)	

    inst:AddComponent("knownlocations")
    
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()) ) end)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("octocopter.tex") 

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

    inst:ListenForEvent("death", function(inst)
        SpawnPrefab("octocopter_wreckage").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end)

	return inst
end

return Prefab ("common/inventory/octocopter", fn, assets, prefabs) 
