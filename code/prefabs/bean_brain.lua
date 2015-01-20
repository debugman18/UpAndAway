BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local function getstatus(inst)
    if inst.components.finiteuses:GetUses() >= 1 then
        return bean_brain
    else 
        return inedible
    end
end

local function check_fn(inst)
    if inst.components.finiteuses:GetUses() >= 1 then
        return true
    else 
        return false 
    end
end

local function eat_fn(inst)
    local hunger = GetLocalPlayer().components.hunger
    if GetLocalPlayer() then
        hunger:DoDelta(hunger.max * 0.25)
        inst.components.finiteuses:Use(1)
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marble")
    inst.AnimState:SetBuild("void_placeholder")
    inst.AnimState:PlayAnimation("anim")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetUses(4)
    inst.components.finiteuses:SetMaxUses(4)

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetCanInteractFn(check_fn)
    inst.components.useableitem:SetOnUseFn(eat_fn)

    inst:ListenForEvent("dusktime", function()
        if inst.components.finiteuses:GetUses() <=3 then
            inst.components.finiteuses:SetUses(inst.components.finiteuses:GetUses() + 1)
        end
    end, GetWorld())

    return inst
end

return Prefab ("common/inventory/bean_brain", fn, assets) 
