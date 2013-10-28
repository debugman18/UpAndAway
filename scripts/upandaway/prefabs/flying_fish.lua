--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/flying_fish.zip"),
	--Asset("ANIM", "anim/flying_fish01.zip"),
}


local prefabs =
{
    "flying_fish_cooked",
    "spoiled_food",
}

local function stopkicking(inst)
    inst.AnimState:PlayAnimation("dead")
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
        
        inst:AddComponent("inspectable")
        
        inst:AddComponent("inventoryitem")
        
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
