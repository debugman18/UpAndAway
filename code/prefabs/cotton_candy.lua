BindGlobal()

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
            locomotor.bonusspeed = -(locomotor.walkspeed / 2)
        elseif locomotor.runspeed then
            locomotor.bonusspeed = -(locomotor.runspeed / 2) 
        end
        locomotor:UpdateGroundSpeedMultiplier()
        target:DoTaskInTime(2, function() 
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
    inst.components.weapon:SetDamage(6)
    inst.components.weapon:SetOnAttack(onattackfn)

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -15
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = 20

    --Is like snow on its structures.
    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = "cloud"
    inst.components.repairer.value = 10
    
    return inst
end

return Prefab("common/inventory/cotton_candy", fn, assets) 
