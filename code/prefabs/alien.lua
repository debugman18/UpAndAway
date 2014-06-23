BindGlobal()

local prefabs =
{
    "nightmarefuel",
    "crystal_fragment_relic",
    "crystal_fragment_light",
    "crystal_fragment_spire",
    "crystal_fragment_water",
}

local fragments = {
    "crystal_fragment_relic",
    "crystal_fragment_light",
    "crystal_fragment_spire",
    "crystal_fragment_water",
}

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

local loot_common = {
    "nightmarefuel"
}

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

local colours=
{
    {198/255,43/255,43/255},
    {79/255,153/255,68/255},
    {35/255,105/255,235/255},
    {233/255,208/255,69/255},
    {109/255,50/255,163/255},
    {222/255,126/255,39/255},
}

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

    inst.Transform:SetScale(.6,.6,.6)
    
    inst:AddComponent("inspectable")
     
    anim:SetBank("shadowcreature1")
    anim:SetBuild("shadow_insanity1_color")
    anim:PlayAnimation("idle_loop")
    anim:SetMultColour(1, 1, 1, 0.2)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 3.5
    inst.sounds = sounds
    inst:SetStateGraph("SGshadowcreature")

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.colour_idx = math.random(#colours)
    anim:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],0.7)

    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("shadow")

    local brain = require "brains/shadowcreaturebrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(30)
	
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(50)
    inst.components.combat:SetAttackPeriod(5)
    inst.components.combat:SetRetargetFunction(3, retargetfn)
    inst.components.combat.onkilledbyother = onkilledbyother
    inst.components.combat.canbeattackedfn = canbeattackedfn

    inst:AddComponent("lootdropper")

    local lootchance = math.random(0,100)

    local fragment = fragments[math.random(#fragments)]

    local loot_rare = {
        fragment
    }

    if lootchance <= 50 then
        inst.components.lootdropper:SetLoot(loot_common)
    else 
        inst.components.lootdropper:SetLoot(loot_rare) 
    end
    inst.components.lootdropper:AddChanceLoot("nightmarefuel", 0.2)
    
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end
    
return Prefab("monsters/alien", fn, assets, prefabs)
