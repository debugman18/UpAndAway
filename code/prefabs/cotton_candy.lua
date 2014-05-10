BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cotton_candy.zip"),
	--Asset("ANIM", "anim/swap_cotton_candy.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/cotton_candy.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cotton_candy.tex" ),	
}

local function onattackfn(inst, owner, target)
	if target and target.components.locomotor then
		if target.components.locomotor.walkspeed then
			target.components.locomotor.bonusspeed = -(target.components.locomotor.walkspeed)
		else target.components.locomotor.bonusspeed = -4 end
		target.components.locomotor:UpdateGroundSpeedMultiplier()
		target:DoTaskInTime(2, function() 
			target.components.locomotor.bonusspeed = 0
			target.components.locomotor:UpdateGroundSpeedMultiplier()
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
    
	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("cotton_candy")
	inst.AnimState:PlayAnimation("closed")
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cotton_candy.xml"
   
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(2)
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
