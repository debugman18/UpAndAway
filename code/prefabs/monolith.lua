BindGlobal()

local assets =
{
    Asset("ANIM", "anim/rock_stalagmite.zip"),
}

local prefabs =
{

}

local loot = 
{

}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

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

return Prefab ("common/inventory/monolith", fn, assets, prefabs) 
