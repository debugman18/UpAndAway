BindGlobal()

local basic_assets = {

	--Asset("ANIM", "anim/alchemy_potion.zip"),

	--Asset( "ATLAS", "images/inventoryimages/potion_default.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/potion_default.tex" ),
}

local basic_prefabs = {
	
}

local function make_potion(data)
	local assets = _G.JoinArrays(basic_assets, data.assets or {})
	local prefabs = _G.JoinArrays(basic_prefabs, data.prefabs or {})

	local postinit = data.postinit or data.custom_fn

	local function fn()
		local inst = CreateEntity()
		inst.entity:AddTransform()

		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		MakeInventoryPhysics(inst)
		
		anim:SetBank(data.bank or "potion_default")
		anim:SetBuild(data.build or "potion_default")
		anim:PlayAnimation(data.anim)

		inst:AddComponent("inspectable")
		
		inst:AddComponent("inventoryitem")

	   	inst:AddComponent("stackable")
		inst.components.stackable.maxsize = 5
	    
		inst:AddComponent("inventoryitem")
		--inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_"..data.name..".xml"

		if postinit then
			postinit(inst)
		end
		
		return inst
	end

	return Prefab( "common/inventory/potion_"..data.name, fn, assets, prefabs)
end

local function make_default()

	return make_potion {
	
		name = "default",
		anim = "default",

		postinit = function(inst)
			print("This is a default potion.")
		end,

	}
end

return {
	make_default()
}
