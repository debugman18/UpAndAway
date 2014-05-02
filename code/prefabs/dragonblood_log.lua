BindGlobal()

local prefabs =
{
	"lavalight",
	"campfirefire_dragon",
}

local assets =
{
	Asset("ANIM", "anim/dragonblood_log.zip"),

    Asset( "ATLAS", "images/inventoryimages/dragonblood_log.xml" ),
    Asset( "IMAGE", "images/inventoryimages/dragonblood_log.tex" ),
}

local function FuelTaken(inst, taker)
	if taker.prefab == "firepit" then
		taker.components.burnable:Extinguish()
		taker.components.burnable:KillFX()
		taker.components.burnable:AddBurnFX("campfirefire_dragon", Vector3(0,.4,0))
		local blaze = SpawnPrefab("lavalight")
		local pt = Vector3(taker.Transform:GetWorldPosition()) + Vector3(0,.4,0)
		if blaze then
			blaze.AnimState:SetMultColour(100,0,0,1)
			blaze.Transform:SetScale(.4,.4,.4)
		    blaze.Transform:SetPosition(pt:Get())
		    inst:DoTaskInTime(3, function() blaze:Remove() end)
		end
		taker.components.burnable:Ignite()
		taker.components.fueled.rate = 15
		taker:AddTag("dragonblood_fire")
		taker.dragonblood_fire = true
    end
end

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
    inst.components.fuel.fuelvalue = 30
    inst.components.fuel:SetOnTakenFn(FuelTaken)

	inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 5

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/dragonblood_log.xml"

	return inst
end

return Prefab ("common/inventory/dragonblood_log", fn, assets, prefabs) 
