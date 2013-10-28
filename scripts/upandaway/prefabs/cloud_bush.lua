--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/cloudbush.zip"),
}

local prefabs = 
{
    "cloud_cotton",
    "dug_marsh_bush",
}

local function ontransplantfn(inst)
	inst.components.pickable:MakeEmpty()
end

local function dig_up(inst, chopper)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab("cloud_cotton")
	end
	--local bush = inst.components.lootdropper:SpawnLootPrefab("dug_marsh_bush")
	inst:Remove()
end

local function onpickedfn(inst, picker)
	inst.AnimState:PlayAnimation("picking") 
	inst.AnimState:PushAnimation("idle")
	
	if picker.components.combat then
        picker.components.combat:GetAttacked(nil, 2)
	end
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("empty", true)
end


local function onunchargedfn(inst)
	inst:RemoveComponent("pickable")

	local anim = inst.AnimState
	anim:PlayAnimation("berries_more", true)
	anim:PushAnimation("berries", true)
	anim:PushAnimation("idle", true)
	anim:PlayAnimation("idle_dead", true)
end

local function onchargedfn(inst)
	inst.AnimState:PlayAnimation("berriesmost", true) 

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    inst.components.pickable:SetUp("candy_fruit", TUNING.MARSHBUSH_REGROW_TIME, 2)
	inst.components.pickable.onregenfn = onchargedfn
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    anim:SetBank("berrybush")
    anim:SetBuild("cloudbush")	
    anim:SetTime(math.random()*2)

    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)
	
	--inst.components.pickable.ontransplantfn = ontransplantfn

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)
    
    inst:AddComponent("inspectable")

	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetChargedFn(onchargedfn)
	inst.components.staticchargeable:SetUnchargedFn(onunchargedfn)


    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)


	onunchargedfn(inst)


    return inst
end

return Prefab( "cloudrealm/objects/cloud_bush", fn, assets, prefabs) 
