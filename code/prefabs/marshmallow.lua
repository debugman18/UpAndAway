BindGlobal()

local assets =
{
	Asset("ANIM", "anim/marshmallow.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/marshmallow.xml" ),
	Asset( "IMAGE", "images/inventoryimages/marshmallow.tex" ),	
}

local prefabs =
{
    "smores",
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("icebox")
    anim:SetBuild("marshmallow")
    anim:PlayAnimation("closed")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
	inst.components.inventoryitem.atlasname = "images/inventoryimages/marshmallow.xml"
    
	--Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "CANDY"
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 10
    inst.components.edible.sanityvalue = 5

    inst:AddComponent("cookable")
    inst.components.cookable.product = "smores"    
    
    return inst
end

return Prefab("common/inventory/marshmallow", fn, assets, prefabs) 
