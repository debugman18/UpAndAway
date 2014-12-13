BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_jelly.zip"),

    Asset( "ATLAS", "images/inventoryimages/cloud_jelly.xml" ),
    Asset( "IMAGE", "images/inventoryimages/cloud_jelly.tex" ),
}

local function FuelTaken(inst, taker)
    local cloud = SpawnPrefab("poopcloud")
    if cloud then
    	cloud.AnimState:SetMultColour(130,10,10,.5)
        cloud.Transform:SetPosition(taker.Transform:GetWorldPosition() )
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("icebox")
	inst.AnimState:SetBuild("cloud_jelly")
	inst.AnimState:PlayAnimation("closed")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = -5
    inst.components.edible.hungervalue = 15
    inst.components.edible.sanityvalue = -5

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "ash"    

	inst:AddComponent("inspectable")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = 5
    inst.components.fuel:SetOnTakenFn(FuelTaken)

	inst:AddTag("alchemy")

	inst:AddTag("jelly")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_jelly.xml"

	return inst
end

return Prefab ("common/inventory/cloud_jelly", fn, assets) 
