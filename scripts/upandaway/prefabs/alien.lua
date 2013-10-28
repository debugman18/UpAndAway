--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local prefabs =
{
    "nightmarefuel",
}

local function retargetfn(inst)
    local entity = FindEntity(inst, TUNING.SHADOWCREATURE_TARGET_DIST, function(guy) 
		return guy:HasTag("player") and inst.components.combat:CanTarget(guy)
    end)
    return entity
end

local function onkilledbyother(inst, attacker)
	if attacker and attacker.components.sanity then
		attacker.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_SMALL)
	end
end

local loot = {"nightmarefuel"}

local function CalcSanityAura(inst, observer)
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_LARGE
	end	
	return 0
end

local function canbeattackedfn(inst, attacker)
	return inst.components.combat.target ~= nil or
		(attacker.components.sanity)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("shadowcreature") and not dude.components.health:IsDead() end, 1)
end

    local assets=
    {
	    Asset("ANIM", "anim/shadow_insanity1_basic.zip"),
    }
    
    local sounds = 
    {
        attack = "dontstarve/sanity/creature1/attack",
        attack_grunt = "dontstarve/sanity/creature1/attack_grunt",
        death = "dontstarve/sanity/creature1/die",
        idle = "dontstarve/sanity/creature1/idle",
        taunt = "dontstarve/sanity/creature1/taunt",
        appear = "dontstarve/sanity/creature1/appear",
        disappear = "dontstarve/sanity/creature1/dissappear",
    }

    local function fn()
	    local inst = CreateEntity()
	    local trans = inst.entity:AddTransform()
	    local anim = inst.entity:AddAnimState()
        local physics = inst.entity:AddPhysics()
	    local sound = inst.entity:AddSoundEmitter()
        inst.Transform:SetFourFaced()
        inst:AddTag("shadowcreature")
    	
        MakeCharacterPhysics(inst, 10, 1.5)
        RemovePhysicsColliders(inst)
	    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	    inst.Physics:CollidesWith(COLLISION.SANITY)
	    --inst.Physics:CollidesWith(COLLISION.WORLD)
        
         
        anim:SetBank("shadowcreature1")
        anim:SetBuild("shadow_insanity1_basic")
        anim:PlayAnimation("idle_loop")
        anim:SetMultColour(1, 1, 1, 0.5)
        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor.walkspeed = 5
        inst.sounds = sounds
        inst:SetStateGraph("SGshadowcreature")

        inst:AddTag("monster")
	    inst:AddTag("hostile")
        inst:AddTag("shadow")

        local brain = require "brains/shadowcreaturebrain"
        inst:SetBrain(brain)
        
	    inst:AddComponent("sanityaura")
	    inst.components.sanityaura.aurafn = CalcSanityAura
        
        --inst:AddComponent("transparentonsanity")
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(20)
        
		--inst.sanityreward = data.sanityreward
		
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(10)
        inst.components.combat:SetAttackPeriod(5)
        inst.components.combat:SetRetargetFunction(3, retargetfn)
        inst.components.combat.onkilledbyother = onkilledbyother
        inst.components.combat.canbeattackedfn = canbeattackedfn

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loot)
        inst.components.lootdropper:AddChanceLoot("nightmarefuel", 0.5)
        
        inst:ListenForEvent("attacked", OnAttacked)

        return inst
    end
        
    return Prefab("monsters/alien", fn, assets, prefabs)
