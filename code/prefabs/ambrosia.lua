BindGlobal()

local assets =
{
	Asset("ANIM", "anim/ambrosia.zip"),

	Asset( "ATLAS", "images/inventoryimages/ambrosia.xml" ),
	Asset( "IMAGE", "images/inventoryimages/ambrosia.tex" ),	
}

local function oneatfn(inst, eater)
	if math.random(1,15) == 1 then
		if eater.components.ambrosiarespawn then
			TheMod:DebugSay("Free respawn. Lucky you.")
			eater.components.ambrosiarespawn:Enable()
		end	
	else
		TheMod:DebugSay("No respawn for you.")
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
	inst.components.inventoryitem.atlasname = "images/inventoryimages/ambrosia.xml"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"
    inst.components.edible.healthvalue = math.random(-40,20)
    inst.components.edible.hungervalue = math.random(-40,20)
    inst.components.edible.sanityvalue = math.random(-40,20)
    inst.components.edible:SetOnEatenFn(oneatfn)

	return inst
end

return Prefab ("common/inventory/ambrosia", fn, assets) 
