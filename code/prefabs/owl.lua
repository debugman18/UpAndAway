BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
	Asset("ANIM", "anim/merm_build.zip"),
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("SOUND", "sound/merm.fsb"),
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

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function worshiprocks(inst)
    local rock = _G.GetClosestInstWithTag("crystal", inst, 20)
end    

local function ontalk(inst, script)
    inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, CFG.OWL.DEFEND_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("owl")
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
        local targetshares = MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
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

    MakeCharacterPhysics(inst, 50, .5)

    anim:SetBank("pigman")
    anim:SetBuild("merm_build")
    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor.walkspeed = 8
    
    inst:SetStateGraph("SGowl")
    anim:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("owl")

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
    inst.components.lootdropper:SetLoot(loot)
    
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

    inst:DoPeriodicTask(5, function() inst.components.talker:Say("Whoo?", 3, noanim) end, 12)
    inst:DoPeriodicTask(5, function() inst.components.talker:ShutUp() end, 12)

    --inst:DoPeriodicTask(1, worshiprocks(inst), 0)
    
    return inst
end

return Prefab("cloudrealm/animals/owl", fn, assets, prefabs) 
