--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local prefabs =
{
   --"beak",
   --"feather",
}

local loot = 
{
    --"beak",
    --"feather",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("sky_octopus")
	inst.AnimState:SetBuild("sky_octopus")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)	

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	return inst
end

return Prefab ("common/inventory/octocopter", fn, assets, prefabs) 
