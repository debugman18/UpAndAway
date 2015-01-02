BindGlobal()

local assets =
{
    Asset("ANIM", "anim/potion_tunnel_mound.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    anim:SetBank("potion_tunnel_mound")
    anim:SetBuild("potion_tunnel_mound")
    anim:PlayAnimation("mound", true)

    inst.Transform:SetScale(.6,.6,.6)

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    return inst
end

return Prefab("common/potion_tunnel_mound", fn, assets) 
