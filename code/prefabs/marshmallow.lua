BindGlobal()

local assets =
{
    Asset("ANIM", "anim/marshmallow.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("marshmallow") ),
    Asset( "IMAGE", inventoryimage_texture("marshmallow") ),	
}

local prefabs =
{
    "smores",
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    anim:SetBank("icebox")
    anim:SetBuild("marshmallow")
    anim:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
 
    inst:AddComponent("inspectable")  
    
    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("marshmallow")
    
    --Is not filling.
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -8
    inst.components.edible.hungervalue = 16
    inst.components.edible.sanityvalue = 10

    inst:AddComponent("cookable")
    inst.components.cookable.product = "smores"    
    
    return inst
end

return Prefab("common/inventory/marshmallow", fn, assets, prefabs) 
