BindGlobal()

local assets =
{
    Asset("ANIM", "anim/skytrap.zip"),
}

local prefabs =
{
    "ambrosia",
    "cloud_jelly",
    "cloud_cotton",
    "beanstalk_chunk",    
}

local loot = {
    "beanstalk_chunk",
    "beanstalk_chunk",
}

local rareloot = {
    "ambrosia",
    "cloud_jelly",
    "cloud_cotton",  
    "cloud_cotton",  
    "beanstalk_chunk",
    "beanstalk_chunk", 
}

local function retargetfn(inst)
    return FindEntity(inst, 2, function(guy) 
        if guy.components.combat and guy.components.health and not guy.components.health:IsDead() then
            return (
				guy:HasTag("character")
				or guy:HasTag("monster")
				or guy:HasTag("animal")
				or guy:HasTag("prey")
			) and not (
				guy:HasTag("cloudneutral")
				or guy:HasTag("cloudmonster")
			)
        end
    end)
end

local function shouldKeepTarget(inst, target)
    if target and target:IsValid() and target.components.health and not target.components.health:IsDead() then
        local distsq = target:GetDistanceSqToInst(inst)
        
        return distsq < 2*2
    else
        return false
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    MakeCharacterPhysics(inst, 0, .5)

    inst.Transform:SetFourFaced()

    inst.AnimState:SetBank("skytrap")
    inst.AnimState:SetBuild("skytrap")
    inst.AnimState:PushAnimation("idle")

	-- This means they're neutral to the cloud realm, not the player.
	inst:AddTag("cloudneutral")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")    

    inst:AddComponent("combat")
    inst.components.combat:SetAttackPeriod(TUNING.EYEPLANT_ATTACK_PERIOD)
    inst.components.combat:SetRange(4)
    inst.components.combat:SetRetargetFunction(0.2, retargetfn)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetDefaultDamage(40) 

    inst:AddComponent("lootdropper")
    if math.random(1,8) == 1 then
        inst.components.lootdropper:SetLoot(rareloot)
    else inst.components.lootdropper:SetLoot(loot) end    

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(50)    

    inst:ListenForEvent("newcombattarget", function(inst, data)
        if data.target and not inst.sg:HasStateTag("attack") and not inst.sg:HasStateTag("hit") and not inst.components.health:IsDead() then
            inst.sg:GoToState("attack")
        end
    end)

    inst:SetStateGraph("SGskytrap")    

    return inst
end

return Prefab ("common/inventory/skytrap", fn, assets, prefabs) 
