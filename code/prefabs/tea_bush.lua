BindGlobal()


local Configurable = wickerrequire 'adjectives.configurable'

local cfg = Configurable("TEA_BUSH")


local function ontransplantfn(inst)
	inst.components.pickable:MakeBarren()
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("idle_dead", true)
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			local percent = 0
			if inst.components.pickable then
				percent = inst.components.pickable.cycles_left / inst.components.pickable.max_cycles
			end
			if percent >= .9 then
				return "berriesmost"
			elseif percent >= .33 then
				return "berriesmore"
			else
				return "berries"
			end
		else
			if inst.components.pickable:IsBarren() then
				return "idle_dead"
			else
				return "idle_dead"
			end
		end
	end

	return "idle_dead"
end


local function shake(inst)
    if inst.components.pickable and inst.components.pickable:CanBePicked() then
        inst.AnimState:PlayAnimation("shake")
    else
        inst.AnimState:PlayAnimation("shake_empty")
    end
	inst.AnimState:PushAnimation(pickanim(inst), false)
end

local function onpickedfn(inst, picker)

	if inst.components.pickable then
		local old_percent = (inst.components.pickable.cycles_left+1) / inst.components.pickable.max_cycles

		if old_percent >= .9 then
			inst.AnimState:PlayAnimation("berriesmost_picked")
		elseif old_percent >= .33 then
			inst.AnimState:PlayAnimation("berriesmore_picked")
		else
			inst.AnimState:PlayAnimation("berries_picked")
		end

		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle_dead")
		end
	end
end

local function getregentimefn(inst)
	if inst.components.pickable then
		local num_cycles_passed = math.min(inst.components.pickable.max_cycles - inst.components.pickable.cycles_left, 0)
		return TUNING.BERRY_REGROW_TIME + TUNING.BERRY_REGROW_INCREASE*num_cycles_passed+ math.random()*TUNING.BERRY_REGROW_VARIANCE
	else
		return TUNING.BERRY_REGROW_TIME
	end
	
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation(pickanim(inst))
end

local function makebarrenfn(inst)
	inst.AnimState:PlayAnimation("idle_dead")
end

local function makefullfn(inst)
	inst.AnimState:PlayAnimation(pickanim(inst))
end

local function dig_up(inst, chopper)	
	inst:Remove()
	if inst.components.pickable and inst.components.lootdropper then
	
		if inst.components.pickable:IsBarren() then
			inst.components.lootdropper:SpawnLootPrefab("twigs")
			inst.components.lootdropper:SpawnLootPrefab("twigs")
		else
			
			if inst.components.pickable and inst.components.pickable:CanBePicked() then
				inst.components.lootdropper:SpawnLootPrefab("tea_leaves")
			end
			
			inst.components.lootdropper:SpawnLootPrefab("dug_berrybush")
		end
	end	
end

local assets =
{
	Asset("ANIM", "anim/tea_bush.zip"),
}

local prefabs =
{
	"tea_leaves",
	"dug_berrybush",
	"twigs",
}   

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local minimap = inst.entity:AddMiniMapEntity()

	inst:AddTag("bush")

	MakeObstaclePhysics(inst, .1)
   
	anim:SetBank("berrybush")
	anim:SetBuild("tea_bush")
	anim:PlayAnimation("berriesmost", false)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("tea_bush.tex")	
	
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
	inst.components.pickable:SetUp("tea_leaves", cfg:GetConfig("REGROW_TIME"))

	inst.components.pickable.getregentimefn = getregentimefn
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.ontransplantfn = ontransplantfn
	inst.components.pickable.max_cycles = cfg:GetConfig("CYCLES") + math.random(2)
	inst.components.pickable.cycles_left = inst.components.pickable.max_cycles
	
	
	MakeLargeBurnable(inst)
	MakeLargePropagator(inst)
	
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("inspectable")
	
	--MakeSnowCovered(inst, .01)
	return inst
end

return Prefab( "common/objects/tea_bush", fn, assets, prefabs)	
