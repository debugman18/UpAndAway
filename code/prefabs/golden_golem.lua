BindGlobal()

local assets =
{
    Asset("ANIM", "anim/rock_stalagmite.zip"),
}

local prefabs =
{
   --"crystal_water_fragment",
}

local loot = 
{
   --"crystal_water_fragment",
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("rock_stalagmite")
    inst.AnimState:SetBuild("rock_stalagmite")
    inst.AnimState:PlayAnimation("full")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

    return inst
end

return Prefab ("common/inventory/golden_golem", fn, assets, prefabs) 
