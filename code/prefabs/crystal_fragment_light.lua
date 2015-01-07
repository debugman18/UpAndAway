BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal_fragment_light.zip"),

    Asset( "ATLAS", inventoryimage_atlas("crystal_fragment_light") ),
    Asset( "IMAGE", inventoryimage_texture("crystal_fragment_light") ),		
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("icebox")
    inst.AnimState:SetBuild("crystal_fragment_light")
    inst.AnimState:PlayAnimation("closed")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    --inst.Transform:SetScale(.6,.6,.6)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CRYSTAL_FRAGMENT.STACK_SIZE

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("crystal_fragment_light")	

    inst:AddTag("crystal")	

    inst:AddComponent("fuel")
    inst.components.fuel.fueltype = CFG.CRYSTAL_FRAGMENT.FUEL_TYPE
    inst.components.fuel.fuelvalue = CFG.CRYSTAL_FRAGMENT.FUEL_VALUE

    return inst
end

return Prefab ("common/inventory/crystal_fragment_light", fn, assets) 
