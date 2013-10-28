--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/carrot.zip"),
}

local prefabs=
{
	"gustflower_seeds",
}

local function onpickedfn(inst)
	inst:Remove()
end

local function fn(Sim)
    --Carrot you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("carrot")
    inst.AnimState:SetBuild("carrot")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    

    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("gustflower_seeds", 1)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab( "common/inventory/gustflower", fn, assets) 
