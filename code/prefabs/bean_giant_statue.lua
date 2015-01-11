BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local function spawn_fn()
    print("SUCCESS WOOT YEAH")
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marble")
    inst.AnimState:SetBuild("void_placeholder")
    inst.AnimState:PlayAnimation("anim")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("reputation")
    inst.components.reputation:SetFaction("bean", 50, 0, 100)
    inst.components.reputation:AddStage(spawn_fn, "bean", "one", 100)
    inst.components.reputation:IncreaseReputation("bean", 100)

    return inst
end

return Prefab ("common/inventory/bean_giant_statue", fn, assets) 
