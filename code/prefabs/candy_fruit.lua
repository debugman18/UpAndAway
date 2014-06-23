BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloudcotton.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/candy_fruit.xml" ),
	Asset( "IMAGE", "images/inventoryimages/candy_fruit.tex" ),	
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("berries")
    anim:SetBuild("candy_fruit")
    anim:PlayAnimation("idle")
	trans:SetScale(0.4, 0.6, 0.6)
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/candy_fruit.xml"
    
	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = 0
    inst.components.edible.hungervalue = 5
    inst.components.edible.sanityvalue = 5

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

    return inst
end

return Prefab("common/inventory/candy_fruit", fn, assets) 
