BindGlobal()

local assets =
{
    Asset("ANIM", "anim/crow.zip"),
    Asset("ANIM", "anim/weaver_bird.zip"),
    Asset("SOUND", "sound/birds.fsb"),

    Asset( "ATLAS", inventoryimage_atlas("weaver_bird") ),
    Asset( "IMAGE", inventoryimage_texture("weaver_bird") ),
}

local prefabs =
{
    "weavernest",
    "smallmeat",
    "cookedsmallmeat",
    "feather_robin",
}

local sounds = 
{
    takeoff = "dontstarve/birds/takeoff_robin",
    chirp = "dontstarve/birds/chirp_robin",
    flyin = "dontstarve/birds/flyin",
}

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("flying")
end

local function ondrop(inst)
    inst.sg:GoToState("stunned")
end

local function OnAttacked(inst, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 30, {"bird"})
    
    local num_friends = 0
    local maxnum = 5
    for k,v in pairs(ents) do
        if v ~= inst then
            v:PushEvent("gohome")
            num_friends = num_friends + 1
        end
        
        if num_friends > maxnum then
            break
        end
        
    end
end

local function nesttest()
    return GetWorld().components.seasonmanager:IsWinter()
end

local function OnTrapped(inst, data)
    if data and data.trapper and data.trapper.settrapsymbols then
        data.trapper.settrapsymbols("robin_build")
    end
end

local function canbeattacked(inst, attacked)
    return not inst.sg:HasStateTag("flying")
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.sounds = sounds
    inst.entity:AddPhysics()
    inst.Transform:SetTwoFaced()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, 1)
    shadow:Enable(false)

    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:SetSphere(1.5)
    inst.Physics:SetMass(1.5)
    
    inst:AddTag("bird")
    inst:AddTag("weaver_bird")
    inst:AddTag("smallcreature")
    
    anim:SetBank("crow")
    anim:SetBuild("weaver_bird")
    anim:PlayAnimation("idle")
    inst.trappedbuild = "robin_build"

    inst.Transform:SetScale(1.5, 1.5, 1.5)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbird")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("twigs", 1)
    inst.components.lootdropper:AddRandomLoot("smallmeat", 2)
    inst.components.lootdropper.numrandomloot = 1
    
    inst:AddComponent("occupier")
    
    inst:AddComponent("eater")
    inst.components.eater:SetBird()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetSleepTest(ShouldSleep)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem:SetOnDroppedFn(ondrop)
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("weaver_bird")
    
    inst:AddComponent("cookable")
    inst.components.cookable.product = "cookedsmallmeat"

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "crow_body"
    inst.components.combat.canbeattackedfn = canbeattacked

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BIRD_HEALTH)
    inst.components.health.murdersound = "dontstarve/wilson/hit_animal"
    
    inst:AddComponent("inspectable")
   
    local brain = require "brains/birdbrain"
    inst:SetBrain(brain)
    
    MakeSmallBurnableCharacter(inst, "crow_body")
    MakeTinyFreezableCharacter(inst, "crow_body")

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("weavernest")
    inst.components.periodicspawner:SetDensityInRange(40, 1)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:SetSpawnTestFn(nesttest)

    --inst.TrackInSpawner = TrackInSpawner
    
    inst:ListenForEvent("ontrapped", OnTrapped)
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("cloudrealm/animals/weaver_bird", fn, assets, prefabs)
