--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/scarecrow.zip"),
}

local prefabs =
{
	"cheshire",
}

local function OnSpawn(inst)
	local bird = SpawnPrefab("bird_paradise")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("scarecrow")
	inst.AnimState:SetBuild("scarecrow")
	inst.AnimState:PlayAnimation("idle_loop",true)

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "cheshire"
	inst.components.childspawner:SetSpawnedFn(OnSpawn)
	--inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*20)
	inst.components.childspawner:SetSpawnPeriod(60)
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:StartSpawning()	

	return inst
end

return Prefab ("common/inventory/scarecrow", fn, assets, prefabs) 
