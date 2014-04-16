BindGlobal()

local assets =
{
	Asset("ANIM", "anim/dragonblood_log.zip"),

    Asset( "ATLAS", "images/inventoryimages/dragonblood_log.xml" ),
    Asset( "IMAGE", "images/inventoryimages/dragonblood_log.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("log")
	inst.AnimState:SetBuild("dragonblood_log")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dragonblood_log.xml"

	return inst
end

return Prefab ("common/inventory/dragonblood_log", fn, assets) 
