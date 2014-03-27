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

local loot = 
{
	"log",
	"log",
	"log",	
}

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("idle") 
end

local function makefullfn(inst)
	inst.AnimState:PlayAnimation("idle")
end


local function onpickedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	inst.AnimState:PlayAnimation("idle_harvested") 
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("idle_harvested")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("dragonblood_tree")
    inst.AnimState:SetBuild("dragonblood_tree")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	
	inst.components.pickable:SetUp("dragonblood_sap", TUNING.CAVE_BANANA_GROW_TIME)
	inst.components.pickable.onregenfn = onregenfn
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable.makefullfn = makefullfn

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(chopped)
    inst.components.workable:SetOnWorkCallback(chop)	

   	inst:AddComponent("lootdropper") 
   	inst.components.lootdropper:SetLoot(loot) 

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("dragonblood_tree.tex")	   	

	return inst
end

return Prefab ("common/inventory/dragonblood_tree", fn, assets, prefabs) 
