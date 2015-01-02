BindGlobal()

local CFG = TheMod:GetConfig()

local prefabs = CFG.ALIEN.PREFABS

local fragments = CFG.ALIEN.FRAGMENTS

SetSharedLootTable( "alien", CFG.ALIEN.LOOT)

local function retargetfn(inst)
    local entity = FindEntity(inst, TUNING.SHADOWCREATURE_TARGET_DIST, function(guy) 
        return guy:HasTag("player") and inst.components.combat:CanTarget(guy)
    end)
    return entity
end

local function onkilledbyother(inst, attacker)
    if attacker and attacker.components.sanity then
        attacker.components.sanity:DoDelta(inst.sanityreward or TUNING.SANITY_SMALL)
    end
end

local function CalcSanityAura(inst, observer)
    if inst.components.combat.target then
        return -TUNING.SANITYAURA_LARGE
    end	
    return 0
end

local function canbeattackedfn(inst, attacker)
    return inst.components.combat.target ~= nil or
        (attacker.components.sanity)
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("shadowcreature") and not dude.components.health:IsDead() end, 1)
end

local assets=
{
    Asset("ANIM", "anim/shadow_insanity1_color.zip"),
}

local sounds = 
{
    attack = "dontstarve/sanity/creature1/attack",
    attack_grunt = "dontstarve/sanity/creature1/attack_grunt",
    death = "dontstarve/sanity/creature1/die",
    idle = "dontstarve/sanity/creature1/idle",
    taunt = "dontstarve/sanity/creature1/taunt",
    appear = "dontstarve/sanity/creature1/appear",
    disappear = "dontstarve/sanity/creature1/dissappear",
}

local colours = CFG.ALIEN.COLOURS

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
    local sound = inst.entity:AddSoundEmitter()
    inst.Transform:SetFourFaced()
    inst:AddTag("shadowcreature")
    
    MakeCharacterPhysics(inst, 10, 1.5)
    RemovePhysicsColliders(inst)
    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
    inst.Physics:CollidesWith(COLLISION.SANITY)
    --inst.Physics:CollidesWith(COLLISION.WORLD)

    inst.Transform:SetScale(CFG.ALIEN.SCALE, CFG.ALIEN.SCALE, CFG.ALIEN.SCALE)

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.colour_idx = math.random(#colours)
    anim:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],0.7)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    
    inst:AddComponent("inspectable")
     
    anim:SetBank("shadowcreature1")
    anim:SetBuild("shadow_insanity1_color")
    anim:PlayAnimation("idle_loop")
    anim:SetMultColour(1, 1, 1, 0.2)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = CFG.ALIEN.WALKSPEED
    inst.sounds = sounds
    inst:SetStateGraph("SGshadowcreature")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.ALIEN.HEALTH)
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(CFG.ALIEN.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.ALIEN.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat.canbeattackedfn = canbeattackedfn

    inst:AddComponent("lootdropper")

    local fragment = fragments[math.random(#fragments)]

    inst.components.lootdropper:SetChanceLootTable("alien")
    inst.components.lootdropper:AddChanceLoot(fragment, CFG.ALIEN.RARECHANCE)

    local brain = require "brains/shadowcreaturebrain"
    inst:SetBrain(brain)
    
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end
    
return Prefab("monsters/alien", fn, assets, prefabs)
