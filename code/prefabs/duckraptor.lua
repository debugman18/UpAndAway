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
    inst.Transform:SetScale(1.6, 1.6, 1.6)
    anim:SetMultColour(.9, .9, .9, .6)
    anim:SetBloomEffectHandle("shaders/anim.ksh")
    
    MakeCharacterPhysics(inst, 50, .5)    
    anim:SetBank("perd") -- name of the animation root
    anim:SetBuild("duckraptor")  -- name of the file 

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 8
    inst.components.locomotor.walkspeed = 5
    
    --inst:SetStateGraph(SGgoose")
    inst:SetStateGraph("SGperd")
    --anim:Hide("hat")

    inst:AddTag("character")

    inst:AddComponent("homeseeker")
    --local brain = require "brains/goosebrain"
    local brain = require "brains/shadowcreaturebrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)    --always wake up if we're asleep
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(3, retargetfn)    
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetAttackPeriod(.8)

    inst:AddComponent("lootdropper")
    --inst.components.lootdropper:SetLoot(loot)
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")   
    
    --inst:AddComponent("staticchargeable")
    --inst.components.staticchargeable:SetOnChargeFn(set_eggdrop)
	
    return inst
end

return Prefab("common/duckraptor", fn, assets) 