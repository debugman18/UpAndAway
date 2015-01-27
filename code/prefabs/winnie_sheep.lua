BindGlobal()


-- An array of functions.
--
-- It is a table, so you add/remove functions like you would to a (array-like)
-- table (e.g., table.insert, table.remove).
--
-- It can be called like a function (which results in it calling every
-- function in it passing the arguments given to it).
local FunctionQueue = wickerrequire "gadgets.functionqueue"


local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/sheep_baby_build.zip"),
    Asset("ANIM", "anim/sheep_electric.zip"),	

    Asset("ANIM", "anim/beefalo_basic.zip"),
    Asset("ANIM", "anim/beefalo_actions.zip"),
    Asset("SOUND", "sound/beefalo.fsb"),
    Asset("SOUND", "sound/project_bank00.fsb"),
    Asset("SOUND", "sound/sheep_bank01.fsb"),		
}

local prefabs = CFG.SHEEP.PREFABS

SetSharedLootTable( "sheep", CFG.SHEEP.LOOT)

local sounds = 
{
    walk = "dontstarve/beefalo/walk",
    grunt = "sheep/sheep/baa",
    yell = "dontstarve/beefalo/yell",
    swish = "dontstarve/beefalo/tail_swish",
    curious = "dontstarve/beefalo/curious",
    angry = "dontstarve/beefalo/angry",
}

local function GetStatus(inst)
    return "SHEEP" 
end

local function SpawnFlower(inst)
    inst.components.sleeper:AddSleepiness(1, 10)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("sheep") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function fn()
    local inst = CreateEntity()
    inst:AddTag("sheep")

    local trans = inst.entity:AddTransform()
    trans:SetFourFaced()

    local sound = inst.entity:AddSoundEmitter()
    inst.sounds = sounds

    local shadow = inst.entity:AddDynamicShadow()

    local anim = inst.entity:AddAnimState()
    anim:SetBank("beefalo")
    inst.AnimState:SetBuild("sheep_baby_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

    MakeCharacterPhysics(inst, 100, .5)
    

    inst:AddTag("animal")
    inst:AddTag("beefalo")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("eater")	
    inst.components.eater:SetVegetarian()	

    inst:AddComponent("combat")

    inst:AddTag("winnie_sheep")

    inst:AddComponent("beard")
    inst.components.beard.bits = CFG.SHEEP.SHAVE_BITS
    inst.components.beard.daysgrowth = CFG.SHEEP.HAIR_GROWTH_DAYS + 1 
    inst.components.beard.onreset = function() inst.sg:GoToState("shaved") end   
    inst.components.beard.prize = "beefalowool"
    inst.components.beard:AddCallback(0, function()
        if inst.components.beard.bits == 0 then
            -- We need a shaved sheep build.
            --anim:SetBuild("sheep_shaved_build")
        end
    end)
    inst.components.beard:AddCallback(CFG.SHEEP.HAIR_GROWTH_DAYS, function()
        if inst.components.beard.bits == 0 then
            inst.hairGrowthPending = true
        end
    end)
    
    inst:AddComponent("health")	
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    inst.components.herdmember.herdprefab = "sheepherd"
    
    inst:AddComponent("leader")

    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = CFG.SHEEP.FOLLOW_TIME
    inst.components.follower.canaccepttarget = false
    
    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab(CFG.SHEEP.PERIODICSPAWN_PREFAB)	
    inst.components.periodicspawner:SetRandomTimes(30, 80)
    inst.components.periodicspawner:SetDensityInRange(40, 3)
    inst.components.periodicspawner:SetMinimumSpacing(CFG.SHEEP.MINIMUM_SPACING)
    inst.components.periodicspawner:Start()

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")
    
    inst:AddComponent("locomotor")	
    inst.components.locomotor.walkspeed = CFG.SHEEP.WALKSPEED * 1.5
    inst.components.locomotor.runspeed = CFG.SHEEP.RUNSPEED * 1.5
    
    inst:AddComponent("lootdropper")
    
    inst:AddComponent("sleeper")	

    inst:SetStateGraph("SGSheep")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.WINNIE_SHEEP_NAMES
    inst.components.named:PickNewName()

    inst:AddTag("electric_sheep")   

    inst.DynamicShadow:SetSize(3, 2)
    
    inst.Transform:SetScale(0.65, 0.75, 0.65)
    
    inst.AnimState:SetBuild("sheep_baby_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
     
    inst.components.health:SetMaxHealth(CFG.SHEEP.HEALTH * 3)

    inst.components.lootdropper:SetChanceLootTable("sheep")

    inst.components.periodicspawner:Stop()
    inst.components.periodicspawner:SetRandomTimes(20, 100)
    inst.components.periodicspawner:SetDensityInRange(10, 1)
    inst.components.periodicspawner:SetMinimumSpacing(CFG.SHEEP.MINIMUM_SPACING)
    inst.components.periodicspawner:SetOnSpawnFn(SpawnFlower)
    inst.components.periodicspawner:Start()

    inst.components.sleeper:SetResistance(2)
    
    local brain = require "brains/winniesheepbrain"
    inst:SetBrain(brain)   

    inst:DoPeriodicTask(2, function()
        inst.components.follower:AddLoyaltyTime(math.huge)
    end)

    if ThePlayer and ThePlayer.prefab == "winnie" then
        ThePlayer.components.leader:AddFollower(inst)
    end

    inst:ListenForEvent("attacked", OnAttacked)
    
    return inst	
end

return Prefab( "cloudrealm/animals/winnie_sheep", fn, assets, prefabs)
