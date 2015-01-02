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
    if GetPseudoClock():GetMoonPhase() == "full" then
        local tree = SpawnPrefab("beanstalk") 
        if not tree then return end

        tree.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
        tree.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge") 
        tree.AnimState:PlayAnimation("emerge")		
        tree.AnimState:PushAnimation("idle", true)		

        for _, player in ipairs(Game.FindAllPlayers()) do
            Game.Effects.ShakeCamera(player, inst, "VERTICAL", 0.5, 0.03, 4, 40)
            if player:GetDistanceSqToInst(inst) < 64^2 then
                player.AnimState:PlayAnimation("wakeup")
                player.components.talker:Say("What could that be?!")
            end
        end

        inst:Remove()
    end
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


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst:AddComponent("named")
    inst.components.named:SetName("Beanstalk Sapling")

    --inst.Transform:SetScale(4, 4, 4)
    inst:DoTaskInTime(0, function() _G.DeleteCloseEntsWithTag(inst, "mound", 0.5) _G.DeleteCloseEntsWithTag(inst, "grave", 5) end)
    inst:ListenForEvent("nighttime", function() GrowBeanstalk(inst) end, GetWorld())

    return inst
end

return Prefab ("common/inventory/beanstalk_sapling", fn, assets, prefabs)


