BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/owl.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("SOUND", "sound/merm.fsb"),
}

local prefabs = CFG.OWL.PREFABS

SetSharedLootTable( "owl", CFG.OWL.LOOT) 

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function RetargetFn(inst, target)
    inst:DoTaskInTime(0, function(inst, target)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 15, "owl_crystal")
        for k,v in pairs(ents) do
            if v and v:HasTag("owl_crystal") then
                local rock = v
                --print(rock)
                if inst.components.homeseeker then
                    inst.components.homeseeker:SetHome(rock)
                end    
            end    
        end   
    end)     

    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, CFG.OWL.DEFEND_DIST, function(guy)
        return guy.components.health 
        and not guy:HasTag("owl") 
        and not guy:HasTag("epic")
        and not guy:HasTag("beanmonster")
        and not guy:HasTag("beanprotector")
        and not guy:HasTag("cloudneutral")
        and not guy:HasTag("beanlet")
    end)
    return invader
end

local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)     
end

local function OnAttacked(inst, data)
    inst.components.talker:Say("Whoo!", 2, noanim)
    local attacker = data and data.attacker
    if attacker and inst.components.combat:CanTarget(attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = CFG.OWL.MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= CFG.OWL.SHARE_TARGET_DIST*CFG.OWL.SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, CFG.OWL.SHARE_TARGET_DIST, function(dude)
                return dude.components.homeseeker
                       and dude.components.homeseeker.home
                       and dude.components.homeseeker.home == home
            end, targetshares)
        end
    end
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(CFG.OWL.SCALE, CFG.OWL.SCALE, CFG.OWL.SCALE)

    MakeCharacterPhysics(inst, 50, .5)

    anim:SetBank("pigman")
    anim:SetBuild("owl")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = CFG.OWL.RUNSPEED
    inst.components.locomotor.walkspeed = CFG.OWL.WALKSPEED
    
    inst:SetStateGraph("SGowl")
    anim:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("owl")
    inst:AddTag("cloudmonster")

    local brain = require "brains/owlbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()

    --local home = FindEntity(inst, 6, function(ent) end, {"crystal_relic"})

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(CFG.OWL.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.OWL.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.OWL.HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("owl")
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("named")
    inst.components.named:SetName("Strix")

    inst:AddComponent("homeseeker")
    inst:AddComponent("knownlocations")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0,-400,0)  
    inst.components.talker:StopIgnoringAll()  

    inst:DoPeriodicTask(CFG.OWL.WHO_INTERVAL, function() inst.components.talker:Say("Whoo?", CFG.OWL.WHO_INTERVAL, noanim) end, 12)
    inst:DoPeriodicTask(CFG.OWL.WHO_INTERVAL, function() inst.components.talker:ShutUp() end, 12)

    return inst
end

return Prefab("cloudrealm/animals/owl", fn, assets, prefabs) 
