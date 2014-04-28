BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_algae.zip"),
}

local prefabs =
{
	"cloud_algae_fragment",
}

local loot =
{
	"cloud_algae_fragment",
	"cloud_algae_fragment",
	"cloud_algae_fragment",
}

local function OnDug(inst)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end	

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("cloud_algae.tex")
	    
	anim:SetBank("cloud_algae")
	anim:SetBuild("cloud_algae")
	anim:PlayAnimation("idle", true)
	inst.Transform:SetScale(1.5,1.5,1.5)

	MakeObstaclePhysics(inst, .8)

	inst:AddComponent("inspectable")

   	inst:AddComponent("lootdropper") 
   	inst.components.lootdropper:SetLoot(loot) 

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnDug) 

	return inst
end

return Prefab ("common/inventory/cloud_algae", fn, assets) 
