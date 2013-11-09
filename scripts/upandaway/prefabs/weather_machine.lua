--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function weather_off(inst)
	if GetWorld() and GetWorld():HasTag("cloudrealm") then
		GetSeasonManager():StartSummer()
	end
	
	GetSeasonManager():StartWinter()	
end	

local function weather_on(inst)
	if GetWorld() and GetWorld():HasTag("cloudrealm") then
		print "In cloudrealm."
		GetSeasonManager():StartSummer()
		inst:DoPeriodicTask(0.3, function(inst) GetWorld().components.staticgenerator:Charge() end)
	else 
		print "In another world."
		GetSeasonManager():StartSummer()
	end
end	

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

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = weather_on
	inst.components.machine.turnofffn = weather_off

	return inst
end

return Prefab ("common/inventory/weather_machine", fn, assets) 
