BindGlobal()

local assets =
{
	Asset("ANIM", "anim/beanlet_hut.zip"),
}

local prefabs =
{
    "beanlet",
    "boards",
    "flowerpetals",
}

SetSharedLootTable( 'beanlet_hut',
{
    {'boards',       1.0},
    {'boards',       1.0},    
    {'flowerpetals', 1.0},
    {'flowerpetals', 1.0},
    {'flowerpetals', 0.8},
    {'flowerpetals', 0.8},        
})

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
        inst.lightson = true
    end
end

local function LightsOff(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
        inst.lightson = false
    end
end

local function onnear(inst) 
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOff(inst)
        end
    end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst.Light:Enable(false)
    inst:Remove()
end

local function onhit(inst, worker)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren(worker)
    end
    --inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", false)
end

local function ReturnChildren(inst)
	for k,child in pairs(inst.components.childspawner.childrenoutside) do
		if child.components.homeseeker then
			child.components.homeseeker:GoHome()
		end
		child:PushEvent("gohome")
	end
end

local function OnIgniteFn(inst)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function OnDay(inst)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner.childreninside >= 1 then
            LightsOff(inst)
            if inst.doortask then
                inst.doortask:Cancel()
                inst.doortask = nil
            end
            inst.doortask = inst:DoTaskInTime(1 + math.random()*2, function() inst.components.childspawner:SpawnChild() end)
        end
    end
end

local function onfar(inst) 
    if not inst:HasTag("burnt") then
        if inst.components.childspawner and inst.components.childspawner.childreninside >= 1 then
            LightsOn(inst)
        end
    end
end

local function onnear(inst) 
    if not inst:HasTag("burnt") then
        if inst.components.childspawner and inst.components.childspawner.childreninside >= 1 then
            LightsOff(inst)
        end
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 1)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("beanlet_hut.tex")

    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180/255, 195/255, 50/255)

    anim:SetBank("beanlet_hut")
    anim:SetBuild("beanlet_hut")
    anim:PlayAnimation("idle", true)
    inst.Transform:SetScale(3,3,3)

	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(100)
	inst.components.childspawner:SetSpawnPeriod(20)
	inst.components.childspawner:SetMaxChildren(math.random(1,3))
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.childname = "beanlet"

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('beanlet_hut')


    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10,13)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    inst:ListenForEvent("upandaway_charge", function()
        if inst.components.childspawner then
            inst.components.childspawner:StopSpawning()
            ReturnChildren(inst) 
        end
    end)

	inst:ListenForEvent("upandaway_uncharge", function() 
        OnDay()
    end)

    inst:AddComponent("inspectable")

    MakeSmallBurnable(inst)
    MakeLargePropagator(inst)
    inst:ListenForEvent("burntup", function(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
    end)

    inst.OnSave = onsave
    inst.OnLoad = onload

	return inst
end

return Prefab("common/objects/beanlet_hut", fn, assets, prefabs) 
