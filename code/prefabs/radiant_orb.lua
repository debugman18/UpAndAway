BindGlobal()

local assets=
{
    --Asset("ANIM", "anim/radiant_orb.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    --anim:SetBank("radiant_orb")
    --anim:SetBuild("radiant_orb")

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")
 
    return inst
end

return Prefab("common/radiant_orb", fn, assets) 
