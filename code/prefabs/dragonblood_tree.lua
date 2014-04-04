BindGlobal()

local assets =
{
	Asset("ANIM", "anim/dragonblood_tree.zip"),
}

local prefabs =
{
	"dragonblood_sap",
	"log",
}

local function chopped(inst)
	--
end

local function chop(inst)
	--
end

local short_loot = 
{
	"dragonblood_log",	
}

local normal_loot = 
{
	"dragonblood_log",
	"dragonblood_log",	
}

local tall_loot = 
{
	"dragonblood_log",
	"dragonblood_log",
	"dragonblood_log",		
}

local function SetShort(inst)
    if inst.components.workable then
	    inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
	end
	if not inst.components.lootdropper then
		inst:AddComponent("lootdropper")
	end	
    inst.components.lootdropper:SetLoot(short_loot)
    inst.Transform:SetScale(0.6, 0.6, 0.6)
    inst.AnimState:PlayAnimation("idle_harvested")
end

local function GrowShort(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")          
end

local function SetNormal(inst)
    if inst.components.workable then
	    inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_NORMAL)
	end
	if not inst.components.lootdropper then
		inst:AddComponent("lootdropper")
	end		
    inst.components.lootdropper:SetLoot(normal_loot)
    inst.Transform:SetScale(0.8, 0.8, 0.8)
    inst.AnimState:PlayAnimation("idle_harvested")
end

local function GrowNormal(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local function SetTall(inst)
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_TALL)
	end
	if not inst.components.lootdropper then
		inst:AddComponent("lootdropper")
	end		
    inst.components.lootdropper:SetLoot(tall_loot)
    inst.Transform:SetScale(1, 1, 1)
end

local function GrowTall(inst)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")          
end

local growth_stages =
{
    {name="short", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end , leifscale=.7 },
    {name="normal", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, TUNING.EVERGREEN_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end, leifscale=1 },
    {name="tall", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, TUNING.EVERGREEN_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end, leifscale=1.25 },
}

local function fn(Sim, stage)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	if stage == nil then
		stage = math.random(1,3)
	end

	local l_stage = stage
	if l_stage == 0 then
		l_stage = math.random(1,3)
	end	

    inst.AnimState:SetBank("dragonblood_tree")
    inst.AnimState:SetBuild("dragonblood_tree")
    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

	inst:AddComponent("growable")
    inst.components.growable.stages = growth_stages
    inst.components.growable:SetStage(l_stage)
    inst.components.growable.loopstages = true
    inst.components.growable:StartGrowing()

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(chopped)
    inst.components.workable:SetOnWorkCallback(chop)	

   	inst:AddComponent("lootdropper") 

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("dragonblood_tree.tex")

    inst:ListenForEvent("onremove", removesockets)	   	

	return inst
end

return Prefab ("common/inventory/dragonblood_tree", fn, assets, prefabs) 
