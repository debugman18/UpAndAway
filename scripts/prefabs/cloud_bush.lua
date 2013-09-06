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
	inst.AnimState:PushAnimation("picked", false)
	--[[
	if picker.components.combat then
        picker.components.combat:GetAttacked(nil, TUNING.MARSHBUSH_DAMAGE)
	end
	--]]
end

local function onstaticfn(inst)
	inst.AnimState:PlayAnimation("berriesmost", false) 
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("idle_dead")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    anim:SetBank("berrybush")
    anim:SetBuild("cloudbush")	
	anim:PlayAnimation("empty")
    anim:PlayAnimation("idle", true)
    anim:SetTime(math.random()*2)

    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_sticks"
    
    inst.components.pickable:SetUp("candy_fruit", TUNING.MARSHBUSH_REGROW_TIME, 2)
	inst.components.pickable.onregenfn = onstaticfn
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.ontransplantfn = ontransplantfn
	inst.components.pickable:MakeEmpty()

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
    
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    return inst
end

return Prefab( "marsh/objects/cloud_bush", fn, assets, prefabs) 