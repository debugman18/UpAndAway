BindGlobal()

local assets =
{
	Asset("ANIM", "anim/dragonblood_log.zip"),

    Asset( "ATLAS", "images/inventoryimages/dragonblood_log.xml" ),
    Asset( "IMAGE", "images/inventoryimages/dragonblood_log.tex" ),
}

local function HeatFn(inst, observer)
    return inst.components.temperature:GetCurrent()	
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("log")
	inst.AnimState:SetBuild("dragonblood_log")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 15
	inst.components.temperature.mintemp = 15
	inst.components.temperature.current = 15
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED

	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	inst.components.heater.carriedheatfn = HeatFn

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

	inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dragonblood_log.xml"

	return inst
end

return Prefab ("common/inventory/dragonblood_log", fn, assets) 
