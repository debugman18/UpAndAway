--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/cloudcotton.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/cloud_cotton.xml" ),
	Asset( "IMAGE", "images/inventoryimages/cloud_cotton.tex" ),	
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
    inst.components.edible.foodtype = "CANDY"
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 10
    inst.components.edible.sanityvalue = 5

    inst:AddComponent("cookable")
    inst.components.cookable.product = "smores"    
    
    return inst
end

return Prefab("common/inventory/marshmallow", fn, assets, prefabs) 
