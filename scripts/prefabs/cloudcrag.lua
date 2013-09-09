local cloudcrag1_assets =
{
	Asset("ANIM", "anim/cloudcrag.zip"),
}

local cloudcrag2_assets =
{
	Asset("ANIM", "anim/rock2.zip"),
}

local cloudcrag3_assets =
{
	Asset("ANIM", "anim/rock_flintless.zip"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "flint",
    "goldnugget",
}    

local function common(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	MakeObstaclePhysics(inst, 1.)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("rock.png")

	inst:AddComponent("lootdropper") 
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)
			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				inst:Remove()
			else
				
				
				if workleft < TUNING.ROCKS_MINE*(1/3) then
					inst.AnimState:PlayAnimation("low")
				elseif workleft < TUNING.ROCKS_MINE*(2/3) then
					inst.AnimState:PlayAnimation("med")
				else
					inst.AnimState:PlayAnimation("full")
				end
			end
		end)         

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "Cloud Crag"
	MakeSnowCovered(inst, .01)        
	return inst
end

local function cloudcrag(Sim)
	local inst = common(Sim)
	inst.AnimState:SetBank("rock")
	inst.AnimState:SetBuild("cloudcrag")
	inst.AnimState:PlayAnimation("full")

	inst.components.lootdropper:SetLoot({"cloud_cotton"})
	return inst
end
--[[
local function cloudcrag2(Sim)
	local inst = common(Sim)
	inst.AnimState:SetBank("rock2")
	inst.AnimState:SetBuild("rock2")
	inst.AnimState:PlayAnimation("full")

	inst.components.lootdropper:SetLoot({"rocks", "rocks", "rocks", "goldnugget", "flint"})
	inst.components.lootdropper:AddChanceLoot("goldnugget", 0.25)
	inst.components.lootdropper:AddChanceLoot("flint", 0.6)
	return inst
end

local function cloudcrag3(Sim)
	local inst = common(Sim)
	inst.AnimState:SetBank("rock_flintless")
	inst.AnimState:SetBuild("rock_flintless")
	inst.AnimState:PlayAnimation("full")

	inst.components.lootdropper:SetLoot({"rocks", "rocks", "rocks", "rocks"})
	inst.components.lootdropper:AddChanceLoot("rocks", 0.6)
	return inst
end
--]]
return Prefab("forest/objects/rocks/cloudcrag", cloudcrag, cloudcrag1_assets, prefabs)
       --Prefab("forest/objects/rocks/rock2", rock2_fn, rock2_assets, prefabs),
       --Prefab("forest/objects/rocks/rock_flintless", rock_flintless_fn, rock_flintless_assets, prefabs) 