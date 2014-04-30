BindGlobal()

local assets =
{
	Asset("ANIM", "anim/thunder_log.zip"),

	Asset( "ATLAS", "images/inventoryimages/thunder_log.xml" ),
	Asset( "IMAGE", "images/inventoryimages/thunder_log.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("log")
	inst.AnimState:SetBuild("thunder_log")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/thunder_log.xml"

	return inst
end

return Prefab ("common/inventory/thunder_log", fn, assets) 
