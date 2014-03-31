BindGlobal()

local brain = require "brains/eelbrain"

local assets=
{
	Asset("ANIM", "anim/vine.zip"),
    Asset("SOUND", "sound/tentacle.fsb"),
}

local prefabs =
{
    "beanstalk_chunk",
}

local function Retarget(inst)
    local newtarget = FindEntity(inst, 20, function(guy)
            return (guy:HasTag("character") or guy:HasTag("monster"))
                   and not (inst.components.follower and inst.components.follower.leader == guy)
                   and not guy:HasTag("eel")
                   and not guy:HasTag("beanmonster")
                   and inst.components.combat:CanTarget(guy)
    end)
    return newtarget
end

local function KeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
		return distsq(Vector3(GetPlayer().Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < 30*30
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddPhysics()
    inst.Physics:SetCylinder(0.50,2)
	trans:SetScale(.6, .7, 0.5)
    MakeGhostPhysics(inst, 1, .5)
	
    anim:SetBank("tentacle")
    anim:SetBuild("vine")
    anim:PlayAnimation("idle")
 	inst.entity:AddSoundEmitter()

    inst:AddTag("monster")    
    inst:AddTag("hostile")
    inst:AddTag("eel")

    inst:AddTag("beanmonster")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(15)
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetRange(3)
    inst.components.combat:SetDefaultDamage(10)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)	
    
    MakeLargeFreezableCharacter(inst)
    
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
       
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"beanstalk_chunk", "beanstalk_chunk"})
	
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 8.5
	inst.components.locomotor.runspeed = 8.5
	inst.components.locomotor.directdrive = true
    
    inst:SetStateGraph("SGeel")
	inst:SetBrain(brain)
	
    return inst
end

return Prefab("cloudrealm/monsters/vine", fn, assets, prefabs) 
