local assets=
{
	Asset("ANIM", "anim/skyflower_petals.zip"),
	--Asset("ANIM", "anim/swap_Skyflower_petals.zip"),
	
	Asset( "ATLAS", "images/inventoryimages/void_placeholder.xml" ),
	Asset( "IMAGE", "images/inventoryimages/void_placeholder.tex" ),	
}
   
local prefabs =
{
}

local function OnDropped(inst)
    inst.AnimState:PlayAnimation("idle")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst .entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)
    
    anim:SetBank("flower_petals")
    anim:SetBuild("skyflower_petals")
    anim:PlayAnimation("idle")
    anim:SetRayTestOnBB(true);

    -------

    inst:AddComponent("inspectable")
  
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	--inst.components.inventoryitem.atlasname = "images/inventoryimages/datura_petals.xml"

    return inst
end

return Prefab("common/inventory/skyflower_petals", fn, assets) 
