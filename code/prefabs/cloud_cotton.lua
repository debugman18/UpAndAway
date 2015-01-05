BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset("ANIM", "anim/cloudcotton.zip"),
	
	Asset( "ATLAS", inventoryimage_atlas("cloud_cotton") ),
	Asset( "IMAGE", inventoryimage_texture("cloud_cotton") ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("cloudcotton")
    anim:SetBuild("cloudcotton")
    anim:PlayAnimation("idle")
	trans:SetScale(CFG.CLOUD_COTTON.SCALE, CFG.CLOUD_COTTON.SCALE, CFG.CLOUD_COTTON.SCALE)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = CFG.CLOUD_COTTON.STACK_SIZE
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_cotton")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.CLOUD_COTTON.FUEL_VALUE

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CLOUD_COTTON.FOODTYPE
    inst.components.edible.healthvalue = CFG.CLOUD_COTTON.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.CLOUD_COTTON.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CLOUD_COTTON.SANITY_VALUE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(CFG.CLOUD_COTTON.PERISH_TIME)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = CFG.CLOUD_COTTON.PERISH_ITEM

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = CFG.CLOUD_COTTON.REPAIR_MATERIAL
	inst.components.repairer.healthrepairvalue = CFG.CLOUD_COTTON.REPAIR_VALUE
    
    return inst
end

return Prefab("common/inventory/cloud_cotton", fn, assets) 
