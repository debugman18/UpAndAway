--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

    anim:SetBank("crow")
    anim:SetBuild("crow_build")
    anim:PlayAnimation("idle")
        
    inst:AddComponent("locomotor")
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
	inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbird")
    
    local brain = require "brains/birdbrain"
    inst:SetBrain(brain)    

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	
	--Mantas will sail overhead. I think the only way to attack one would be to use a ranged weapon. 
	--If attacked, they will go offscreen and come back lower, to sail past the player.
		
	return inst
end

return Prefab ("common/inventory/manta", fn, assets) 
