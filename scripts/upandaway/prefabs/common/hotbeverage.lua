--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local Lambda = wickerrequire 'paradigms.functional'
local Configurable = wickerrequire 'adjectives.configurable'


local cfg = Configurable "HOTBEVERAGE"


local function add_beverage_animstate(inst, data)
	local anim = inst.entity:AddAnimState()
	if data.bank then
		anim:SetBank(data.bank)
		if data.build then
			anim:SetBuild(data.build)
			if data.anim then
				if type(data.anim) == "table" then
					anim:PlayAnimation( unpack(data.anim) )
				else
					anim:PlayAnimation( data.anim )
				end
			end
		end
	end
	return anim
end

local function MakeBeverage(name, data)
	local assets = data.assets
	local prefabs = JoinArrays(data.prefabs or {}, {cfg:GetConfig("SPOILED_PREFAB")})

	local function basic_fn()
		local inst = CreateEntity()

		--[[
		-- Engine-level components.
		--]]

		inst.entity:AddTransform()
		add_beverage_animstate(inst, data)
		MakeInventoryPhysics(inst)

		
		--[[
		-- Components.
		--]]

		inst:AddComponent("inspectable")

		inst:AddComponent("inventoryitem")
		do
			local inventoryitem = inst.components.inventoryitem
			if data.inventory_atlas then
				inventoryitem.atlasname = data.inventory_atlas
			end
		end

		inst:AddComponent("perishable")
		do
			local perishable = inst.components.perishable

			perishable:SetPerishTime( data.perish_time or TUNING.PERISH_FAST )
			perishable.onperishreplacement = data.spoiled_prefab or cfg:GetConfig("SPOILED_PREFAB") or "spoiled_food"
			perishable:StartPerishing()
		end

		inst:AddComponent("edible")
		do
			local edible = inst.components.edible

			edible.healthvalue = data.health or 0
			edible.hungervalue = data.hunger or 0
			edible.sanityvalue = data.sanity or 0

			if data.foodtype then
				edible.foodtype = data.foodtype
			end
		end

		inst:AddComponent("temperature")
		do
			local temperature = inst.components.temperature

			-- Freezing point.
			temperature.mintemp = 0
			-- Boiling point.
			temperature.maxtemp = 100

			temperature.inherentinsulation = cfg:GetConfig("INHERENT_INSULATION") or 0

			if data.temperature then
				temperature.maxtemp = math.min( temperature.maxtemp, data.temperature )
				temperature:SetTemperature(data.temperature)
			end
		end

		inst:AddComponent("heatededible")
		do
			local heatededible = inst.components.heatededible

			heatededible:SetHeatCapacity(data.heat_capacity or 0.15)
		end

		return inst
	end

	local fn
	if data.postinit then
		local postinit = data.postinit
		fn = function()
			local inst = basic_fn()
			postinit(inst)
			return inst
		end
	else
		fn = basic_fn
	end

	return Prefab( "common/inventory/"..name, fn, assets, prefabs )
end

return MakeBeverage
