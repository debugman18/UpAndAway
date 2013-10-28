--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/rock_stalagmite.zip"),
}

local prefabs =
{
   "crystal_water_fragment",
}

local loot = 
{
   "crystal_water_fragment",
}

local function onMined(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("rock_stalagmite")
	inst.AnimState:SetBuild("rock_stalagmite")
    inst.AnimState:PlayAnimation("full")

	inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot) 	

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnFinishCallback(onMined)
	--inst.components.workable:SetOnWorkCallback(onhit)	    

	return inst
end

return Prefab ("common/inventory/crystal_water", fn, assets, prefabs) 
