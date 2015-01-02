BindGlobal()

local prefabs = 
{
    "bee_marshmallow",
    "marshmallow",
}

local assets =
{
    Asset("ANIM", "anim/hive_marshmallow.zip"),
    Asset("SOUND", "sound/bee.fsb"),
}


local function OnEntityWake(inst)
    --inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function StartSpawningFn(inst)
    local fn = function(world)
        inst.components.childspawner:StartSpawning()
    end
    return fn
end

local function StopSpawningFn(inst)
    local fn = function(world)
        if inst.components.childspawner then
            inst.components.childspawner:StopSpawning()
        end
    end
    return fn
end

local function OnIgnite(inst)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
        inst:RemoveComponent("childspawner")
    end
    --inst.SoundEmitter:KillSound("loop")
    DefaultBurnFn(inst)
end

local function OnKilled(inst)
    inst:RemoveComponent("childspawner")
    inst.AnimState:PlayAnimation("cocoon_dead", true)
    inst.Physics:ClearCollisionMask()
    
    --inst.SoundEmitter:KillSound("loop")
    
    inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_destroy")
    inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
end


local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
    MakeObstaclePhysics(inst, .5)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "beehive.png" )

    anim:SetBank("beehive")
    anim:SetBuild("hive_marshmallow")
    anim:PlayAnimation("cocoon_small", true)

    inst:AddTag("structure")

    MakeSnowCovered(inst)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    -------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    -------------------
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "bee_marshmallow"
    inst.components.childspawner:SetRegenPeriod(TUNING.BEEHIVE_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.BEEHIVE_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(TUNING.BEEHIVE_BEES)
    if GetPseudoSeasonManager() and GetPseudoSeasonManager():IsSummer() then
        inst.components.childspawner:StartSpawning()
    end
    
    ---------------------  
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"marshmallow","marshmallow","marshmallow","marshmallow"})
    ---------------------  

    ---------------------        
    MakeLargeBurnable(inst)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    -------------------
    
    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(
        function(inst, attacker, damage) 
            if inst.components.childspawner then
                inst.components.childspawner:ReleaseAllChildren(attacker, "bee_marshmallow")
            end
            if not inst.components.health:IsDead() then
                inst.SoundEmitter:PlaySound("dontstarve/bee/beehive_hit")
                inst.AnimState:PlayAnimation("cocoon_small_hit")
                inst.AnimState:PushAnimation("cocoon_small", true)
            end
        end)
    inst:ListenForEvent("death", OnKilled)
    
    ---------------------       
    MakeLargePropagator(inst)
    
    ---------------------

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("hive_marshmallow.tex")   
    
    inst:AddComponent("inspectable")
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
    
    inst.Transform:SetScale(2.0, 1.7, 2.0)
    
    return inst
end

return Prefab( "forest/monsters/hive_marshmallow", fn, assets, prefabs ) 

