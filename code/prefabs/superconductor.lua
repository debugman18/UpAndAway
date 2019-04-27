BindGlobal()

local assets=
{
    --Asset("ANIM", "anim/superconductor.zip"),
}

-- Tag the player.
local function OnDeath(data)
    local cause = data and data.cause or nil
    if cause == ThePlayer then cause:AddTag("SuperconductorSlayer") end
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    --anim:SetBank("superconductor")
    --anim:SetBuild("superconductor")

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon("superconductor.tex")

    ------------------------------------------------------------------------
    
    SetupNetwork(inst)
    
    ------------------------------------------------------------------------

    inst:AddTag("epic")

    inst:AddComponent("inspectable")

    inst:AddComponent("health")

    inst:AddComponent("combat")

    inst:AddComponent("staticchargeable")

    inst:AddComponent("staticconductor")
    
    return inst
end

return Prefab("common/superconductor", fn, assets) 
