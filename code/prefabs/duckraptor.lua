BindGlobal()

local assets=
{
    -- always have to declare what assets you’re loading and using
    --Asset("ANIM", "anim/testcritter.zip"),  -- same name as the .scml
    --Asset("ANIM", "anim/antlion.zip"),  -- same name as the .scml
    Asset("ANIM", "anim/duckraptor.zip"),  -- same name as the .scml

    Asset("ANIM", "anim/perd_basic.zip"),    
    Asset("SOUND", "sound/perd.fsb"),    
}

local function onsave(inst, data)
    if inst.duckraptorsize then
        data.duckraptorsize = inst.duckraptorsize
    end
end

local function onload(inst, data)
    if data and data.duckraptorsize then
        inst.duckraptorsize = data.duckraptorsize
        local duckraptorsize = inst.duckraptorsize
        inst.Transform:SetScale(duckraptorsize, duckraptorsize, duckraptorsize)
    end
end

local function CalcSanityAura(inst, observer)
    if inst.components.combat.target then
        return (-TUNING.SANITYAURA_LARGE*2)
    end 
    return -TUNING.SANITYAURA_LARGE
end

local function retargetfn(inst)
    local entity = FindEntity(inst, TUNING.SHADOWCREATURE_TARGET_DIST, function(guy) 
        return guy:HasTag("player") and inst.components.combat:CanTarget(guy)
    end)
    return entity
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("shadowcreature") and not dude.components.health:IsDead() end, 1)
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter() 

    shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()
    --inst.Transform:SetScale(.8, 1, 1.2)
    inst.duckraptorsize = 1.6
    local duckraptorsize = inst.duckraptorsize
    inst.Transform:SetScale(duckraptorsize, duckraptorsize, duckraptorsize)
    anim:SetMultColour(.9, .9, .9, .6)
    anim:SetBloomEffectHandle("shaders/anim.ksh")
    
    MakeCharacterPhysics(inst, 50, .5)    
    anim:SetBank("perd") -- name of the animation root
    anim:SetBuild("duckraptor")  -- name of the file 

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 7
    inst.components.locomotor.walkspeed = 7
    
    --inst:SetStateGraph(SGgoose")
    inst:SetStateGraph("SGduckraptor")
    --anim:Hide("hat")

    inst:AddTag("character")

    inst:AddComponent("homeseeker")
    --local brain = require "brains/goosebrain"
    local brain = require "brains/duckraptorbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)    --always wake up if we're asleep
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    local attackperiod = 1

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(3, retargetfn)    
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(attackperiod)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetLoot(loot)
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")   
    
    inst:AddTag("shadowcreature")
    inst:AddTag("notraptrigger")

    inst.OnLoad = onload
    inst.OnSave = onsave

    --inst:AddComponent("staticchargeable")
    --inst.components.staticchargeable:SetOnChargeFn(set_eggdrop)
    
    return inst
end

return Prefab("common/duckraptor", fn, assets) 