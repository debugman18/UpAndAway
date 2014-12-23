BindGlobal()

local AlchemyRecipeBook = modrequire 'resources.alchemy_recipebook'

local widget_spec = pkgrequire "common.containerwidgetspecs" .cauldron


local assets =
{
	Asset("ANIM", "anim/cauldron.zip"),
}


local valid_extra_ingredients = {
	bonestew = true,
	cloud_jely = true,
	jellycap_red = true,
	jellycap_blue = true,
	jellycap_green = true,
	golden_petals = true,
	nightmarefuel = true,
	rocks = true,
	marble = true,
	poop = true,
	beardhair = true,
	dragonblood_log = true,
}
local function itemtest(inst, item, slot)
	return (item:HasTag("alchemy"))
		or Game.IsEdible(item)
		or (item.prefab and valid_extra_ingredients[item.prefab])
end
widget_spec:SetItemTestFn(itemtest)


local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("cauldron")
	inst.AnimState:SetBuild("cauldron")
	inst.AnimState:PlayAnimation("idle")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cauldron.tex")	


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("brewer")
	do
		local brewer = inst.components.brewer

		brewer:SetRecipeBook(AlchemyRecipeBook)
	end

	inst:AddComponent("inspectable")
		
	inst:AddComponent("container")
	do
		local container = inst.components.container

		widget_spec:ConfigureEntity(inst)

		--container.onopenfn = onopen
		--container.onclosefn = onclose
	end

	return inst
end

return Prefab ("common/inventory/cauldron", fn, assets) 
