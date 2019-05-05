BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset("ANIM", "anim/cloud_fruit_tree.zip"),
}

local prefabs = CFG.CLOUD_FRUIT_TREE.PREFABS

local function dug(inst)
    inst:Remove()
    inst.components.lootdropper:SpawnLootPrefab("thunder_log")
end

local function setupstump(inst)
    inst.stump = true
    inst:RemoveComponent("pickable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(dug)
    inst.AnimState:PlayAnimation("idle_stump")
end

local function onregenfn(inst)
    inst.AnimState:Show("BANANA") 
    inst.picked = false
end

local function onpickedfn(inst)
	inst.components.pickable.cycles_left = 2
	inst.AnimState:Hide("BANANA") 
    inst.picked = true
end	

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap")         
    inst.AnimState:PlayAnimation("chop")
end

local function chop_down_tree(inst, chopper)
    if inst.stump then return end
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          

    if inst.picked then
        inst.components.lootdropper:SpawnLootPrefab("thunder_log")
        inst.components.lootdropper:SpawnLootPrefab("thunder_log")
    else 
        inst.components.lootdropper:SpawnLootPrefab("thunder_log")
        inst.components.lootdropper:SpawnLootPrefab("thunder_log")
        inst.components.lootdropper:SpawnLootPrefab("cloud_fruit")
    end
    
	setupstump(inst)

    inst.AnimState:PlayAnimation("fall")
    inst.AnimState:PushAnimation("idle_stump")
end

local function onsave(inst, data)
    if inst.picked then
        data.picked = true
    end

    if inst.stump then
        data.stump = true
    end
end

local function onload(inst, data)
    if data and data.picked then
        inst.picked = true
        onpickedfn(inst)
    elseif data and data.stump then
        inst.stump = true
        setupstump(inst)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank("cave_banana_tree")
    inst.AnimState:SetBuild("cloud_fruit_tree")
	inst.AnimState:PlayAnimation("idle_loop", true)


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------


	inst:AddComponent("inspectable")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_fruit_tree.tex") 

    inst:AddComponent("pickable")
	inst.components.pickable:SetUp(CFG.CLOUD_FRUIT_TREE.PICK_LOOT, CFG.CLOUD_FRUIT_TREE.PICK_REGEN, CFG.CLOUD_FRUIT_TREE.PICK_QUANTITY)	
	inst.components.pickable:SetOnPickedFn(onpickedfn) 
    inst.components.pickable:SetOnRegenFn(onregenfn)

	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(CFG.CLOUD_FRUIT_TREE.WORK_TIME)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    inst.OnSave = onsave
    inst.OnLoad = onload

	return inst
end

return Prefab ("common/inventory/cloud_fruit_tree", fn, assets, prefabs) 
