BindGlobal()

local CFG_WN = TheMod:GetConfig().WEAVERNEST

local prefabs =
{
    --"robin",
    --"robin_winter",
    --"crow",
    "twigs",
    "cutgrass",
    "weaver_bird"
}

local assets =
{
    Asset("ANIM", "anim/weavernest.zip"),
    --Asset("SOUND", "sound/spider.fsb"),
}


local function SetStage(inst, stage)
    if stage <= 3 then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_grow")
        if inst.components.childspawner then
            inst.components.childspawner:SetMaxChildren(CFG_WN.MAXCHILDREN[stage])
        end
        if inst.components.health then
            inst.components.health:SetMaxHealth(CFG_WN.HEALTH[stage])
        end
    
        inst.AnimState:PlayAnimation(inst.anims.init)
        inst.AnimState:PushAnimation(inst.anims.idle, true)
    end
    
    --inst.data.stage = stage -- track here, as growable component may go away
end

local function SetSmall(inst)
    inst.anims = {
        hit="idle_1", 
        idle="idle_1", 
        init="idle_1", 
        freeze="idle_1", 
        thaw="idle_1",
    }
    SetStage(inst, 1)
    inst.components.lootdropper:SetLoot(CFG_WN.LOOT[1])

    if inst.components.burnable then
        inst.components.burnable:SetFXLevel(3)
        inst.components.burnable:SetBurnTime(0)
    end

    if inst.components.freezable then
        inst.components.freezable:SetShatterFXLevel(3)
        inst.components.freezable:SetResistance(6)
    end

    --inst.GroundCreepEntity:SetRadius( 5 )
end


local function SetMedium(inst)
    inst.anims = {
        hit="idle_2", 
        idle="idle_2", 
        init="idle_2", 
        freeze="idle_2", 
        thaw="idle_2",
    }
    SetStage(inst, 2)
    inst.components.lootdropper:SetLoot(CFG_WN.LOOT[2])
	
    if inst.components.burnable then
        inst.components.burnable:SetFXLevel(3)
        inst.components.burnable:SetBurnTime(0)
    end

    if inst.components.freezable then
        inst.components.freezable:SetShatterFXLevel(4)
        inst.components.freezable:SetResistance(6)
    end

    --inst.GroundCreepEntity:SetRadius( 9 )
end

local function SetLarge(inst)
    inst.anims = {
        hit="idle_3", 
        idle="idle_3", 
        init="idle_3", 
        freeze="idle_3", 
        thaw="idle_3",
    }
    SetStage(inst, 3)
    inst.components.lootdropper:SetLoot(CFG_WN.LOOT[3])

    if inst.components.burnable then
        inst.components.burnable:SetFXLevel(4)
        inst.components.burnable:SetBurnTime(0)
    end

    if inst.components.freezable then
        inst.components.freezable:SetShatterFXLevel(5)
        inst.components.freezable:SetResistance(6)
    end

    --inst.GroundCreepEntity:SetRadius( 9 )
end

local function onspawnbird(inst, robin)
    print("Bird spawned from weaver nest.")
end

local function OnKilled(inst)
    inst.AnimState:PlayAnimation("death")
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
    inst.Physics:ClearCollisionMask()

    inst.SoundEmitter:KillSound("loop")

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")
    inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
end

local function SpawnDefenders(inst, attacker)
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner then
            inst.components.childspawner:ReleaseAllChildren()
        end
    end
end

local function SpawnInvestigators(inst, data)
    if not inst.components.health:IsDead() and not (inst.components.freezable and inst.components.freezable:IsFrozen()) then
        inst.AnimState:PlayAnimation(inst.anims.hit)
        inst.AnimState:PushAnimation(inst.anims.idle)
        if inst.components.childspawner then
            local max_per_stage = {1, 2, 3}
            local num_to_release = math.min( max_per_stage[inst.components.growable.stage] or 1, inst.components.childspawner.childreninside)
            local num_investigators = inst.components.childspawner:CountChildrenOutside(function(child)
                if child.components.knownlocations then
                    return child.components.knownlocations:GetLocation("investigate") ~= nil
                end
            end)
            num_to_release = num_to_release - num_investigators
            for k = 1,num_to_release do
                local robin = inst.components.childspawner:SpawnChild()
                if robin and data and data.target and robin.components.knownlocations then
                    robin.components.knownlocations:RememberLocation("investigate", Vector3(data.target.Transform:GetWorldPosition() ) )
                end
            end
        end
    end
end

local function StartSpawning(inst)
    if inst.components.childspawner then
        local frozen = (inst.components.freezable and inst.components.freezable:IsFrozen())
        if not frozen and not GetPseudoClock():IsDay() then
            inst.components.childspawner:StartSpawning()
        end
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnIgnite(inst)
    if inst.components.childspawner then
        SpawnDefenders(inst)
        inst:RemoveComponent("childspawner")
    end
    inst.SoundEmitter:KillSound("loop")
    DefaultBurnFn(inst)
