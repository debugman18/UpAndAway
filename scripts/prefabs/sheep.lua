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
    grunt = "sheep/sheep/baa",
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
	return inst.charged and "CHARGED" or "UNCHARGED"
end

local function dostaticsparks(inst)
	local radius = 2*(inst.Physics and inst.Physics:GetRadius() or 1)

	local theta = 2*math.pi*math.random()
	local phi = math.pi*math.random()

	local cosphi, sinphi = math.cos(phi), math.sin(phi)

	local pos = inst:GetPosition() + Vector3( radius*math.cos(theta)*sinphi, 1 + radius*cosphi, radius*math.sin(theta)*sinphi )
	local spark = SpawnPrefab("sparks_fx")
	spark.Transform:SetPosition(pos:Get())
	spark.Transform:SetScale(0.9, 0.5, 0.5)
end

local function set_electricsheep(inst, force)
	if not inst.charged and not force then return end

	inst:RemoveTag("storm_ram")
	inst:AddTag("electric_sheep")	
	inst:RemoveTag("largecreature")
	inst:RemoveTag("hostile")

	inst.DynamicShadow:SetSize(3, 2)
	
	inst.Light:Enable(false)
	
	inst.Transform:SetScale(0.65, 0.75, 0.65)
    
    inst.AnimState:SetBuild("sheep_baby_build")
    inst.AnimState:PlayAnimation("idle_loop", true)

	
    --inst.components.beard.bits = 3
    --inst.components.beard.daysgrowth = hair_growth_days + 1 
    --inst.components.beard.onreset = function() inst.sg:GoToState("shaved") end
	
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
     
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cotton", 0.70)

    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false

	inst.components.periodicspawner:Stop()
    inst.components.periodicspawner:SetRandomTimes(20, 100)
    inst.components.periodicspawner:SetDensityInRange(10, 1)
    inst.components.periodicspawner:SetMinimumSpacing(10)
    inst.components.periodicspawner:Start()
    
    inst.components.sleeper:SetResistance(2)
    
    local brain = require "brains/sheepbrain"
    inst:SetBrain(brain)   
	
	inst.charged = false
end

local function set_stormram(inst, force)
	if inst.charged and not force then return end

	inst:RemoveTag("electric_sheep")
	inst:AddTag("storm_ram")
    inst:AddTag("largecreature")
	inst:AddTag("hostile")
	
    inst.Light:Enable(true)
    	
	inst.DynamicShadow:SetSize(6, 2)
	
	inst.Transform:SetScale(1, 1, 1)	

    inst.AnimState:SetBuild("sheep_electric")
    inst.AnimState:PlayAnimation("idle_loop", true)
    

    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetKeepTargetFunction(KeepTarget)
	
    inst.components.health:SetMaxHealth(TUNING.BEEFALO_HEALTH)

    inst.components.lootdropper:SetLoot(loot)
    --inst.components.lootdropper:AddChanceLoot("cotton", 0.33)
    
    inst.components.follower.maxfollowtime = TUNING.BEEFALO_FOLLOW_TIME
    inst.components.follower.canaccepttarget = false

	inst.components.periodicspawner:Stop()
    inst.components.periodicspawner:SetRandomTimes(40, 60)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(8)
    inst.components.periodicspawner:Start()
    
    inst.components.sleeper:SetResistance(4)
    
    local brain = require "brains/rambrain"
    inst:SetBrain(brain)


	;(function(delay)
		local task
		task = inst:DoPeriodicTask(delay, function(inst)
			if inst.charged then
				dostaticsparks(inst)
			else
				task:Cancel()
			end
		end)
	end)(1/2)
	
	inst.charged = true
end

local function OnSave(inst, data)
	data.charged = inst.charged or nil
end

local function OnLoad(inst, data)
	if data and data.charged then
		set_stormram(inst)
	end
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
    ;(function(color) anim:SetMultColour(color, color, color, 1) end)(0.5 + 0.5*math.random())
	
	local light = inst.entity:AddLight()
	light:SetRadius(2)
    light:SetFalloff(1)
    light:SetIntensity(.9)
    light:SetColour(235/255,121/255,12/255)	
	light:Enable(false)

    MakeCharacterPhysics(inst, 100, .5)
	

    inst:AddTag("animal")

	
    inst:AddComponent("eater")	
    inst.components.eater:SetVegetarian()	

	--inst:AddComponent("beard")
    --local hair_growth_days = 3	
    
    inst:AddComponent("combat")	
	
    inst:AddComponent("health")	
	
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("knownlocations")
    inst:AddComponent("herdmember")
    
    inst:AddComponent("leader")
    inst:AddComponent("follower")

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("skyflower")	

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")
    
    inst:AddComponent("locomotor")	
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 7
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("sleeper")	
	
	inst:SetStateGraph("SGSheep")
	

	set_electricsheep(inst, true)


    inst:ListenForEvent("newcombattarget", OnNewTarget)
    inst:ListenForEvent("attacked", OnAttacked)
	
	inst:ListenForEvent("upandaway_charge", function()
		print "Charged!"
		set_stormram(inst)
	end, GetWorld())

	inst:ListenForEvent("upandaway_uncharge", function()
		print "Uncharged!"
		set_electricsheep(inst)
	end, GetWorld())
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad	

    return inst	
end

return Prefab( "cloudrealm/animals/sheep", fn, assets, prefabs)
