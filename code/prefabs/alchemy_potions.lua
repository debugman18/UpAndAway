BindGlobal()

local basic_assets = {

	--Asset("ANIM", "anim/alchemy_potion.zip"),

	--Asset( "ATLAS", "images/inventoryimages/potion_default.xml" ),
	--Asset( "IMAGE", "images/inventoryimages/potion_default.tex" ),
}

local basic_prefabs = {
	"potion_tunnel_mound",
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
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = 5

		inst:AddComponent("edible")
	    
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

local function make_triples()

	local function oneatenfn(inst, eater)

		local health_percent = eater.components.health:GetPercent() - .05
		local sanity_percent = eater.components.sanity:GetPercent() - .05
		local hunger_percent = eater.components.hunger:GetPercent() - .05

		print(health_percent)
		print(sanity_percent)
		print(hunger_percent)

		eater.components.health:SetPercent(hunger_percent)
		eater.components.sanity:SetPercent(health_percent)
		eater.components.hunger:SetPercent(sanity_percent)

	end

	return make_potion {

		name = "triples",
		anim = "triples",

		postinit = function(inst)

			print("This is the triples potion.")

			inst.components.edible:SetOnEatenFn(oneatenfn)

		end,
	}
end

local function make_bearded()

	local function oneatenfn(inst, eater)

		local beard_days = {4, 8, 16}
		local beard_bits = {1, 3,  9}

		if not eater.components.beard then

			eater:AddComponent("beard")
		    eater.components.beard.onreset = function()
		        eater.AnimState:ClearOverrideSymbol("beard")
		        eater:RemoveComponent("beard")
		        eater:RemoveComponent("beardedlady")
		    end
		    eater.components.beard.prize = "beardhair"

		    eater.components.beard:AddCallback(beard_days[3], function()
		        eater.AnimState:OverrideSymbol("beard", "beard", "beard_long")
		        eater.components.beard.bits = beard_bits[3]
		    end)		    

		end

		eater.components.beard.daysgrowth = 16

		local cb = eater.components.beard.callbacks[beard_days[3]]
		cb()

	end

	return make_potion {

		name = "bearded",
		anim = "bearded",

		postinit = function(inst)

			print("This is the bearded potion.")

			inst.components.edible:SetOnEatenFn(oneatenfn)

		end,
	}
end

local function make_tunnel()

	local function oneatenfn(inst, eater)

		if not inst:HasTag("underground") then
			eater:AddTag("notarget")
			eater.AnimState:SetMultColour(0,0,0,0)

			local dirtmound = SpawnPrefab("potion_tunnel_mound")
			dirtmound.Transform:SetPosition(eater.Transform:GetWorldPosition())

			local follower = dirtmound.entity:AddFollower()
			follower:FollowSymbol(inst.GUID, "swap_body", -15, -10, 0)
			eater:AddTag("underground")

			eater:DoTaskInTime(15, function()
	        	eater:RemoveTag("notarget")
	        	dirtmound:Remove()
	        	eater:RemoveTag("underground")
	        	eater.AnimState:SetMultColour(255,255,255,1)
			end)
		end
	end

	return make_potion {

		name = "tunnel",
		anim = "tunnel",

		postinit = function(inst)

			print("This is the tunnel potion.")

			inst.components.edible:SetOnEatenFn(oneatenfn)

		end,
	}
end

return {
	make_default(),
	make_triples(),
	make_bearded(),
	make_tunnel()
}
