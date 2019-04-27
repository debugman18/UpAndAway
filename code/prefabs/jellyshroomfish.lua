BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

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

    return inst
end

local function greenfn()
end


local function redfn()
end


local function bluefn()
end

return {
    Prefab ("common/creatures/jellyshroomfish_green", greenfn, assets),
    Prefab ("common/creatures/jellyshroomfish_red", redfn, assets),
    Prefab ("common/creatures/jellyshroomfish_blue", bluefn, assets),
}
