BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
    Asset("ANIM", "anim/owl.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
    Asset("ANIM", "anim/ds_pig_attacks.zip"),
    Asset("SOUND", "sound/merm.fsb"),
}

local prefabs = CFG.OWL.PREFABS

SetSharedLootTable( "owl", CFG.OWL.LOOT) 

local function ontalk(inst, script)
	--inst.SoundEmitter:PlaySound("upandaway/creatures/owl/taunt")
end

local function DoHoot(inst)
	if not (inst.sg and inst.sg:HasStateTag("busy")) then
		inst.components.talker:Say("Whoo?", 1, true)
		inst.SoundEmitter:PlaySound("upandaway/creatures/owl/taunt")
	end
end

local function RetargetFn(inst, target)
    inst:DoTaskInTime(0, function(inst, target)
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, CFG.OWL.SIGHT_DIST, "owl_crystal")
        for k,v in pairs(ents) do
            if v and v:HasTag("owl_crystal") then
                local rock = v
                if inst.components.homeseeker then
                    inst.components.homeseeker:SetHome(rock)
                end    
            end    
        end   
    end)     

    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, CFG.OWL.DEFEND_DIST, function(guy)
        if guy.components.combat and guy.components.combat.target
		and guy.components.combat.target == inst then --fight back!
			return true
		elseif guy:HasTag("player") then --do you like that guy?
            return guy.components.reputation 
            and guy.components.reputation:GetReputation("strix") <= CFG.OWL.REPUTATION.ENEMY_THRESHOLD
        else
            return guy.components.health
            and not guy:HasTag("owl") 
            and not guy:HasTag("epic")
            and not guy:HasTag("beanmonster")
            and not guy:HasTag("beanprotector")
            and not guy:HasTag("cloudneutral")
            and not guy:HasTag("beanlet")
            and not guy:HasTag("smallcreature")
            and not guy:HasTag("gumbear")
        end
    end)
    return invader
end

local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < CFG.OWL.DEFEND_DIST*CFG.OWL.DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)     
end

local function OnAttacked(inst, data)
    inst.components.talker:Say("Whoo!", 2, true)
    local attacker = data and data.attacker
    if attacker and RetargetFn(inst, attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = CFG.OWL.MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= CFG.OWL.SHARE_TARGET_DIST*CFG.OWL.SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, CFG.OWL.SHARE_TARGET_DIST, function(dude)
                return dude.components.homeseeker
                       and dude.components.homeseeker.home
                       and dude.components.homeseeker.home == home
            end, targetshares)
        end
    end
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(CFG.OWL.SCALE, CFG.OWL.SCALE, CFG.OWL.SCALE)

    MakeCharacterPhysics(inst, 50, .5)

    anim:SetBank("pigman")
    anim:SetBuild("owl")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = CFG.OWL.RUNSPEED
    inst.components.locomotor.walkspeed = CFG.OWL.WALKSPEED
    
    inst:SetStateGraph("SGowl")
    anim:Hide("hat")

    inst:AddTag("character")
    inst:AddTag("owl")
    inst:AddTag("cloudmonster")

    local brain = require "brains/owlbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(CFG.OWL.DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.OWL.ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(CFG.OWL.HEALTH)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("owl")
    
    inst:AddComponent("inventory")

    inst:AddComponent("trader")
    inst.components.trader:Enable()
    inst.components.trader:SetAcceptTest(function(inst, item)
        -- Check for reputation level before allowing player to give food or crystals.
		local reputation = ThePlayer.components.reputation:GetReputation("strix")
        -- Crystals are accepted at most reputation levels.
        if item:HasTag("owl_crystal") and reputation >= CFG.OWL.REPUTATION.CRYSTAL_THRESHOLD then
			return true
        -- Food is not accepted until a higher reputation level.
        elseif item.components.edible and reputation >= CFG.OWL.REPUTATION.FOOD_THRESHOLD then
			return true
		end
        return false
    end)
    inst.components.trader.onaccept = function(inst, giver, item)
		if not giver.components.reputation then return end
        if item:HasTag("owl_crystal") then
            giver.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.CRYSTAL_GIVEN, true)
        elseif item.components.edible then
            giver.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.FOOD_GIVEN, true)
        end
    end
    
    inst:AddComponent("inspectable")

    inst:AddComponent("homeseeker")
    inst:AddComponent("knownlocations")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0,-400,0)  
    inst.components.talker:StopIgnoringAll()  

    inst:DoPeriodicTask(CFG.OWL.WHO_INTERVAL, DoHoot, math.random()*6 +6)

    inst:ListenForEvent("entity_death", function(world, data)
        local victim = data.inst
        local killer = data.cause
		-- This does not work if the player isn't an unique prefab.
		if ThePlayer.prefab == killer then
			-- Killed this owl
			if victim == inst then
				ThePlayer.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.DEATH, true)
			-- Killed this owl's target
			elseif victim == inst.components.combat.target then
				ThePlayer.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.ENEMY_KILLED, true)
			-- Killed something which was targeting this owl
			elseif inst == victim.components.combat.target then
				ThePlayer.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.ENEMY_KILLED, true)
			-- Killed an owl within sight of this owl
			elseif victim ~= inst and victim.prefab == "owl" then
				local x,y,z = inst.Transform:GetWorldPosition()
				local ents = TheSim:FindEntities(x,y,z, CFG.OWL.SIGHT_DIST, "owl")
				for k,v in pairs(ents) do
					if v and v == victim then
						ThePlayer.components.reputation:DoDelta("strix", CFG.OWL.REPUTATION.FRIEND_KILLED, true)
					end
				end
			end
		end
    end, TheWorld)

    return inst
end

return Prefab("cloudrealm/animals/owl", fn, assets, prefabs) 
