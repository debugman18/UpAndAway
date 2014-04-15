BindGlobal()


local assets=
{
	Asset("ANIM", "anim/golden_sunflower_seeds.zip"),

    Asset( "ATLAS", "images/inventoryimages/golden_sunflower_seeds.xml" ),
    Asset( "IMAGE", "images/inventoryimages/golden_sunflower_seeds.tex" ),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("flint")
    inst.AnimState:SetBuild("golden_sunflower_seeds")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/golden_sunflower_seeds.xml"
    
    return inst
end

return Prefab( "common/inventory/golden_sunflower_seeds", fn, assets) 
