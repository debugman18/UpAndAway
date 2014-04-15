BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

    Asset( "ATLAS", "images/inventoryimages/dragonblood_sap.xml" ),
    Asset( "IMAGE", "images/inventoryimages/dragonblood_sap.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dragonblood_sap.xml"

	return inst
end

return Prefab ("common/inventory/dragonblood_sap", fn, assets) 
