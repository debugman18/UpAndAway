BindGlobal()

local assets=
{
	Asset("ANIM", "anim/flameingo.zip"),	
}

local function fn(Sim)
    local inst = CreateEntity()
    local scale = 1

    local transform = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")

    inst.AnimState:SetBank("flameingo")
    inst.AnimState:SetBuild("flameingo")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("kick")

    inst.Transform:SetScale(scale,scale,scale)

    return inst
end

return Prefab("creatures/flameingo", fn, assets) 