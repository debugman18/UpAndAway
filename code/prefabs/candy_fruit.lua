BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/cloudcotton.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("candy_fruit") ),
    Asset( "IMAGE", inventoryimage_texture("candy_fruit") ),	
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("berries")
    anim:SetBuild("candy_fruit")
    anim:PlayAnimation("idle")
    trans:SetScale(0.4, 0.6, 0.6)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CANDY_FRUIT.STACK_SIZE
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("candy_fruit")
    
    --Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.CANDY_FRUIT.FOODTYPE
    inst.components.edible.healthvalue = CFG.CANDY_FRUIT.HEALTH_VALUE
    inst.components.edible.hungervalue = CFG.CANDY_FRUIT.HUNGER_VALUE
    inst.components.edible.sanityvalue = CFG.CANDY_FRUIT.SANITY_VALUE

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(CFG.CANDY_FRUIT.PERISH_TIME)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = CFG.CANDY_FRUIT.PERISH_ITEM 

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5

    return inst
end

return Prefab("common/inventory/candy_fruit", fn, assets) 
