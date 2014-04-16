BindGlobal()

local assets=
{
	Asset("ANIM", "anim/carrot.zip"),
    --Asset("ANIM", "anim/colored_corn.zip"),

    --Asset( "ATLAS", "images/inventoryimages/colored_corn.xml" ),
    --Asset( "IMAGE", "images/inventoryimages/colored_corn.tex" ),
}

local prefabs=
{
	"colored_corn",
}

local function onpickedfn(inst)
	inst:Remove()
end

local function fn(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
   
    inst.AnimState:SetBank("carrot")
    inst.AnimState:SetBuild("carrot")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("colored_corn", 10)
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    inst:AddComponent("inventoryitem") 
    inst.components.inventoryitem.atlasname = "images/inventoryimages/cloud_cotton.xml"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab( "common/inventory/colored_corn", fn, assets) 
