--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function FindTargetOfInterest(inst)

	if not inst.harassplayer and not inst.components.combat.target then
		local m_pt = inst:GetPosition()
	    local target = GetPlayer()
		if target and target.components.inventory and distsq(m_pt, target:GetPosition()) < 5*5 then			
			local interest_chance = 0
			local item = target.components.inventory:FindItem(function(item) return item.prefab == "magnet" end )

			if item then
				-- Follow the player because he has a magnet.
				interest_chance = 1 
			end
			if math.random() < interest_chance then

				inst.harassplayer = true
				inst:DoTaskInTime(120, function() inst.harassplayer = false end)
			end			
		end
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")

	return inst
end

return Prefab ("common/inventory/ball_lightning", fn, assets) 
