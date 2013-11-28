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
	trans:SetScale(0.4, 0.6, 0.6)
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_cotton.xml"
    
	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 0
    inst.components.edible.sanityvalue = 1

	--Is like snow on its structures.
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "cloud"
	inst.components.repairer.value = 1
    
    return inst
end

return Prefab("common/inventory/cotton_candy", fn, assets) 
