BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/flying_fish.zip"),
    Asset( "ATLAS", inventoryimage_atlas("flying_fish") ),
    Asset( "IMAGE", inventoryimage_texture("flying_fish") ),
}

local prefabs = CFG.FLYING_FISH.PREFABS

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
    inst.components.stackable.maxsize = CFG.FLYING_FISH.STACK_SIZE

    inst:AddComponent("bait")
    
    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.FLYING_FISH.RAW_PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.FLYING_FISH.ONPERISH_ITEM

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(CFG.FLYING_FISH.PROJECTILE_SPEED)
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
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("flying_fish")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(CFG.FLYING_FISH.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(OnWorked)
    
    inst:AddComponent("tradable")
    inst.components.tradable.goldvalue = CFG.FLYING_FISH.GOLD_VALUE
    inst.data = {}

    return inst
end

local function rawfn()
    local inst = commonfn()
    inst.AnimState:PlayAnimation("idle", true)

    inst.components.edible.healthvalue = CFG.FLYING_FISH.RAW_HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.FLYING_FISH.RAW_HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.FLYING_FISH.RAW_SANITY_VALUE

    inst.components.perishable:SetPerishTime(CFG.FLYING_FISH.RAW_PERISH_TIME)
    
    inst:AddComponent("cookable")
    inst.components.cookable.product = CFG.FLYING_FISH.COOKED_PRODUCT

    inst:AddComponent("dryable")
    inst.components.dryable:SetProduct(CFG.FLYING_FISH.DRIED_PRODUCT)
    inst.components.dryable:SetDryTime(CFG.FLYING_FISH.DRY_TIME)

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
    
    inst.components.edible.healthvalue = CFG.FLYING_FISH.DEAD_HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.FLYING_FISH.DEAD_HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.FLYING_FISH.DEAD_SANITY_VALUE

    inst.components.perishable:SetPerishTime(CFG.FLYING_FISH.DEAD_PERISH_TIME)

    return inst
end

local function cookedfn()
    local inst = commonfn()
    inst.AnimState:PlayAnimation("cooked")
    
    inst.components.edible.healthvalue = CFG.FLYING_FISH.COOKED_HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.FLYING_FISH.COOKED_HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.FLYING_FISH.COOKED_SANITY_VALUE

    inst.components.perishable:SetPerishTime(CFG.FLYING_FISH.COOKED_PERISH_TIME)

    return inst
end

return {
    Prefab("common/inventory/flying_fish", rawfn, assets, prefabs),
    Prefab("common/inventory/flying_fish_dead", deadfn, assets, prefabs),
    Prefab("common/inventory/flying_fish_cooked", cookedfn, assets, prefabs),
}
