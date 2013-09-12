--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/tallbird_egg.zip"),
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

    inst.AnimState:SetBuild("tallbird_egg")
    inst.AnimState:SetBank("egg")
    inst.AnimState:PlayAnimation("egg")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(5)
	inst:ListenForEvent("upandaway_uncharge", function()
		inst.components.perishable:StartPerishing()
	end)
	
	inst.components.perishable.onperishreplacement = "rottenegg"	
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 30
	inst.components.temperature.current = 30
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED

	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	inst.components.heater.carriedheatfn = HeatFn
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.entity:AddLight()
	inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
	inst.Light:Enable(true)

	return inst
end

return Prefab ("common/inventory/golden_egg", fn, assets) 
