BindGlobal()

local assets =
{
    Asset("ANIM", "anim/rubber.zip"),
}

local function fn(Sim)

    local scale = 1

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("rubber")
    inst.AnimState:SetBuild("rubber")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(scale,scale,scale)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    return inst
end

return Prefab ("common/cloudblob", fn, assets)
