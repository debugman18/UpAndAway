--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

assets = 
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
	--marble drops
	"crystal_fragment",
}

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.AnimState:SetRayTestOnBB(true)

	MakeObstaclePhysics(inst, 0.66)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"crystal_fragment"})
	inst.components.lootdropper:AddChanceLoot("crystal_fragment", 0.33)

	anim:SetBank("crystal")
	anim:SetBuild("crystal")
	anim:PlayAnimation("crystal_spire")

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon( "statue_small.png" )

	inst:AddComponent("inspectable")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	
	--[[
	inst.components.workable:SetOnWorkCallback(          
		function(inst, worker, workleft)
	        local pt = Point(inst.Transform:GetWorldPosition())
	        if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
	            inst.components.lootdropper:DropLoot(pt)
	            inst:Remove()
	        else	            
	            if workleft < TUNING.MARBLEPILLAR_MINE*(1/3) then
	                inst.AnimState:PlayAnimation("low")
	            elseif workleft < TUNING.MARBLEPILLAR_MINE*(2/3) then
	                inst.AnimState:PlayAnimation("med")
	            else
	                inst.AnimState:PlayAnimation("full")
	            end
	        end
	    end)

	--]]
	    
	return inst
end

return Prefab("cloudrealm/objects/crystal_spire", fn, assets, prefabs) 
