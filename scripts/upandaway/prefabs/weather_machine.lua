--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function OnActivate(inst)
	if GetWorld() and GetWorld():HasTag("cloudrealm") then
		print "In cloudrealm."
		GetSeasonManager():StartSummer()
		GetWorld().components.staticgenerator:Charge()
	else 
		print "In another world."
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

	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate	

	return inst
end

return Prefab ("common/inventory/weather_machine", fn, assets) 
