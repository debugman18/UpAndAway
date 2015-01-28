BindGlobal()

local assets=
{
    --Asset("ANIM", "anim/super_beans.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    --anim:SetBank("super_beans")
    --anim:SetBuild("super_beans")

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")
 
    return inst
end

return Prefab("common/super_beans", fn, assets) 
