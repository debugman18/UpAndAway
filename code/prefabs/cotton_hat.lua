BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/cotton_hat.zip"),
    Asset("ANIM", "anim/hat_miner_off.zip"),
}


local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "cotton_hat", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")
        
    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAIR")
    end
        
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")
    end

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
end

local function onperish(inst)
    inst:Remove()
end

local function fn(Sim)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("strawhat")
        inst.AnimState:SetBuild("cotton_hat")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("hat")


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------


        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.atlasname = inventoryimage_atlas("cotton_hat")

        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

        inst.components.equippable:SetOnEquip(onequip)

        inst.components.equippable:SetOnUnequip(onunequip)

        inst:AddComponent("insulator")
        inst.components.insulator.insulation = CFG.COTTON_HAT.INSULATION

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "USAGE"
        inst.components.fueled:InitializeFuelLevel(CFG.COTTON_HAT.FUEL)
        inst.components.fueled:SetDepletedFn(onperish)

        local function melt(inst)
            TheMod:DebugSay("Rain start.")
            inst.updatetask = inst:DoPeriodicTask(CFG.COTTON_HAT.MELT_INTERVAL, function()
                TheMod:DebugSay("Still raining.")
                inst.components.fueled:DoDelta(CFG.COTTON_HAT.MELT_VALUE)
            end)
        end    

        inst:ListenForEvent("rainstart", function() 
            melt(inst)
        end, GetWorld())

        inst:ListenForEvent("rainstop", function()
            TheMod:DebugSay("Rain stop.")
            if inst.updatetask then
                inst.updatetask:Cancel()
                inst.updatetask = nil
            end    
        end, GetWorld())

        if GetPseudoSeasonManager():IsRaining() then
            melt(inst)
        end

        return inst
end

return Prefab ("common/inventory/cotton_hat", fn, assets) 
