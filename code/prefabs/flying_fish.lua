BindGlobal()

local assets=
{
	Asset("ANIM", "anim/flying_fish.zip"),
    Asset( "ATLAS", "images/inventoryimages/flying_fish.xml" ),
    Asset( "IMAGE", "images/inventoryimages/flying_fish.tex" ),
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
	print("Todo, eventually, possibly.")
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


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


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
    inst.components.projectile:SetSpeed(2)
    inst.components.projectile:SetOnHitFn(onhit)

    inst:DoTaskInTime(0, function(inst, target)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 15, "crystal_water_broken")
        for k,v in pairs(ents) do
            if v and v.prefab == "crystal_water" and v:HasTag("crystal_water_broken") then
                local crystal = v
                print(crystal)
                if crystal then
			    	inst:DoTaskInTime(0, function()
			    		--inst.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
			    		inst.components.projectile:Throw(inst, crystal, inst)
			    	end)
			    end	
            end    
        end   
    end)    

	inst:AddComponent("inspectable")
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/flying_fish.xml"

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
	inst.components.inventoryitem:SetOnPickupFn(function(pickupguy) 
		inst:RemoveComponent("projectile") 
	end)
	inst.OnLoad = function() stopkicking(inst) end
	
	return inst
end

local function deadfn()
	local inst = commonfn()
	inst.Physics:Stop()
	--inst.AnimState:PlayAnimation("dead")
	inst.Physics:SetVel(0, 0, 0)
	
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)

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
    Prefab("common/inventory/flying_fish_dead", deadfn, assets, prefabs),
    Prefab("common/inventory/flying_fish_cooked", cookedfn, assets, prefabs),
}
