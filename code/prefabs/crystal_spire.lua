BindGlobal()

assets = 
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
	--marble drops
	"crystal_fragment_spire",
}

local loot = 
{
   "crystal_fragment_spire",
}

local function onMined(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

	inst:Remove()	
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.AnimState:SetRayTestOnBB(true)

	MakeObstaclePhysics(inst, 0.66)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(loot)
	inst.components.lootdropper:AddChanceLoot("crystal_fragment_spire", 0.33)

	inst:AddTag("crystal")

	anim:SetBank("crystal")
	anim:SetBuild("crystal")
	anim:PlayAnimation("crystal_spire")

	inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon( "statue_small.png" )

    local basescale = math.random(8,14)
    local scale = basescale / 10
    inst.Transform:SetScale(scale, scale, scale)

	inst:AddComponent("inspectable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnFinishCallback(onMined)
	    
	return inst
end

return Prefab("cloudrealm/objects/crystal_spire", fn, assets, prefabs) 
