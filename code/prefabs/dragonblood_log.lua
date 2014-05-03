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
	if taker.components.burnable then
		taker.components.burnable:Extinguish()
		if not (taker.prefab == ("campfire" or "coldfire")) then
			local blaze = SpawnPrefab("lavalight")
			--local pt = Vector3(taker.Transform:GetWorldPosition()) + Vector3(0,.5,0)
			local pt = Vector3(taker.Transform:GetWorldPosition()) + Vector3(0,.76,0)
			if blaze then
				if taker.prefab == "firepit" then
					blaze.AnimState:SetMultColour(100,0,0,1)
				elseif taker.prefab == "coldfirepit" then
					blaze.AnimState:SetMultColour(0,0,80,1)
				end	
				--blaze.Transform:SetScale(.4,.4,.4)
				blaze.Transform:SetScale(.7,.6,.7)
				taker.components.inspectable.nameoverride = "dragonblood_firepit"
			    blaze.Transform:SetPosition(pt:Get())
			    if not blaze.components.heater then
			    	blaze:AddComponent("heater")
			    end	
			    blaze:AddComponent("propagator")
			    blaze.components.propagator.propagaterange = 5
			    blaze.components.propagator:StartSpreading()
	    		blaze.components.heater.heatfn = function() return 300 end
			    taker:DoTaskInTime(5.6, function() 
			    	if blaze then
			    		blaze:Remove()
			    	end	 	
			    	if taker then
			    		taker.components.inspectable.nameoverride = "firepit"
			    	end
			    end)
			end
		end
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
	inst.components.temperature.maxtemp = 2
	inst.components.temperature.mintemp = 2
	inst.components.temperature.current = 2
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
