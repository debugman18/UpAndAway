BindGlobal()

local assets =
{
    Asset("ANIM", "anim/tree_thunder.zip"),
}

local prefabs =
{
    "cloud_lightning",
    "cumulostone",
    "ball_lightning",
    "thunder_pinecone",
}

local short_loot = 
{
    "thunder_log",  
}

local normal_loot = 
{
    "thunder_log",
    "thunder_log",  
    "thunder_pinecone",
}

local tall_loot = 
{
    "thunder_log",
    "thunder_log",
    "thunder_log", 
    "thunder_log", 
    "thunder_log", 
    "thunder_pinecone",    
}

local function StartSpawning(inst)
    if inst.components.childspawner and GetPseudoSeasonManager() and GetPseudoSeasonManager():IsWinter() and not (GetStaticGenerator() and GetStaticGenerator():IsCharged()) then
        inst.components.childspawner:StartSpawning()
        --print("Tree spawning.")
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
        --print("Tree no longer spawning.")
    end
end

local function SetShort(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end 
    inst.components.lootdropper:SetLoot(short_loot)
    inst.Transform:SetScale(0.7, 0.7, 0.7)
    if inst.components.staticchargeable then
        inst:RemoveComponent("staticchargeable")
    end    
end

local function GrowShort(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")          
end

local function SetNormal(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_NORMAL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end     
    inst.components.lootdropper:SetLoot(normal_loot)
    inst.components.lootdropper:AddChanceLoot("thunder_pinecone", 0.3)
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    if inst.components.staticchargeable then
        inst:RemoveComponent("staticchargeable")
    end 
end

local function GrowNormal(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local function SetTall(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_TALL)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end     
    inst.components.lootdropper:SetLoot(tall_loot)
    inst.Transform:SetScale(0.9, 0.9, 0.9)   
    inst.components.lootdropper:AddChanceLoot("cumulostone", 1)
    inst.components.lootdropper:AddChanceLoot("thunder_pinecone", 0.5)
    if not inst.components.staticchargeable then
        inst:AddComponent("staticchargeable")
        inst.components.staticchargeable:SetChargedFn(function(inst)
            StopSpawning(inst)
        end)
        inst.components.staticchargeable:SetUnchargedFn(function(inst)
            StartSpawning(inst)
        end)
    end    
end

local function GrowTall(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local growth_stages =
{
    {name="short", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end , leifscale=.7 },
    {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, TUNING.EVERGREEN_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end, leifscale=1 },
    {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, TUNING.EVERGREEN_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end, leifscale=1.25 },
}

local function sway(inst)
    inst.AnimState:PushAnimation("sway"..math.random(4).."_loop", true)
end

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap")         
    inst.AnimState:PlayAnimation("chop")
    sway(inst)
end

local function dig_up_stump(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("cloud_lightning")
    inst.components.lootdropper:SpawnLootPrefab("thunder_log")
    inst:Remove()
end

local function set_stump(inst, push_anim)
    inst:RemoveComponent("workable")
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("growable")
    RemovePhysicsColliders(inst)
    inst:AddTag("stump")

    if push_anim then
        inst.AnimState:PushAnimation("stump", false)
    else
        inst.AnimState:PlayAnimation("stump", false)
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)
end

local function chop_down_tree(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    inst.AnimState:PlayAnimation("fall")
    inst.components.lootdropper:DropLoot()

    set_stump(inst, true)
end

local function onsave(inst, data)
    if inst:HasTag("stump") then
        data.stump = true
    end
    data.color = inst.color
    data.scale = inst.scale
end
        
local function onload(inst, data)
    if data then
        if data.stump then
            set_stump(inst)
        end
        if data.color then
            inst.color = data.color
            inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
        end
        if data.scale then
            inst.scale = data.scale
            inst.Transform:SetScale(inst.scale, inst.scale, inst.scale)
        end
    end
end   

local function OnSpawned(inst, child)
    if not GetStaticGenerator() or not GetStaticGenerator():IsCharged() then
        local lightning = SpawnPrefab("lightning")
        lightning.Transform:SetPosition(child.Transform:GetWorldPosition())
    end   
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local shadow = inst.entity:AddDynamicShadow()
    local sound = inst.entity:AddSoundEmitter()

    local l_stage = math.random(#growth_stages)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(l_stage)
    inst.components.growable.loopstages = true
    inst.components.growable:StartGrowing()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "marshtree.png" )
    minimap:SetPriority(-1)

    MakeObstaclePhysics(inst, .25)   
    inst:AddTag("tree")
    
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end 

    inst:AddComponent("childspawner")
    --inst.components.childspawner.childname = "cloud_lightning"
    inst.components.childspawner.childname = "ball_lightning"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*16)
    --inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetSpawnPeriod(50)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner.spawnoffscreen = false
    --inst.components.childspawner:SetRareChild("ball_lightning", 0.2)
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 10)
    inst.components.playerprox:SetOnPlayerFar(StopSpawning)
    inst.components.playerprox:SetOnPlayerNear(StartSpawning)

    anim:SetBuild("tree_thunder")
    anim:SetBank("marsh_tree")
    inst.color = 0.5 + math.random() * 0.5
    anim:SetMultColour(inst.color, inst.color, inst.color, 1)
    sway(inst)
    anim:SetTime(math.random()*2)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
 
    inst.scale = 0.8 + 0.4*math.random()
    inst.Transform:SetScale(inst.scale, inst.scale, inst.scale)

    inst:AddComponent("inspectable")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("thunder_tree.tex") 

    inst.OnSave = onsave
    inst.OnLoad = onload
    return inst
end

return Prefab("cloudrealm/objects/thunder_tree", fn, assets, prefabs) 
