BindGlobal()

local assets=
{
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")
 
    return inst
end

return Prefab("creatures/flameingo", fn, assets) 