BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloudcotton.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/cotton_candy.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cotton_candy.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("gears")
    anim:SetBuild("cloudcotton")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cotton_candy.xml"
    
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
