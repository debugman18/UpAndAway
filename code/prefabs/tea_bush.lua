BindGlobal()


local Configurable = wickerrequire "adjectives.configurable"

local cfg = Configurable("TEA_BUSH")


require "prefabutil"

local notags = {"NOBLOCK", "player", "FX"}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        
        return true

    end
    return false
    
end

local function ontransplantfn(inst)
    inst.components.pickable:MakeBarren()
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle_dead", true)
end

local function pickanim(inst)
    if inst.components.pickable then
        if inst.components.pickable:CanBePicked() then
            local percent = 0
            if inst.components.pickable then
                percent = inst.components.pickable.cycles_left / inst.components.pickable.max_cycles
            end
            if percent >= .9 then
                return "berriesmost"
            elseif percent >= .33 then
                return "berriesmore"
            else
                return "berries"
            end
        else
            if inst.components.pickable:IsBarren() then
                return "idle_dead"
            else
                return "idle_dead"
            end
        end
    end

    return "idle_dead"
end


local function shake(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
        inst.AnimState:PlayAnimation("shake")
    else
        inst.AnimState:PlayAnimation("shake_empty")
    end
    inst.AnimState:PushAnimation(pickanim(inst), false)
end

local function onpickedfn(inst, picker)

    if inst.components.pickable then
        local old_percent = (inst.components.pickable.cycles_left+1) / inst.components.pickable.max_cycles

        if old_percent >= .9 then
            inst.AnimState:PlayAnimation("berriesmost_picked")
        elseif old_percent >= .33 then
            inst.AnimState:PlayAnimation("berriesmore_picked")
        else
            inst.AnimState:PlayAnimation("berries_picked")
        end

        if inst.components.pickable:IsBarren() then
            inst.AnimState:PushAnimation("idle_dead")
        else
            inst.AnimState:PushAnimation("idle_dead")
        end
    end
end

local function getregentimefn(inst)
    if inst.components.pickable then
        local num_cycles_passed = math.min(inst.components.pickable.max_cycles - inst.components.pickable.cycles_left, 0)
        return TUNING.BERRY_REGROW_TIME + TUNING.BERRY_REGROW_INCREASE*num_cycles_passed+ math.random()*TUNING.BERRY_REGROW_VARIANCE
    else
        return TUNING.BERRY_REGROW_TIME
    end
    
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation(pickanim(inst))
end

local function makebarrenfn(inst)
    inst.AnimState:PlayAnimation("idle_dead")
end

local function makefullfn(inst)
    inst.AnimState:PlayAnimation(pickanim(inst))
end

local function dig_up(inst, chopper)	
    inst:Remove()
    if inst.components.pickable and inst.components.lootdropper then
    
        if inst.components.pickable:IsBarren() then
            inst.components.lootdropper:SpawnLootPrefab("twigs")
            inst.components.lootdropper:SpawnLootPrefab("twigs")
        else		
            if inst.components.pickable and inst.components.pickable:CanBePicked() then
                inst.components.lootdropper:SpawnLootPrefab("tea_leaves")
            end
            
            inst.components.lootdropper:SpawnLootPrefab("dug_tea_bush")
        end
    end	
end

local assets =
{
    Asset("ANIM", "anim/tea_bush.zip"),
}

local prefabs =
{
    "tea_leaves",
    "dug_tea_bush",
    "twigs",
}   

local function ondeploy(inst, pt)
    local tree = SpawnPrefab("tea_bush") 
    if tree then 
        tree.Transform:SetPosition(pt.x, pt.y, pt.z) 
        inst.components.stackable:Get():Remove()
        tree.components.pickable:OnTransplant()
    end 
end

local function dugfn(inst)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("berrybush")
    inst.AnimState:SetBuild("tea_bush")
    inst.AnimState:PlayAnimation("dropped")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("dug_tea_bush")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    
    MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.test = test_ground
    inst.components.deployable.min_spacing = 2

    inst:AddComponent("stackable")

    return inst
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local minimap = inst.entity:AddMiniMapEntity()

    inst:AddTag("bush")

    MakeObstaclePhysics(inst, .1)
   
    anim:SetBank("berrybush")
    anim:SetBuild("tea_bush")
    anim:PlayAnimation("berriesmost", false)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("tea_bush.tex")

    --MakeSnowCovered(inst)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable:SetUp("tea_leaves", cfg:GetConfig("REGROW_TIME"))

    inst.components.pickable.getregentimefn = getregentimefn
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.makebarrenfn = makebarrenfn
    inst.components.pickable.makefullfn = makefullfn
    inst.components.pickable.ontransplantfn = ontransplantfn
    inst.components.pickable.max_cycles = cfg:GetConfig("CYCLES") + math.random(2)
    inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
    
    
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    
    
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)
    
    inst:AddComponent("inspectable")
    
    return inst
end

return {
    Prefab( "common/objects/tea_bush", fn, assets, prefabs),
    Prefab( "common/objects/dug_tea_bush", dugfn, assets, prefabs),
    MakePlacer("common/inventory/dug_tea_bush_placer", "berrybush", "tea_bush", "idle_dead"),
}	
