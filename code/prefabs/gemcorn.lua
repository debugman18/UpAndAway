BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/pineapple.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("gemcorn")
    inst.AnimState:SetBuild("gemcorn")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("pineapple")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.GEM_CORN.STACK_SIZE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.GEM_CORN.FOODTYPE
    inst.components.edible.healthvalue = CFG.GEM_CORN.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.GEM_CORN.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.GEM_CORN.SANITY_VALUE

    return inst
end

return Prefab ("common/inventory/gemcorn", fn, assets) 
