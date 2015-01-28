BindGlobal()

local assets=
{
    --Asset("ANIM", "anim/rhinoman.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    --anim:SetBank("rhinoman")
    --anim:SetBuild("rhinoman")

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("health")

    inst:AddComponent("combat")
    
    return inst
end

return Prefab("common/rhinoman", fn, assets) 
