BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

	Asset( "ATLAS", "images/inventoryimages/package.xml" ),
	Asset( "IMAGE", "images/inventoryimages/package.tex" ),	
}

local function OnDroppedFn(inst, iteminside)
	local iteminside = inst.iteminside
	print(iteminside)
	local package = SpawnPrefab(iteminside) or SpawnPrefab("package")
	if package then
		package:SetPersistData(inst.itemdata)
		package.data = inst.metadata
		package.Transform:SetPosition(inst.Transform:GetWorldPosition())	
	end
	inst:Remove()
end	

local function OnLoad(inst, data)
	inst.itemdata = data.itemdata
	inst.iteminside = data.iteminside
end

local function OnSave(inst, data)
	data.itemdata = inst.itemdata
	data.iteminside = inst.iteminside
end

local function fn(Sim, iteminside)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	--inst.iteminside = nil
	print(inst.iteminside)
	inst.itemdata = {}
	inst.metadata = nil

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.atlasname = "images/inventoryimages/package.xml"
	inst.components.inventoryitem:SetOnDroppedFn(OnDroppedFn)

	inst:AddComponent("named")

    inst.OnSave = OnSave     
    inst.OnLoad = OnLoad	

	return inst
end

return Prefab ("common/inventory/package", fn, assets) 
