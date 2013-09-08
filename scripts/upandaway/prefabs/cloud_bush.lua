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
	inst:Remove()
	local bush = inst.components.lootdropper:SpawnLootPrefab("dug_marsh_bush")
end

local function onpickedfn(inst, picker)
	inst.AnimState:PlayAnimation("picking") 
	inst.AnimState:PlayAnimation("empty")
	
	if picker.components.combat then
        picker.components.combat:GetAttacked(nil, 2)
	end
end

local function makeemptyfn(inst)
	local anim = inst.entity:AddAnimState()
	--inst.components.pickable:MakeEmpty()
end

local function onunchargefn(inst)
	local anim = inst.entity:AddAnimState()
	inst:RemoveComponent("pickable")
	anim:PlayAnimation("idle_dead")
	
	inst.charged = false
	
	return inst
end

local function onstaticfn(inst)
	inst.AnimState:PlayAnimation("berriesmost", true) 
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    
    inst.components.pickable:SetUp("candy_fruit", TUNING.MARSHBUSH_REGROW_TIME, 2)
	inst.components.pickable.onregenfn = onstaticfn
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

	inst.charged = true
	
	return inst
end

local function onsave(inst, data)
	data.charged = inst.charged	
end

local function onload(inst, data)
	if data and data.charged then
		inst.charged = data.charged
	end
	
	if inst.charged then
		onstaticfn(inst)
	else
		onunchargefn(inst)
	end
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
	--inst.charged = false

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)
    
    inst:AddComponent("inspectable")
	
	inst:ListenForEvent("upandaway_charge", function()
		print "Charged!"
		onstaticfn(inst)	
		return inst
	end, GetWorld())

	inst:ListenForEvent("upandaway_uncharge", function()
		print "Uncharged!"
		onunchargefn(inst)	
		return inst
	end, GetWorld())	
    
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    --------SaveLoad
    inst.OnSave = onsave 
    inst.OnLoad = onload 	
	
    return inst
end

return Prefab( "cloudrealm/objects/cloud_bush", fn, assets, prefabs) 