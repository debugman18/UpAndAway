--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
   "crystal_fragment_quartz",
}

local loot = 
{
   "crystal_fragment_quartz",
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

	inst.AnimState:SetBank("crystal")
	inst.AnimState:SetBuild("crystal")
    inst.AnimState:PlayAnimation("crystal_quartz")

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

return Prefab ("common/inventory/crystal_quartz", fn, assets, prefabs) 
