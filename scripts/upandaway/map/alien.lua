local prefabs =
{
    "nightmarefuel",
}

local function retargetfn(inst)
    local entity = FindEntity(inst, 10, function(guy) 
		return guy:HasTag("player") and guy.components.sanity:IsCrazy() and inst.components.combat:CanTarget(guy)
    end)
    return entity
end

local function onkilledbyother(inst, attacker)
	if attacker and attacker.components.sanity then
		attacker.components.sanity:DoDelta(inst.sanityreward or -30)
	end
end

local loot = {"nightmarefuel"}

local function CalcSanityAura(inst, observer)
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_LARGE
	end	
	return 0
end

local function canbeattackedfn(inst, attacker)
	return inst.components.combat.target ~= nil or
		(attacker.components.sanity and attacker.components.sanity:IsCrazy())
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("aurora") and not dude.components.health:IsDead() end, 1)
end

local function MakeAurora(data)

    local bank = data.bank 
    local build = data.build 
    
    local assets=
    {
	    Asset("ANIM", "anim/"..data.build..".zip"),
    }
    
    local sounds = 
    {
        attack = "dontstarve/sanity/creature"..data.num.."/attack",
        attack_grunt = "dontstarve/sanity/creature"..data.num.."/attack_grunt",
        death = "dontstarve/sanity/creature"..data.num.."/die",
        idle = "dontstarve/sanity/creature"..data.num.."/idle",
        taunt = "dontstarve/sanity/creature"..data.num.."/taunt",
        appear = "dontstarve/sanity/creature"..data.num.."/appear",
        disappear = "dontstarve/sanity/creature"..data.num.."/dissappear",
    }

    local function fn()
	    local inst = CreateEntity()
	    local trans = inst.entity:AddTransform()
	    local anim = inst.entity:AddAnimState()
        local physics = inst.entity:AddPhysics()
	    local sound = inst.entity:AddSoundEmitter()
        inst.Transform:SetFourFaced()
        inst:AddTag("aurora")
    	
        MakeCharacterPhysics(inst, 10, 1.5)
        RemovePhysicsColliders(inst)
	    inst.Physics:SetCollisionGroup(COLLISION.SANITY)
	    inst.Physics:CollidesWith(COLLISION.SANITY)      
         
        anim:SetBank(bank)
        anim:SetBuild(build)
        anim:PlayAnimation("idle_loop")
        anim:SetMultColour(1, 1, 1, 0.5)
        inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
        inst.components.locomotor.walkspeed = data.speed
        inst.sounds = sounds
        inst:SetStateGraph("SGshadowcreature")

        inst:AddTag("monster")
	    inst:AddTag("hostile")
        inst:AddTag("shadow")

        local brain = require "brains/shadowcreaturebrain"
        inst:SetBrain(brain)
        
	    inst:AddComponent("sanityaura")
	    inst.components.sanityaura.aurafn = CalcSanityAura
        
        --inst:AddComponent("transparentonsanity")
        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.health)
        
		inst.sanityreward = data.sanityreward
		
        inst:AddComponent("combat")
        inst.components.combat:SetDefaultDamage(data.damage)
        inst.components.combat:SetAttackPeriod(data.attackperiod)
        inst.components.combat:SetRetargetFunction(3, retargetfn)
        inst.components.combat.onkilledbyother = onkilledbyother
        inst.components.combat.canbeattackedfn = canbeattackedfn

        inst:AddComponent("lootdropper")
        inst.components.lootdropper:SetLoot(loot)
        inst.components.lootdropper:AddChanceLoot("nightmarefuel", 0.5)
        
        inst:ListenForEvent("attacked", OnAttacked)

        return inst
    end
        
    return Prefab("cloudrealm/monsters/"..data.name, fn, assets, prefabs)
end


local data = {{name="aurorahorror", build = "shadow_insanity1_basic", bank = "shadowcreature1", num = 1, speed = 5, health=30, damage=0, attackperiod = 3, sanityreward = -50},
			  {name="aurorabird", build = "shadow_insanity2_basic", bank = "shadowcreature2", num = 2, speed = 5, health=20, damage=2, attackperiod = 4, sanityreward = -30}}

local ret = {}
for k,v in pairs(data) do
	table.insert(ret, MakeAurora(v))
end


return unpack(ret) 
