local assets =
{
	Asset("ANIM", "anim/gears.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("gears")
    inst.AnimState:SetBuild("gears")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem")      
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = TUNING.HEALING_HUGE
    inst.components.edible.hungervalue = TUNING.CALORIES_HUGE
    inst.components.edible.sanityvalue = TUNING.SANITY_HUGE

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "cloud"
	inst.components.repairer.value = TUNING.REPAIR_GEARS
    
    return inst
end

return Prefab("common/inventory/cloud_cotton", fn, assets) 
