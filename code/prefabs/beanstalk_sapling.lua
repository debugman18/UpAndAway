BindGlobal()
local assets =
{
	Asset("ANIM", "anim/beanstalk_sapling.zip"),
	Asset("ANIM", "anim/pinecone.zip"),
}

local prefabs = 
{
	"beanstalk",
}

local function GrowBeanstalk(inst)
	if GetClock():GetMoonPhase() == "full" then
		local tree = SpawnPrefab("beanstalk") 
		local player = GetPlayer()
		local distToPlayer = inst:GetPosition():Dist(player:GetPosition())
		local power = Lerp(3, 1, distToPlayer/180)
		player.components.playercontroller:ShakeCamera(player, "VERTICAL", 0.5, 0.03, power, 40)
		--GetPlayer().components.talker:Say(GetString(GetPlayer().prefab, "ANNOUNCE_BEANSTALK"))
		GetPlayer().components.talker:Say("What could that be?!")
	    if tree then 
			tree.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
			tree.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge") 
			tree.AnimState:PlayAnimation("emerge")		
	        tree.AnimState:PushAnimation("idle", true)		
			GetPlayer().AnimState:PlayAnimation("wakeup")
	        inst:Remove()
		end
	else end
end

local function plant(inst, growtime)
    inst.AnimState:PlayAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("pinecone")
    inst.AnimState:SetBuild("beanstalk_sapling")
    inst.AnimState:PlayAnimation("idle_planted")

    inst:AddComponent("inspectable")
    
	MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

	inst:AddComponent("named")
	inst.components.named:SetName("Beanstalk Sapling")

    --inst.Transform:SetScale(4, 4, 4)
    inst:DoPeriodicTask(0.5, function() _G.DeleteCloseEntsWithTag(inst, "mound", 5) _G.DeleteCloseEntsWithTag(inst, "grave", 5) end, 0)
	inst:ListenForEvent("nighttime", function() GrowBeanstalk(inst) end, GetWorld())

    return inst
end

return Prefab ("common/inventory/beanstalk_sapling", fn, assets, prefabs)


