BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/ambrosia.zip"),

    Asset( "ATLAS", inventoryimage_atlas("ambrosia") ),
    Asset( "IMAGE", inventoryimage_texture("ambrosia") ),	
}

local function oneatfn(inst, eater)
    --Do we think 1 in 15 is balanced?
    if math.random(1,15) == 1 then
        TheMod:DebugSay("Ambrosia activated.")
        if eater.components.ambrosiabuffer then
            eater.components.ambrosiabuffer:Enable()
        else 
            eater:AddComponent("ambrosiabuffer")
            eater.components.ambrosiabuffer:Enable()
        end
    end
end	

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("ambrosia")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("ambrosia")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.AMBROSIA.FOODTYPE
    inst.components.edible.healthvalue = CFG.AMBROSIA.HEALTH_VALUE()
    inst.components.edible.hungervalue = CFG.AMBROSIA.HUNGER_VALUE()
    inst.components.edible.sanityvalue = CFG.AMBROSIA.SANITY_VALUE()
    inst.components.edible:SetOnEatenFn(oneatfn)

    return inst
end

return Prefab ("common/inventory/ambrosia", fn, assets) 
