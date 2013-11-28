BindGlobal()

local assets =
{
    Asset("ANIM", "anim/trinkets.zip"),    
}

local prefabs =
{
   --"beak",
   --"feather",
}

local loot = 
{
    --"beak",
    --"feather",
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("trinkets")
    inst.AnimState:SetBuild("trinkets")
    inst.AnimState:PlayAnimation("trinkets_3")

	inst:AddComponent("inspectable")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(50)

	inst:AddComponent("inventoryitem")

	return inst
end

return Prefab ("common/inventory/live_gnome", fn, assets, prefabs) 
--As opposed to a dead gnome.
