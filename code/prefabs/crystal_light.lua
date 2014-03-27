BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal.zip"),
}

local prefabs =
{
    "crystal_fragment_light",
}

local loot = 
{
   "crystal_fragment_light",
}

local function onMined(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")

    inst:Remove()   
end



local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("maxwelltorch.png")

    anim:SetBank("crystal")
    anim:SetBuild("crystal")
    anim:PlayAnimation("crystal_light")
 
    inst:AddTag("crystal")
  
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .1)    

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "Light Crystal" 

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)   

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
    inst.components.workable:SetOnFinishCallback(onMined)

	return inst
end

return Prefab ("common/inventory/crystal_light", fn, assets, prefabs) 
