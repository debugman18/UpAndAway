BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    -- Nothing yet.
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    return inst
end

return {
	Prefab ("common/inventory/meat_wall", fn, assets),
	--Prefab ("common/inventoryitem/meat_wall_item", itemfn, assets, prefabs),
    --MakePlacer("common/meat_wall_placer", "meat_wall", "meat_wall", "0", false, false, true),
}