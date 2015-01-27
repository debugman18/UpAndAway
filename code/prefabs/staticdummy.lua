-- This only exists to trick morgue into listing static as a cause of death.

BindGlobal()

local assets=
{
    --[[dummy]]
}

local function fn(Sim)

    local inst = CreateEntity()

    inst.entity:AddTransform()

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    ------------------------------------------------------------------------

    -- Avoid stunlock.
    inst:AddTag("insect")

    local inspectable = inst:AddComponent("inspectable")

    local combat = inst:AddComponent("combat")
    
    return inst

end

return Prefab("common/staticdummy", fn, assets) 
