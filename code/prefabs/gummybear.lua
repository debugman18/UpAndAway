BindGlobal()

local assets =
{
	Asset("ANIM", "anim/gummybear_naughty.zip"),
	Asset("ANIM", "anim/gummybear_nice.zip"),
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("ANIM", "anim/pig_build.zip"),
	Asset("ANIM", "anim/pigspotted_build.zip"),
	Asset("ANIM", "anim/pig_guard_build.zip"),
	Asset("ANIM", "anim/werepig_build.zip"),
	Asset("ANIM", "anim/werepig_basic.zip"),
	Asset("ANIM", "anim/werepig_actions.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "nightmarefuel",
}

local function OnNewTarget(inst, data)
        --print(inst, "OnNewTarget", data.target)
    inst.components.combat:ShareTarget(inst.components.combat.target, 30, function(dude) return dude:HasTag("gumbear") and not dude.components.health:IsDead() end, 12)
end

local function retargetfn(inst)
    local entity = FindEntity(inst, 10, function(guy) 
		return inst.components.combat:CanTarget(guy) and not guy:HasTag("gumbear")
    end)
    return entity
end


local function CalcSanityAura(inst, observer)
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_SMALL
	end	
	return 0
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("gumbear") and not dude.components.health:IsDead() end, 6)
end

    
local function commonfn()
	local inst = CreateEntity()

        inst:AddComponent("health")

    return inst
end


local function bear()
	local inst = commonfn()
	    local trans = inst.entity:AddTransform()
	    local anim = inst.entity:AddAnimState()
        local physics = inst.entity:AddPhysics()
	    local sound = inst.entity:AddSoundEmitter()
        inst.Transform:SetFourFaced()
 
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )    	
	inst.Transform:SetScale(0.9, 0.9, 0.9)

    MakeCharacterPhysics(inst, 50, .5)

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("gummybear_naughty")
    inst.AnimState:PlayAnimation("idle", true)

    local color1 = 0.1 + math.random() * 0.9
    local color2 = 0.1 + math.random() * 0.9
    local color3 = 0.1 + math.random() * 0.9
    inst.AnimState:SetMultColour(color1, color2, color3, 0.75)    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 5 
    inst.components.locomotor.walkspeed = 2  


    inst:AddComponent("follower")


    inst:AddComponent("inventory")
    
    ------------------------------------------

    inst:AddComponent("lootdropper")

    ------------------------------------------

    inst:AddComponent("knownlocations")

        inst:AddTag("monster")
	    inst:AddTag("hostile")
       inst:AddTag("cuddly")
       inst:AddTag("gumbear")
    inst:AddTag("wet")

        inst:AddTag("notraptrigger")

    inst:AddComponent("inspectable")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.GUMMYBEAR_NAMES
    inst.components.named:PickNewName()

      local brain = require "brains/gummybearbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGgummybear")
        
	    inst:AddComponent("sanityaura")
	    inst.components.sanityaura.aurafn = CalcSanityAura
        
        inst.components.health:SetMaxHealth(360)

    inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
	inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(34)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2)
        inst.components.combat:SetRetargetFunction(3, retargetfn)

        inst:ListenForEvent("attacked", OnAttacked)	

    inst:ListenForEvent("losttarget", function(inst) 
       inst:AddTag("cuddly")
    end)
    inst:ListenForEvent("giveuptarget", function(inst) 
       inst:AddTag("cuddly")
    end)
    inst:ListenForEvent("newcombattarget", function(inst, data) 
        if data.target ~= nil then
       inst:RemoveTag("cuddly")
	OnNewTarget(inst)
        end
    end)

	inst:DoPeriodicTask(1/100, function()
	if not inst.components.combat.target then
       inst:AddTag("cuddly")
    inst.AnimState:SetBuild("gummybear_nice")
		else
           inst:RemoveTag("cuddly")
    inst.AnimState:SetBuild("gummybear_naughty")
		end
	end) 

        return inst
    end


local function rainbow()
	local inst = commonfn()

    	inst.entity:AddTransform()
    	inst.entity:AddAnimState()

    inst.AnimState:SetBank("collapse")
    inst.AnimState:SetBuild("structure_collapse_fx")
    inst:AddTag("NOCLICK")

    inst.AnimState:PlayAnimation("collapse_large")

        inst:AddTag("FX")
        inst.persists = false
        inst:ListenForEvent("animover", function() inst:Remove() end)

    inst:DoTaskInTime(0, function() inst.AnimState:SetMultColour(0.7, 0.3, 0.3, 1)  
	end)

    inst:DoTaskInTime(0.25, function() inst.AnimState:SetMultColour(0.7, 0.7, 0.3, 1)  
	end)

    inst:DoTaskInTime(0.5, function() inst.AnimState:SetMultColour(0.3, 0.7, 0.3, 1)  
	end)

    inst:DoTaskInTime(0.75, function() inst.AnimState:SetMultColour(0.3, 0.7, 0.7, 1)  
	end)

    inst:DoTaskInTime(1, function() inst.AnimState:SetMultColour(0.3, 0.3, 0.7, 1)  
	end)

	return inst
end

local function KeepTarget(isnt, target)
    return true
end

return {
    Prefab( "common/monsters/gummybear", bear, assets, prefabs),
	Prefab( "common/monsters/gummybear_rainbow", rainbow, assets, prefabs) 
}
