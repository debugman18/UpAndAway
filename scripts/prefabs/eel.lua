local brain = require "brains/eelbrain"

local assets=
{
	Asset("ANIM", "anim/tentacle.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
}

local prefabs =
{
    "monstermeat",
}

local function retargetfn(inst)
    return FindEntity(inst, 20, function(guy) 
        if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
            return (guy:HasTag("character") or guy:HasTag("monster") or guy:HasTag("animal")) and not guy:HasTag("prey") and not (guy.prefab == inst.prefab)
        end
    end)
end

local function shouldKeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        return distsq < 30*30
    else
        return false
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.Physics:SetCylinder(0.25,2)
	trans:SetScale(0.5, 0.5, 0.5)
    
    anim:SetBank("tentacle")
    anim:SetBuild("tentacle")
    anim:PlayAnimation("idle")
 	inst.entity:AddSoundEmitter()

    inst:AddTag("monster")    
    inst:AddTag("hostile")
    inst:AddTag("wet")
    --inst:AddTag("WORM_DANGER")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetRange(2)
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(GetRandomWithVariance(2, 0.5), retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    
    MakeLargeFreezableCharacter(inst)
    
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
       
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"monstermeat", "monstermeat"})
	
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 9	
    
    inst:SetStateGraph("SGeel")
	inst:SetBrain(brain)
	
    return inst
end

return Prefab( "marsh/monsters/eel", fn, assets, prefabs) 
