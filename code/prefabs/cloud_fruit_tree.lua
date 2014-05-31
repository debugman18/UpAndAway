BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cloud_fruit_tree.zip"),
}

local prefabs = {
	"cloud_fruit",
}

local function onpickedfn(inst)
	inst.components.pickable.cycles_left = 2
	inst.AnimState:Hide("BANANA") 
    inst.picked = true
end	

local function chop_tree(inst, chopper, chops)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/rocklobster/clawsnap")         
    --inst.AnimState:PlayAnimation("chop")
end

local function chop_down_tree(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    --inst.AnimState:PlayAnimation("fall")
    --inst.AnimState:PushAnimation("stump", false)
    if inst.picked then
        inst.components.lootdropper:DropLoot()
    else 
        inst.components.lootdropper.loot = {
            "thunder_log",
            "thunder_log",
            "cloud_fruit"
        }
        inst.components.lootdropper:DropLoot()
    end
    inst:Remove()
    
	--inst:AddComponent("workable")
    --inst.components.workable:SetWorkAction(ACTIONS.DIG)
    --inst.components.workable:SetOnFinishCallback(dig_up_stump)
    --inst.components.workable:SetWorkLeft(1)
end

local function onsave(inst, data)
    if inst.picked then
        data.picked = true
    end
end

local function onload(inst, data)
    if data and data.picked then
        inst.picked = true
        onpickedfn(inst)
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

	inst:AddComponent("inspectable")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_fruit_tree.tex") 

    inst:AddComponent("pickable")
	inst.components.pickable:SetUp("cloud_fruit", 40)	
	inst.components.pickable.onpickedfn = onpickedfn    

	inst:AddComponent("lootdropper")
	inst.components.lootdropper.loot = {
		"thunder_log",
        "thunder_log"
	}

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    inst.OnSave = onsave
    inst.OnLoad = onload

	return inst
end

return Prefab ("common/inventory/cloud_fruit_tree", fn, assets, prefabs) 
