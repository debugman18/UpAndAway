BindGlobal()

local assets=
{
	Asset("ANIM", "anim/skyflower_petals.zip"),
	Asset("ANIM", "anim/datura_petals.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/skyflower_petals.xml" ),
	Asset( "IMAGE", "images/inventoryimages/skyflower_petals.tex" ),
	
	Asset( "ATLAS", "images/inventoryimages/datura_petals.xml" ),
	Asset( "IMAGE", "images/inventoryimages/datura_petals.tex" ),		
}
   
local prefabs =
{
}

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("anim")
end

local function fncommon(Sim)
	local inst = CreateEntity()
	local trans = inst .entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("petals")
    anim:SetBuild("skyflower_petals")
    anim:PlayAnimation("anim")
    anim:SetRayTestOnBB(true);

    -------

    inst:AddComponent("inspectable")
  
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5
	
	inst:AddComponent("edible")
	inst.components.edible.healthvalue = -1
    inst.components.edible.hungervalue = 3
    inst.components.edible.sanityvalue = 1	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/skyflower_petals.xml"

    return inst
end

local function fndatura(Sim)
	local inst = fncommon(Sim)
	local trans = inst .entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("flower_petals_evil")
    anim:SetBuild("datura_petals")
    anim:PlayAnimation("anim")
    anim:SetRayTestOnBB(true);

    -------
	inst.components.edible.healthvalue = -3
    inst.components.edible.hungervalue = 6
    inst.components.edible.sanityvalue = -8
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM	

    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem.atlasname = "images/inventoryimages/datura_petals.xml"

    return inst
end

return {
	Prefab("common/inventory/skyflower_petals", fncommon, assets),
	Prefab("common/inventory/datura_petals", fndatura, assets),
}