end

local function OnBurnt(inst)

end

-- freezable start

local function OnFreeze(inst)
    print(inst, "OnFreeze")
    inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
    inst.AnimState:PlayAnimation(inst.anims.freeze, true)
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")

    StopSpawning(inst)

    if inst.components.growable then
        inst.components.growable:Pause()
    end
end

local function OnThaw(inst)
    print(inst, "OnThaw")
    inst.AnimState:PlayAnimation(inst.anims.thaw, true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnUnFreeze(inst)
    print(inst, "OnUnFreeze")
    inst.AnimState:PlayAnimation(inst.anims.idle, true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")

    StartSpawning(inst)

    if inst.components.growable then
        inst.components.growable:Resume()
    end
end

-- freezable end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spidernest_LP", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function GetSmallGrowTime(inst)
    return CFG_WN.GROWTIME[1] + math.random() * CFG_WN.GROWTIME[1]
end

local function GetMedGrowTime(inst)
    return CFG_WN.GROWTIME[2] + math.random() * CFG_WN.GROWTIME[2]
end

local growth_stages = {
    {name="small", time = GetSmallGrowTime, fn = SetSmall },
    {name="med", time = GetMedGrowTime , fn = SetMedium },
    {name="large", fn = SetLarge },
}

local function MakeWeaverNestFn(den_level)
    local weavernest_fn = function(Sim)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        --inst.entity:AddGroundCreepEntity()

        inst.entity:AddSoundEmitter()

        --inst.data = {}

        MakeObstaclePhysics(inst, .5)

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("weavernest.tex")

        anim:SetBank("weavernest")
        anim:SetBuild("weavernest")
        anim:PlayAnimation("idle_1", true)

        inst:AddTag("structure") --wouldn't this confuse creatures such as deerclops? -Mobb
        inst:AddTag("weavernest")
        inst:AddTag("hive")

        MakeSnowCovered(inst) --(as of now) not supported by anim file


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------


        -------------------
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(50)

        -------------------
        inst:AddComponent("childspawner")
        inst.components.childspawner.childname = "weaver_bird"
        inst.components.childspawner:SetRegenPeriod(CFG_WN.REGEN_PERIOD)
        inst.components.childspawner:SetSpawnPeriod(CFG_WN.RELEASE_PERIOD)

        inst.components.childspawner:SetSpawnedFn(onspawnbird)
        --inst.components.childspawner:SetMaxChildren(TUNING.SPIDERDEN_SPIDERS[stage])
        --inst.components.childspawner:ScheduleNextSpawn(0)
        inst:ListenForEvent("nestactivate", SpawnInvestigators)

        inst:DoPeriodicTask(5, function() 
            local x,y,z = inst.Transform:GetWorldPosition()
            local ents = TheSim:FindEntities(x,y,z, 9, "player")
            for k,v in pairs(ents) do
                if v and v:HasTag("player") then
                    inst:PushEvent("nestactivate")
                end    
            end  
        end)

        ---------------------
        inst:AddComponent("lootdropper")
        ---------------------

        ---------------------
        MakeMediumBurnable(inst)
        inst.components.burnable:SetOnIgniteFn(OnIgnite)
        ---------------------

        ---------------------
        --MakeMediumFreezableCharacter(inst)
        inst:ListenForEvent("freeze", OnFreeze)
        inst:ListenForEvent("onthaw", OnThaw)
        inst:ListenForEvent("unfreeze", OnUnFreeze)
        -------------------
		
		--Does the clock work like this? -Mobb
        inst:ListenForEvent("dusktime", function() StopSpawning(inst) end, GetWorld())
        inst:ListenForEvent("daytime", function() StartSpawning(inst) end , GetWorld())

        -------------------

        inst:AddComponent("combat")
        inst.components.combat:SetOnHit(SpawnDefenders)
        inst:ListenForEvent("death", OnKilled)

        ---------------------
        MakeLargePropagator(inst)

        ---------------------
        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(den_level)
        inst.components.growable:StartGrowing()

        ---------------------

        inst:AddComponent("inspectable")
        
        inst:SetPrefabName("weavernest")
        inst.OnEntitySleep = OnEntitySleep
        inst.OnEntityWake = OnEntityWake
		
        return inst
    end

    return weavernest_fn
end

return {
       Prefab( "forest/monsters/weavernest", MakeWeaverNestFn(1), assets, prefabs ),
       Prefab( "forest/monsters/weavernest_2", MakeWeaverNestFn(2), assets, prefabs ),
       Prefab( "forest/monsters/weavernest_3", MakeWeaverNestFn(3), assets, prefabs ), 
}
