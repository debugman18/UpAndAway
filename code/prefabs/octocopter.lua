BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/sky_octopus.zip"),
}

local prefabs = CFG.OCTOCOPTER.PREFABS

SetSharedLootTable( "octocopter", CFG.OCTOCOPTER.LOOT)

local PART_NAMES = {
    "part1", --Rotor Blade
    "part2", --Rotor Plate
    "part3", --Rotor Hub
}

for i, partname in ipairs(PART_NAMES) do
    table.insert(assets, Asset("ANIM", "anim/octocopter"..partname..".zip"))
    table.insert(assets, Asset("ATLAS", inventoryimage_atlas("octocopter"..partname)))
    table.insert(assets, Asset("IMAGE", inventoryimage_texture("octocopter"..partname)))
end

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

local function MakeOctocopter()

    local FULL_PART_NAMES = {}
    for i, partname in ipairs(PART_NAMES) do
        FULL_PART_NAMES[i] = "octocopter"..partname
    end

    local FULL_PART_NAME_SET = {}
    for i, v in ipairs(FULL_PART_NAMES) do
        FULL_PART_NAME_SET[v] = true
    end

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        MakeGhostPhysics(inst, 1, .5)

        inst.AnimState:SetBank("sky_octopus")
        inst.AnimState:SetBuild("sky_octopus")
        inst.AnimState:PlayAnimation("idle", true)
        inst.Transform:SetFourFaced()

        local FULL_PART_NAMES = {}
        for i, partname in ipairs(PART_NAMES) do
            FULL_PART_NAMES[i] = "octocopter"..partname
        end

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
        inst.components.combat:SetAreaDamage(CFG.OCTOCOPTER.AREA_RANGE, CFG.OCTOCOPTER.AREA_DAMAGE)

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
        inst.components.lootdropper:SetChanceLootTable("octocopter")    

        inst:ListenForEvent("death", function(inst)

            --We don't want to spawn the wreckage anymore.
            --Game.Move(SpawnPrefab("octocopter_wreckage"), inst)

            GetWorld():PushEvent("octocoptercrash")
        end)

        return inst

    end

    return Prefab ("cloudrealm/octocopter", fn, assets, prefabs) 
end

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

local ret = {MakeOctocopter()}

for i, partname in ipairs(PART_NAMES) do
    table.insert(ret, MakeOctocopterPart(partname))
    table.insert(ret, MakeOctocopterPartSpawner(partname))
end

return ret
