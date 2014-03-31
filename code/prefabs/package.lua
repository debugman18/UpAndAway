BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

	--Asset( "ATLAS", "images/inventoryimages/package.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/package.tex" ),	
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

local function fn(Sim, iteminside)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.iteminside = nil
	print(iteminside)
	inst.itemdata = {}
	inst.metadata = nil

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	--inst.components.inventoryitem.atlasname = "images/inventoryimages/package.xml"
	inst.components.inventoryitem:SetOnDroppedFn(OnDroppedFn)

	inst:AddComponent("named")

	inst:DoTaskInTime(2, function(iteminside)
		local iteminside = inst.iteminside
		if iteminside and not iteminside == nil then
			local itemname = iteminside:GetDisplayName()
			inst.components.named:SetName("Packaged " .. _G.strings.names.itemname)
		else 
			inst.components.named:SetName("Empty Package") 
		end
	end)

	return inst
end

return Prefab ("common/inventory/package", fn, assets) 
