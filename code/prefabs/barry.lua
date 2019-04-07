BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    -- Nothing yet.
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    return inst
end

return Prefab ("common/creatures/barry", fn, assets) 