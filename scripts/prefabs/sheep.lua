local assets=
{
	Asset("ANIM", "anim/sheep_baby_build.zip"),
	Asset("ANIM", "anim/sheep_electric.zip"),	

	Asset("ANIM", "anim/beefalo_basic.zip"),
	Asset("ANIM", "anim/beefalo_actions.zip"),
	Asset("SOUND", "sound/beefalo.fsb"),
}

local prefabs =
{
    "meat",
    "skyflower",
	"cloud_cotton",
}

local loot = {"meat","meat","cloud_cotton","cloud_cotton"}

local sounds = 
{
    walk = "dontstarve/beefalo/walk",
    grunt = "dontstarve/beefalo/grunt",
    yell = "dontstarve/beefalo/yell",
    swish = "dontstarve/beefalo/tail_swish",
    curious = "dontstarve/beefalo/curious",
    angry = "dontstarve/beefalo/angry",
}

local function Retarget(inst)
    local newtarget = FindEntity(inst, TUNING.MINOTAUR_TARGET_DIST, function(guy)
            return (guy:HasTag("character") or guy:HasTag("monster"))
                   and not (inst.components.follower and inst.components.follower.leader == guy)
                   and not guy:HasTag("sheep")
                   and inst.components.combat:CanTarget(guy)
    end)
    return newtarget
end

local function KeepTarget(inst, target)
    if inst.components.herdmember
       and inst.components.herdmember:GetHerd()
       and inst.components.herdmember:GetHerd().components.mood
       and inst.components.herdmember:GetHerd().components.mood:IsInMood() then
        local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
        if herd and herd.components.mood and herd.components.mood:IsInMood() then
            return distsq(Vector3(herd.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < TUNING.BEEFALO_CHASE_DIST*TUNING.BEEFALO_CHASE_DIST
        end
    end
    return true
end

local function OnNewTarget(inst, data)
    if inst.components.follower and data and data.target and data.target == inst.components.follower.leader then
        inst.components.follower:SetLeader(nil)
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30,function(dude)
        return dude:HasTag("sheep") and not dude:HasTag("player") and not dude.components.health:IsDead()
    end, 5)
end

local function GetStatus(inst)
    if inst.components.follower.leader ~= nil then
        return "FOLLOWER"
    elseif inst.components.beard and inst.components.beard.bits == 0 then
        return "NAKED"
    end
end

local function dostaticsparks(inst, dt)

	local pos = Vector3(inst.Transform:GetWorldPosition())
	pos.y = pos.y + 1 + math.random()*1.5
	local spark = SpawnPrefab("sparks")
	spark.Transform:SetPosition(pos:Get())
	spark.Transform:SetScale(0.9, 0.5, 0.5)
	
end

local function sheeptransform_uncharge(inst)
	inst.prefab = "sheep"
	inst.components.combat:SetTarget(nil)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(3, 2)
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(0.65, 0.75, 0.65)

    MakeCharacterPhysics(inst, 100, .5)
    
    inst:AddTag("sheep")
    anim:SetBank("beefalo")
    anim:SetBuild("sheep_baby_build")
    anim:PlayAnimation("idle_loop", true)
    
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    local hair_growth_days = 3

    inst:AddComponent("beard")
    -- assume the beefalo has already grown its hair
    inst.components.beard.bits = 3
    inst.components.beard.daysgrowth = hair_growth_days + 1 
    inst.components.beard.onreset = function()
        inst.sg:GoToState("shaved")
    end
	
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
     
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cotton", 0.70)
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    
    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    
    inst:AddComponent("leader")
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("skyflower")
    inst.components.periodicspawner:SetRandomTimes(20, 100)
    inst.components.periodicspawner:SetDensityInRange(10, 1)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.5
    inst.components.locomotor.runspeed = 7
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    local brain = require "brains/sheepbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGSheep")
	inst:AddComponent("named")
	inst.components.named:SetName("Sheep")
	inst:ListenForEvent("upandaway_charge", function()
		print "Charged!"
		sheeptransform_charge(inst)	
		return inst
	end, GetWorld())	
	return inst		
end

local function sheeptransform_charge(inst)
	inst.prefab = "sheep_electric"
	inst.components.combat:SetTarget(nil)
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(6, 2)
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1, 1, 1)	

	inst.sg:GoToState("idle")
	
    MakeCharacterPhysics(inst, 100, .5)
    
    inst:AddTag("sheep")
    anim:SetBank("beefalo")
    anim:SetBuild("sheep_electric")
    anim:PlayAnimation("idle_loop", true)
    
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    local hair_growth_days = 3	
	
	inst.components.eater:SetVegetarian()
    
	inst:RemoveComponent("locomotor")
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 1.5
	inst.components.locomotor.runspeed = 7
    inst.components.locomotor:StopMoving()	
	
	inst.components.combat.hiteffectsymbol = "beefalo_body"
	inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
	inst.components.combat:SetRetargetFunction(1, Retarget)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddTag("hostile")
     
	--inst:DoPeriodicTask(1/10, function() dostaticsparks(inst, 1/10) end)
	 
	inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)
		
	inst.components.lootdropper:SetLoot(loot)

	inst.components.inspectable.getstatus = GetStatus

	inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
	inst.components.follower.canaccepttarget = false
	inst:ListenForEvent("newcombattarget", OnNewTarget)
	inst:ListenForEvent("attacked", OnAttacked)


	inst.components.periodicspawner:SetPrefab("datura")
	inst.components.periodicspawner:SetRandomTimes(40, 60)
	inst.components.periodicspawner:SetDensityInRange(20, 2)
	inst.components.periodicspawner:SetMinimumSpacing(8)
	inst.components.periodicspawner:Start()
   
	--inst:AddComponent("sleeper")
	inst.components.sleeper:SetResistance(3)
    
	local brain = require "brains/rambrain"
	inst:SetBrain(brain)
	inst:SetStateGraph("SGSheep")
	inst:AddComponent("named")
	inst.components.named:SetName("Electric Sheep")
	inst:ListenForEvent("upandaway_uncharge", function()
		print "Uncharged!"
		sheeptransform_uncharge(inst)	
		return inst
	end, GetWorld())		
	return inst		
