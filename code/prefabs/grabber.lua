BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local CFG = TheMod:GetConfig()

local bonus = CFG.GRABBER.BONUS

--This thing is made of gnome rubber, and will be used to catch skyflies, etcetera.
local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marble")
    inst.AnimState:SetBuild("void_placeholder")
    inst.AnimState:PlayAnimation("anim")

    --TheMod:DebugSay("PICKUP RANGE IS " .. _G.ACTIONS.PICKUP[1])

    for k,v in pairs(_G.ACTIONS.PICKUP) do
        print(k)
        print(v)
    end

    _G.ACTIONS.PICKUP.crosseswaterboundary = true
    _G.ACTIONS.PICKUP.distance = bonus

    --local range = _G.ACTIONS.PICKUP[1]
    --local extended_range = range + bonus


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab ("common/inventory/grabber", fn, assets)
