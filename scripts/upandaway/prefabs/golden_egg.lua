--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/tallbird_egg.zip"),
	Asset("ANIM", "anim/golden_egg.zip"),
}

local prefabs = 
{
	"duckraptor",
}

local function HeatFn(inst, observer)
	if inst.components.temperature then
		return inst.components.temperature:GetCurrent()
	end	
end

local function corruptegg(inst)
	--inst.AnimState:SetColour(60/255,60/255,60/255)
	inst.Light:SetColour(60/255,60/255,60/255)

	local corruption = SpawnPrefab("duckraptor")
    corruption.Transform:SetPosition(inst.Transform:GetWorldPosition())	

   	inst:Remove()
end

local function OnDropped(inst)
	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 80
	inst.components.temperature.mintemp = 60
	inst.components.temperature.current = 80
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED
end

local function OnPickedUp(inst)
	if inst.components.temperature then
		inst:RemoveComponent("temperature")
	end	
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("egg")
    inst.AnimState:SetBuild("golden_egg")
    inst.AnimState:PlayAnimation("egg")

    inst.Transform:SetScale(1.2, 1.2, 1.2)

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:ListenForEvent("upandaway_uncharge", function()
		inst.components.temperature.current = 60
	end)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickedUp)	

	inst:AddComponent("temperature")
	inst.components.temperature.maxtemp = 80
	inst.components.temperature.mintemp = 60
	inst.components.temperature.current = 80
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_MED

	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	--inst.components.heater.carriedheatfn = HeatFn

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL	
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.entity:AddLight()
	inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
	inst.Light:Enable(true)

	inst.player = GetPlayer()
	inst.player:ListenForEvent("goinsane", function() corruptegg(inst) end)

	return inst
end

return Prefab ("common/inventory/golden_egg", fn, assets) 
