BindGlobal()

local assets =
{
    Asset("ANIM", "anim/redjelly.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("redjelly") ),
    Asset( "IMAGE", inventoryimage_texture("redjelly") ),	

    Asset("ANIM", "anim/greenjelly.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("greenjelly") ),
    Asset( "IMAGE", inventoryimage_texture("greenjelly") ),   

    Asset("ANIM", "anim/crystalcandy.zip"),
    
    Asset( "ATLAS", inventoryimage_atlas("crystalcandy") ),
    Asset( "IMAGE", inventoryimage_texture("crystalcandy") ),    
}

local prefabs =
{
    "cloud_jelly"
}

-----

local redjellyhealth = 0

local redjellyhunger = 40

local redjellysanity = -20

-----

local greenjellyhealth = 20

local greenjellyhunger = 20

local greenjellysanity = -40

-----

local crystalcandyhealth = -20

local crystalcandyhunger = 10

local crystalcandysanity = 30

local function commonfn(inst)

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")

    inst:AddComponent("edible")

    inst:AddComponent("perishable")

    return inst

end

local function jellycommonfn(inst)
    local inst = commonfn()

    inst.components.stackable.maxsize = 10
    
    inst.components.edible.foodtype = "VEGGIE"   

    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "cloud_jelly"

    return inst
end

local function redjellyfn(inst)
    local inst = jellycommonfn()

    inst.AnimState:SetBuild("redjelly")
    inst.AnimState:PlayAnimation("closed")

    inst.components.inventoryitem.atlasname = inventoryimage_atlas("redjelly")
    
    inst.components.edible.healthvalue = redjellyhealth
    inst.components.edible.hungervalue = redjellyhunger
    inst.components.edible.sanityvalue = redjellysanity    

    return inst
end 

local function greenjellyfn(inst)
    local inst = jellycommonfn()

    inst.AnimState:SetBuild("greenjelly")
    inst.AnimState:PlayAnimation("closed")

    inst.components.inventoryitem.atlasname = inventoryimage_atlas("greenjelly")
    
    inst.components.edible.healthvalue = greenjellyhealth
    inst.components.edible.hungervalue = greenjellyhunger
    inst.components.edible.sanityvalue = greenjellysanity    

    return inst
end 

local function crystalcandyfn(inst)
    local inst = commonfn()

    inst.AnimState:SetBuild("crystalcandy")
    inst.AnimState:PlayAnimation("closed")

    inst.components.inventoryitem.atlasname = inventoryimage_atlas("crystalcandy")

    inst.components.stackable.maxsize = 10
    
    inst.components.edible.foodtype = "VEGGIE"   

    inst.components.edible.healthvalue = crystalcandyhealth
    inst.components.edible.hungervalue = crystalcandyhunger
    inst.components.edible.sanityvalue = crystalcandysanity 

    inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiledfood"

    return inst
end

return {
    Prefab ("common/inventory/redjelly", redjellyfn, assets),
    Prefab ("common/inventory/greenjelly", greenjellyfn, assets),
    Prefab ("common/inventory/crystalcandy", crystalcandyfn, assets),
}
