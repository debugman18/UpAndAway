BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/sky_octopus.zip"),
}

local prefabs = CFG.OCTOCOPTER.PREFABS

SetSharedLootTable( 'octocopter', CFG.OCTOCOPTER.LOOT)

local function Retarget(inst)

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > CFG.OCTOCOPTER.TARGET_DIST*CFG.OCTOCOPTER.TARGET_DIST) and not
    (inst.components.follower and inst.components.follower.leader) then
        return
    end
    
    local newtarget = FindEntity(inst, CFG.OCTOCOPTER.TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
        and not guy:HasTag("owl") 
        and not guy:HasTag("beanmonster")
        and not guy:HasTag("cloudneutral")
    end)

    return newtarget
end

local function KeepTarget(inst, target)
    if (inst.components.follower and inst.components.follower.leader) then
        return true
    end

    local homePos = inst.components.knownlocations:GetLocation("home")
    local targetPos = Vector3(target.Transform:GetWorldPosition() )
    return homePos and distsq(homePos, targetPos) < CFG.OCTOCOPTER.MAX_CHASEAWAY_DIST*CFG.OCTOCOPTER.MAX_CHASEAWAY_DIST
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and attacker:HasTag("octocopter") then return end
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, CFG.OCTOCOPTER.SHARE_TARGET_DIST, function(dude) return dude:HasTag("octocopter") end, CFG.OCTOCOPTER.MAX_TARGET_SHARES)
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeGhostPhysics(inst, 1, .5)

    inst.AnimState:SetBank("sky_octopus")
    inst.AnimState:SetBuild("sky_octopus")
    inst.AnimState:PlayAnimation("idle", true)
    inst.Transform:SetFourFaced()


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    local brain = require "brains/octocopterbrain"
    inst:SetBrain(brain)

    inst:AddTag("epic")
    inst:AddTag("monster")
    inst:AddTag("cloudneutral")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(CFG.OCTOCOPTER.DAMAGE)
    inst.components.combat.min_attack_period = CFG.OCTOCOPTER.ATTACK_PERIOD
    inst.components.combat:SetAttackPeriod(CFG.OCTOCOPTER.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat:SetRange(CFG.OCTOCOPTER.RANGE)
    inst.components.combat:SetAreaDamage(CFG.OCTOCOPTER.RANGE, CFG.OCTOCOPTER.AREADAMAGE)

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 4
    inst.components.locomotor.directdrive = true


    inst.Transform:SetScale(1.4, 1.4, 1.4)
    
    inst:SetStateGraph("SGoctocopter")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.OCTOCOPTER.HEALTH)  

    inst:AddComponent("knownlocations")
    
    inst:DoTaskInTime(1*FRAMES, function() inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()) ) end)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("octocopter.tex") 

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('octocopter')    

    inst:ListenForEvent("death", function(inst)
        Game.Move(SpawnPrefab("octocopter_wreckage"), inst)
        GetWorld():PushEvent("octocoptercrash")
    end)

    return inst
end

return Prefab ("common/inventory/octocopter", fn, assets, prefabs) 
