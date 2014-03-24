BindGlobal()
local assets =
{
	Asset("ANIM", "anim/pinecone.zip"),
}

local prefabs = 
{
	"beanstalk",
}

local function GrowBeanstalk(inst)
	local tree = SpawnPrefab("beanstalk") 
    if tree then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition() ) 
		inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge") 
		inst.AnimState:PlayAnimation("emerge")		
        inst.AnimState:PushAnimation("idle", "loop")		
		GetPlayer().AnimState:PlayAnimation("wakeup")
        inst:Remove()
	end
end

local function plant(inst, growtime)
    inst.AnimState:PlayAnimation("idle_planted")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("pinecone")
    inst.AnimState:SetBuild("pinecone")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("inspectable")
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

	inst:ListenForEvent("fullmoon", function() GrowBeanstalk(inst) end, GetWorld())

    return inst
end

return Prefab ("common/inventory/beanstalk_sapling", fn, assets, prefabs)


