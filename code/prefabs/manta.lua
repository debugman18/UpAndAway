BindGlobal()

local assets =
{
        Asset("ANIM", "anim/crow.zip"),
        Asset("ANIM", "anim/crow_build.zip"),
        Asset("SOUND", "sound/birds.fsb"),
}

local prefabs = {
    "cloud_jelly",
    "manta_leather",
}

local loot = {
    "manta_leather",
    "manta_leather",
}

local function OnHit(inst, owner, target)
    local pt = Vector3(inst.Transform:GetWorldPosition())
    inst:Remove()
end	

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    --inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local anim = inst.entity:AddAnimState()
    anim:SetBank("crow")
    anim:SetBuild("crow_build")
    anim:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

        
    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    --inst:SetStateGraph("SGbird")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(30)
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cloud_jelly")
    
    --local brain = require "brains/beebrain"
    --inst:SetBrain(brain)    

    inst:AddComponent("inspectable")
    
    --Mantas will sail overhead. I think the only way to attack one would be to use a ranged weapon. 
    --If attacked, they will go offscreen and come back lower, to sail past the player.
        
    return inst
end

return Prefab ("common/monsters/manta", fn, assets) 
