BindGlobal()

local assets=
{
    Asset("ANIM", "anim/gustflower_seeds.zip"),

    Asset( "ATLAS", inventoryimage_atlas("gustflower_seeds") ),
    Asset( "IMAGE", inventoryimage_texture("gustflower_seeds") ), 
}

local function onpickedfn(inst)
    inst.components.pickable.cycles_left = 0
end

local function ondeploy (inst, pt) 
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get() )
    local gustflower = SpawnPrefab("gustflower")
    gustflower.Transform:SetPosition(inst.Transform:GetWorldPosition())
    gustflower:RemoveComponent("pickable")
    gustflower:DoTaskInTime(80, function()
        gustflower:AddComponent("pickable")
        gustflower.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        gustflower.components.pickable:SetUp("gustflower_seeds", 1, 1)
        gustflower.components.pickable.onpickedfn = onpickedfn
    end)
    inst:Remove()
end

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

local function spawngustflower(inst)
    local gustflower = SpawnPrefab("gustflower")
    gustflower.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end    

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    
    
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("gustflower_seeds")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("gustflower_seeds")
    
    inst.components.inventoryitem:SetOnPickupFn(function(inst) 
        inst.components.periodicspawner:Stop()
    end)
    
    inst.components.inventoryitem:SetOnDroppedFn(function(inst) 
        inst.components.periodicspawner:Start()
    end)

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("gustflower")
    inst.components.periodicspawner:SetOnSpawnFn(spawngustflower)
    
    return inst
end

return {
    Prefab( "common/inventory/gustflower_seeds", fn, assets), 
    MakePlacer ("common/gustflower_seeds_placer", "gustflower", "gustflower", "idle_2"),
}
