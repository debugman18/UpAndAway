BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloudcotton.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/cloud_cotton.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cloud_cotton.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("gears")
    anim:SetBuild("cloudcotton")
    anim:PlayAnimation("idle")
	trans:SetScale(0.7, 0.7, 0.7)
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_cotton.xml"
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 8

	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -2
    inst.components.edible.hungervalue = 2
    inst.components.edible.sanityvalue = 2

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	--Is like snow on its structures.
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "cloud"
	inst.components.repairer.healthrepairvalue = 5
    
    return inst
end

return Prefab("common/inventory/cloud_cotton", fn, assets) 
