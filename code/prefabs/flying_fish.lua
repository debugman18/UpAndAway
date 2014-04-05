BindGlobal()

local assets=
{
	Asset("ANIM", "anim/flying_fish.zip"),
}

local prefabs =
{
    "flying_fish_cooked",
    "spoiled_food",
}

local function OnWorked(inst, worker)
    if worker.components.inventory then
        worker.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
    end
end

local function onhit(inst, attacker, target)
    local impactfx = SpawnPrefab("splash")
    impactfx.Transform:SetPosition(attacker.Transform:GetWorldPosition())
    inst:Remove()
end

local function stopkicking(inst)
    inst.AnimState:PlayAnimation("dead")
    inst:RemoveTag("flying_fish")
end

local function commonfn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	
	MakeInventoryPhysics(inst)
	
	inst.entity:AddAnimState()
	inst.AnimState:SetBank("fish")
	inst.AnimState:SetBuild("flying_fish")
	--inst.build = build --This is used within SGwilson, sent from an event in fishingrod.lua
	
	inst:AddTag("meat")
	inst:AddTag("flying_fish")

	inst:AddComponent("edible")
	inst.components.edible.ismeat = true
	inst.components.edible.foodtype = "MEAT"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("bait")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(8)
    inst.components.projectile:SetOnHitFn(onhit)
    local crystal = GetClosestInstWithTag("crystal_water_broken", inst, 10)
    if crystal then
    	inst:DoTaskInTime(2, function()
    		inst.components.projectile.target = crystal
    		inst.components.projectile:Throw(inst, target, inst)
    	end)	
    end	
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.NET)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	inst.data = {}

	return inst
end

local function rawfn()
	local inst = commonfn()
	inst.AnimState:PlayAnimation("idle", true)


	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SUPERFAST)
	
	inst:AddComponent("cookable")
	inst.components.cookable.product = "flying_fish_cooked"
	inst:AddComponent("dryable")
	inst.components.dryable:SetProduct("smallmeat_dried")
	inst.components.dryable:SetDryTime(TUNING.DRY_FAST)
	inst:DoTaskInTime(5, stopkicking)
	inst.components.inventoryitem:SetOnPickupFn(function(pickupguy) stopkicking(inst) end)
	inst.OnLoad = function() stopkicking(inst) end
	
	return inst
end

local function cookedfn()
	local inst = commonfn()
	inst.AnimState:PlayAnimation("cooked")
	
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)

	return inst
end

return {
    Prefab("common/inventory/flying_fish", rawfn, assets, prefabs),
    Prefab("common/inventory/flying_fish_cooked", cookedfn, assets, prefabs),
}
