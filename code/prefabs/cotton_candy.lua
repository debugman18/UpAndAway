BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cotton_candy.zip"),
    Asset("ANIM", "anim/swap_cotton_candy.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("cotton_candy") ),
    Asset( "IMAGE", inventoryimage_texture("cotton_candy") ),	
}

local function onattackfn(inst, owner, target)
    if target and target.components.locomotor then
        local locomotor = target.components.locomotor
        if locomotor.walkspeed then
            locomotor.bonusspeed = -(locomotor.walkspeed / CFG.COTTON_CANDY.SPEED_DEBUFF)
        elseif locomotor.runspeed then
            locomotor.bonusspeed = -(locomotor.runspeed / CFG.COTTON_CANDY.SPEED_DEBUFF) 
        end
        locomotor:UpdateGroundSpeedMultiplier()
        target:DoTaskInTime(CFG.COTTON_CANDY.DEBUFF_TIME, function() 
            locomotor.bonusspeed = 0
            locomotor:UpdateGroundSpeedMultiplier()
        end)
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_cotton_candy", "wand")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("cotton_candy")
    inst.AnimState:SetBuild("cotton_candy")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("cotton_candy")
   
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(CFG.COTTON_CANDY.DAMAGE)
    inst.components.weapon:SetOnAttack(onattackfn)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.COTTON_CANDY.PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.COTTON_CANDY.PERISH_ITEM

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.COTTON_CANDY.FOODTYPE
    inst.components.edible.healthvalue = CFG.COTTON_CANDY.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.COTTON_CANDY.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.COTTON_CANDY.SANITY_VALUE

    --Is like snow on its structures.
    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = CFG.COTTON_CANDY.REPAIR_MATERIAL
    inst.components.repairer.value = CFG.COTTON_CANDY.REPAIR_VALUE
  
    local function melt(inst)
        TheMod:DebugSay("Rain start.")
        inst.updatetask = inst:DoPeriodicTask(CFG.COTTON_CANDY.MELT_INTERVAL, function()
            TheMod:DebugSay("Still raining.")
            inst.components.perishable:ReducePercent(CFG.COTTON_CANDY.MELT_VALUE)
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

return Prefab("common/inventory/cotton_candy", fn, assets) 
