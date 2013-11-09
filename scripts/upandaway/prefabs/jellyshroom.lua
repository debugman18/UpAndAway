--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local Configurable = wickerrequire 'adjectives.configurable'
local goodcfg = Configurable("SKYFLOWER")

local assets =
{
	Asset("ANIM", "anim/jelly shrooms.zip"),
	Asset("ANIM", "anim/jelly caps.zip"),
}

local function redfn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Redjellyshroom") 
	inst.AnimState:SetBuild("jelly shrooms")    
    inst.AnimState:PlayAnimation("idle")	
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

	inst:AddComponent("inspectable")    

    return inst
end	

local function greenfn(inst)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Greenjellyshroom") 
	inst.AnimState:SetBuild("jelly shrooms")    
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

	inst:AddComponent("inspectable")    

    return inst	
end	

local function bluefn(inst)	
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Bluejellyshroom") 
	inst.AnimState:SetBuild("jelly shrooms")    
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )	

	inst:AddComponent("inspectable")   

    return inst
end	

local function pickedfn_red(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Redjellycap")
	inst.AnimState:SetBuild("jelly caps")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")	
	
	return inst
end	

local function pickedfn_blue(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Bluejellycap")
	inst.AnimState:SetBuild("jelly caps")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")	
	
	return inst
end	

local function pickedfn_green(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("Greenjellycap")
	inst.AnimState:SetBuild("jelly caps")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")	
	
	return inst
end	

return {
	Prefab ("cloudrealm/flora/jellyshroom_red", redfn, assets),
	Prefab ("cloudrealm/flora/jellyshroom_green", greenfn, assets),
	Prefab ("cloudrealm/flora/jellyshroom_blue", bluefn, assets),		

	Prefab ("cloudrealm/inventory/jellycap_red", pickedfn_red, assets),
	Prefab ("cloudrealm/inventory/jellycap_green", pickedfn_green, assets),
	Prefab ("cloudrealm/inventory/jellycap_blue", pickedfn_blue, assets),
}	   