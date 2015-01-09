BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/dragonblood_tree.zip"),
}

local prefabs = CFG.DRAGONBLOOD_TREE.PREFABS

local short_loot = CFG.DRAGONBLOOD_TREE.SHORT_LOOT

local normal_loot = CFG.DRAGONBLOOD_TREE.NORMAL_LOOT

local tall_loot = CFG.DRAGONBLOOD_TREE.TALL_LOOT

local function dig_up_stump(inst, chopper)
    for k,drop in ipairs(CFG.DRAGONBLOOD_TREE.DUG_LOOT) do
        inst.components.lootdropper:SpawnLootPrefab(drop)
    end
    inst:Remove()
end

local function chopped(inst)

    inst.AnimState:SetMultColour(0, 0, 0, 1)
    inst:RemoveComponent("workable")
    inst:RemoveComponent("growable")

    if not inst.chopped then
        inst.components.lootdropper:DropLoot()
        inst.chopped = true
    end

    inst.Transform:SetScale(0.2,0.2,0.2)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)   

end

local function chop(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree") 
end

local function SetShort(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(CFG.DRAGONBLOOD_TREE.WORK_TIME)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end	
    inst.components.lootdropper:SetLoot(short_loot)
    inst.Transform:SetScale(CFG.DRAGONBLOOD_TREE.SHORT_SCALE, CFG.DRAGONBLOOD_TREE.SHORT_SCALE, CFG.DRAGONBLOOD_TREE.SHORT_SCALE)
    inst.AnimState:PlayAnimation("idle_harvested")
end

local function GrowShort(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")          
end

local function SetNormal(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(CFG.DRAGONBLOOD_TREE.WORK_TIME + 1)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end		
    inst.components.lootdropper:SetLoot(normal_loot)
    inst.Transform:SetScale(CFG.DRAGONBLOOD_TREE.NORMAL_SCALE, CFG.DRAGONBLOOD_TREE.NORMAL_SCALE, CFG.DRAGONBLOOD_TREE.NORMAL_SCALE)
    inst.AnimState:PlayAnimation("idle_harvested")
end

local function GrowNormal(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local function SetTall(inst)
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(CFG.DRAGONBLOOD_TREE.WORK_TIME + 2)
    end
    if not inst.components.lootdropper then
        inst:AddComponent("lootdropper")
    end		
    inst.components.lootdropper:SetLoot(tall_loot)
    inst.Transform:SetScale(CFG.DRAGONBLOOD_TREE.TALL_SCALE, CFG.DRAGONBLOOD_TREE.TALL_SCALE, CFG.DRAGONBLOOD_TREE.TALL_SCALE)
end

local function GrowTall(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local growth_stages =
{
    {name="short", time = function(inst) return GetRandomWithVariance(CFG.DRAGONBLOOD_TREE.BASE_GROW_TIME, CFG.DRAGONBLOOD_TREE.RAND_GROW_TIME) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end},
    {name="normal", time = function(inst) return GetRandomWithVariance(CFG.DRAGONBLOOD_TREE.BASE_GROW_TIME, CFG.DRAGONBLOOD_TREE.RAND_GROW_TIME) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end},
    {name="tall", time = function(inst) return GetRandomWithVariance(CFG.DRAGONBLOOD_TREE.BASE_GROW_TIME, CFG.DRAGONBLOOD_TREE.RAND_GROW_TIME) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end},
}

local function random_colour()
    local ret = {}
    for i = 1, 3 do
        ret[i] = 0.5 + 0.5*math.random()
    end
    return ret
end

local function set_colour(inst, colour)
    inst.AnimState:SetMultColour( colour[1], colour[2], colour[3], 1 )
    inst.colour = colour
end	

local function onsave(inst, data)
    data.colour = inst.colour
    data.chopped = inst.chopped
    data.oldblaze = inst.oldblaze
end

local function onload(inst, data)
    if data then
        if data.colour then
            set_colour(inst, data.colour)
        end
        if data.chopped then
            inst.oldblaze = true
            chopped(inst)
            if data.oldblaze then
                inst.oldblaze = true
            end
        end
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("dragonblood_tree")
    inst.AnimState:SetBuild("dragonblood_tree")
    inst.AnimState:PlayAnimation("idle", true)

    set_colour(inst, random_colour())

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper") 

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(CFG.DRAGONBLOOD_TREE.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(chopped)
    inst.components.workable:SetOnWorkCallback(chop)	

    inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(math.random(1, 3))
    inst.components.growable.loopstages = true
    inst.components.growable:StartGrowing()

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("dragonblood_tree.tex")   	

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab ("common/inventory/dragonblood_tree", fn, assets, prefabs) 
