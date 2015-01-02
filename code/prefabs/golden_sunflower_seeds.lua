BindGlobal()


local assets=
{
    Asset("ANIM", "anim/golden_sunflower_seeds.zip"),
    Asset("ANIM", "anim/golden_sunflower.zip"),

    Asset( "ATLAS", inventoryimage_atlas("golden_sunflower_seeds") ),
    Asset( "IMAGE", inventoryimage_texture("golden_sunflower_seeds") ),
}

local prefabs = {
    "golden_sunflower",
}

local function ondeploy (inst, pt) 
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get() )
    local sunflower = SpawnPrefab("golden_sunflower")
    sunflower.Transform:SetPosition(inst.Transform:GetWorldPosition())
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

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("flint")
    inst.AnimState:SetBuild("golden_sunflower_seeds")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("golden_sunflower_seeds")

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy
    
    return inst
end

return {
    Prefab( "common/inventory/golden_sunflower_seeds", fn, assets, prefabs),
    MakePlacer ("common/golden_sunflower_seeds_placer", "golden_sunflower", "golden_sunflower", "idle", false, false, false, 2),
}
