BindGlobal()


local assets=
{
	Asset("ANIM", "anim/golden_sunflower.zip"),
}

local prefabs=
{
	"golden_sunflower_seeds",
    "goldnugget",
}

local function onpickedfn(inst)
	inst:Remove()
end

local function fn(Sim)
    --Carrot you eat is defined in veggies.lua
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("golden_sunflower")
    inst.AnimState:SetBuild("golden_sunflower")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true);
    inst.Transform:SetScale(2.3,2.3,2.3)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    if math.random(1,6) == 1 then
        inst.components.pickable:SetUp("golden_sunflower_seeds", 1, 1)
    else inst.components.pickable:SetUp("goldnugget", 1, 1) end
	inst.components.pickable.onpickedfn = onpickedfn
    
    inst.components.pickable.quickpick = true

    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab( "common/inventory/golden_sunflower", fn, assets) 
