BindGlobal()


local assets=
{
    Asset("ANIM", "anim/golden_sunflower.zip"),
}

local prefabs =
{
    "golden_sunflower_seeds",
    "goldnugget",
    "golden_petals",
}

local function onpickedfn(inst)

    --This spawns a golden vine rarely when a sunflower is picked.

    inst:DoTaskInTime(0, function()
        local vinechance = (math.random(0,100)) + (math.random(0,10))
        print(vinechance or "nil")
        if vinechance <= 50 then
            local vine = SpawnPrefab("vine")
            print("Vine should be spawned.")
            vine.AnimState:SetMultColour(100,100,10,1)
            vine.Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end)

    inst:Remove()
end

local function fn(Sim)

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
   
    inst.AnimState:SetBank("golden_sunflower")
    inst.AnimState:SetBuild("golden_sunflower")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetRayTestOnBB(true);
    inst.Transform:SetScale(2,2,2)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("inspectable")
   
    --This generates various pickable products.

    local loot = prefabs[math.random(#prefabs)]

    local regentime = 1

    local lootmin = 1

    local lootmax = 2

    local lootcount = math.random(lootmin,lootmax)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp(loot, regentime, lootcount)
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = false

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    
    return inst
end

return Prefab( "common/inventory/golden_sunflower", fn, assets, prefabs) 
