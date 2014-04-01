BindGlobal()

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),

	Asset( "ATLAS", "images/inventoryimages/package.xml" ),
	Asset( "IMAGE", "images/inventoryimages/package.tex" ),	
}

local function do_unpack(inst)
	if inst.components.packer:Unpack() then
		inst:Remove()
	end
end	

local function get_name(inst)
	local basename = inst.components.packer:GetName()
	if basename then
		return "Packaged "..basename
	else
		return "Unknown Package"
	end
end

local function fn(Sim, iteminside)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("packer")
	do
		local packer = inst.components.packer

		-- Filter out things like this:
		--[[
		packer:SetCanPackFn(function(target, inst)
			-- stuff
		end)
		]]--
	end

	inst:AddComponent("deployable")
	do
		local deployable = inst.components.deployable

		deployable.ondeploy = do_unpack
	end

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.atlasname = "images/inventoryimages/package.xml"

	inst.displaynamefn = get_name

	return inst
end

return Prefab ("common/inventory/package", fn, assets) 
