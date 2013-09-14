--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
    -- always have to declare what assets you’re loading and using
    --Asset("ANIM", "anim/testcritter.zip"),  -- same name as the .scml
	--Asset("ANIM", "anim/antlion.zip"),  -- same name as the .scml
	Asset("ANIM", "anim/duckraptor.zip"),  -- same name as the .scml

    Asset("ANIM", "anim/perd_basic.zip"),    
    Asset("SOUND", "sound/perd.fsb"),    
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter() 
    shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(.8, 1, 1.2)
    
    MakeCharacterPhysics(inst, 50, .5)    
    anim:SetBank("perd") -- name of the animation root
    anim:SetBuild("duckraptor")  -- name of the file 

    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor.walkspeed = 4
    
    --inst:SetStateGraph(SGgoose")
    inst:SetStateGraph("SGperd")
    --anim:Hide("hat")

    inst:AddTag("character")

    inst:AddComponent("homeseeker")
    --local brain = require "brains/goosebrain"
    local brain = require "brains/perdbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)    --always wake up if we're asleep

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(40)
    inst.components.combat:SetDefaultDamage(TUNING.PERD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PERD_ATTACK_PERIOD)

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