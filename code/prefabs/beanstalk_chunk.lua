BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/beanstalk_chunk.zip"),

    Asset( "ATLAS", inventoryimage_atlas("beanstalk_chunk") ),
    Asset( "IMAGE", inventoryimage_texture("beanstalk_chunk") ),
}

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("marble")
    inst.AnimState:SetBuild("beanstalk_chunk")
    inst.AnimState:PlayAnimation("anim")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.BEANSTALK_CHUNK.MAX_SIZE

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("beanstalk_chunk")

    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = CFG.BEANSTALK_CHUNK.REPAIR_MATERIAL
    inst.components.repairer.healthrepairvalue = CFG.BEANSTALK_CHUNK.REPAIR_VALUE

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.BEANSTALK_CHUNK.FUEL_VALUE

    inst:AddTag("beanstalk_chunk")

    inst:AddComponent("tradable")	

    return inst
end

return Prefab ("common/inventory/beanstalk_chunk", fn, assets) 