end

local function fncommon(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(3, 2)
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(0.65, 0.75, 0.65)

    MakeCharacterPhysics(inst, 100, .5)
    
    inst:AddTag("sheep")
    anim:SetBank("beefalo")
    anim:SetBuild("sheep_baby_build")
    anim:PlayAnimation("idle_loop", true)
    
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    local hair_growth_days = 3

    inst:AddComponent("beard")
    -- assume the beefalo has already grown its hair
    inst.components.beard.bits = 3
    inst.components.beard.daysgrowth = hair_growth_days + 1 
    inst.components.beard.onreset = function()
        inst.sg:GoToState("shaved")
    end
    
	--[[
    inst.components.beard.canshavetest = function() if not inst.components.sleeper:IsAsleep() then return false, "AWAKEBEEFALO" end return true end
    
    inst.components.beard.prize = "beefalowool"
    inst.components.beard:AddCallback(0, function()
        if inst.components.beard.bits == 0 then
            anim:SetBuild("beefalo_shaved_build")
        end
    end)
    inst.components.beard:AddCallback(hair_growth_days, function()
        if inst.components.beard.bits == 0 then
            inst.hairGrowthPending = true
        end
    end)
    --]]
	
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
     
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cotton", 0.70)
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    
    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    
    inst:AddComponent("leader")
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("skyflower")
    inst.components.periodicspawner:SetRandomTimes(20, 100)
    inst.components.periodicspawner:SetDensityInRange(10, 1)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.5
    inst.components.locomotor.runspeed = 7
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    local brain = require "brains/sheepbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGSheep")
	
	inst:ListenForEvent("upandaway_charge", function()
		print "Charged!"
		sheeptransform_charge(inst)	
		return inst
	end, GetWorld())	
    return inst
end

local function fnelectric(Sim)
	local inst = fncommon(Sim)
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	inst.sounds = sounds
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(6, 2)
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1, 1, 1)	

    MakeCharacterPhysics(inst, 100, .5)
    
    inst:AddTag("sheep")
    anim:SetBank("beefalo")
    anim:SetBuild("sheep_electric")
    anim:PlayAnimation("idle_loop", true)
    
    inst:AddTag("animal")
    inst:AddTag("largecreature")

    local hair_growth_days = 3

	--[[
    inst:AddComponent("beard")
    -- assume the beefalo has already grown its hair
    inst.components.beard.bits = 3
    inst.components.beard.daysgrowth = hair_growth_days + 1 
    inst.components.beard.onreset = function()
        inst.sg:GoToState("shaved")
    end
    
    inst.components.beard.canshavetest = function() if not inst.components.sleeper:IsAsleep() then return false, "AWAKEBEEFALO" end return true end
    
    inst.components.beard.prize = "beefalowool"
    inst.components.beard:AddCallback(0, function()
        if inst.components.beard.bits == 0 then
            anim:SetBuild("beefalo_shaved_build")
        end
    end)
    inst.components.beard:AddCallback(hair_growth_days, function()
        if inst.components.beard.bits == 0 then
            inst.hairGrowthPending = true
        end
    end)
	--]]
    
    --inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    --inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
	inst:AddTag("hostile")
     
	inst:DoPeriodicTask(1/10, function() dostaticsparks(inst, 1/10) end)
	 
    --inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

    --inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cotton", 0.33)
    
    --inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    
    --inst:AddComponent("knownlocations")
    --inst:AddComponent("herdmember")
    
    --inst:AddComponent("leader")
    --inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false
    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)

    --inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("datura")
    inst.components.periodicspawner:SetRandomTimes(40, 60)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()

    --MakeLargeBurnableCharacter(inst, "beefalo_body")
    --MakeLargeFreezableCharacter(inst, "beefalo_body")
    
    --inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.5
    inst.components.locomotor.runspeed = 7
    
    --inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    local brain = require "brains/rambrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGSheep")
	inst:ListenForEvent("upandaway_uncharge", function()
		print "Uncharged!"
		sheeptransform_uncharge(inst)
		return inst
	end, GetWorld())	
    return inst	
end

return Prefab( "forest/animals/sheep", fncommon, assets, prefabs),
	   Prefab( "forest/animals/sheep_electric", fnelectric, assets, prefabs)  
