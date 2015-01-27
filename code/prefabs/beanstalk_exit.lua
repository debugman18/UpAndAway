BindGlobal()

local assets=
{
    Asset("ANIM", "anim/rock_stalagmite_tall.zip"),
    Asset("ANIM", "anim/beanstalk_exit.zip"),
}

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --MakeObstaclePhysics(inst, 1)
    
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("beanstalk_exit.tex")
    
    anim:SetBank("rock_stalagmite_tall")
    anim:SetBuild("beanstalk_exit")

    inst.type = math.random(2)
    inst.AnimState:PlayAnimation("full_"..inst.type)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddTag("beanstalk_climbable")

    inst:AddComponent("climbable")
    inst.components.climbable:SetDirection("DOWN")

    inst:AddComponent("inspectable")

    return inst
end

return Prefab( "common/beanstalk_exit", fn, assets) 
