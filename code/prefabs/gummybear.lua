BindGlobal()

local assets =
{
	Asset("ANIM", "anim/gummybear_naughty.zip"),
	Asset("ANIM", "anim/gummybear_nice.zip"),
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("ANIM", "anim/pig_build.zip"),
	Asset("ANIM", "anim/pigspotted_build.zip"),
	Asset("ANIM", "anim/pig_guard_build.zip"),
	Asset("ANIM", "anim/werepig_build.zip"),
	Asset("ANIM", "anim/werepig_basic.zip"),
	Asset("ANIM", "anim/werepig_actions.zip"),
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "nightmarefuel",
}

local function become_nice(inst)
	if inst:HasTag("cuddly") then return end
	inst.AnimState:SetBuild("gummybear_nice")
	-- Tag added in the stategraph event handler.
	inst:PushEvent("becomenice")
end

local function become_naughty(inst)
	if not inst:HasTag("cuddly") then return end
	inst.AnimState:SetBuild("gummybear_naughty")
	-- Tag removed in the stategraph event handler.
	inst:PushEvent("becomenaughty")
end

local function OnNewTarget(inst, data)
	--print(inst, "OnNewTarget", data.target)
    inst.components.combat:ShareTarget(inst.components.combat.target, 30, function(dude) return dude:HasTag("gumbear") and not dude.components.health:IsDead() end, 12)
	become_naughty(inst)
end

local function retargetfn(inst)
    local entity = FindEntity(inst, 10, function(guy) 
		return inst.components.combat:CanTarget(guy) and not guy:HasTag("gumbear")
    end)
    return entity
end


local function CalcSanityAura(inst, observer)
	if inst.components.combat.target then
		return -TUNING.SANITYAURA_SMALL
	end	
	return 0
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude) return dude:HasTag("gumbear") and not dude.components.health:IsDead() end, 6)
end

    
local function commonfn()
	local inst = CreateEntity()

    inst:AddComponent("health")

    return inst
end


local function bear()
	local inst = commonfn()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	inst.Transform:SetFourFaced()
 
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )    	
	inst.Transform:SetScale(0.9, 0.9, 0.9)

    MakeCharacterPhysics(inst, 50, .5)

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("gummybear_nice")
    inst.AnimState:PlayAnimation("idle", true)

    local color1 = 0.1 + math.random() * 0.9
    local color2 = 0.1 + math.random() * 0.9
    local color3 = 0.1 + math.random() * 0.9
    inst.AnimState:SetMultColour(color1, color2, color3, 0.75)    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 5 
    inst.components.locomotor.walkspeed = 2  


    inst:AddComponent("follower")


    inst:AddComponent("inventory")
    
    ------------------------------------------

    inst:AddComponent("lootdropper")

    ------------------------------------------

    inst:AddComponent("knownlocations")

    inst:AddTag("monster")
	inst:AddTag("hostile")
    inst:AddTag("cuddly")
    inst:AddTag("gumbear")
    inst:AddTag("wet")

    inst:AddTag("notraptrigger")

    inst:AddComponent("inspectable")

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.GUMMYBEAR_NAMES
    inst.components.named:PickNewName()

    local brain = require "brains/gummybearbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGgummybear")
        
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = CalcSanityAura
	
	inst.components.health:SetMaxHealth(360)

    inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
	inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(34)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRange(2)
    inst.components.combat:SetRetargetFunction(3, retargetfn)

    inst:ListenForEvent("attacked", OnAttacked)	

	-- Already handled by the periodic task.
	--[[
    inst:ListenForEvent("losttarget", function(inst) 
       inst:AddTag("cuddly")
    end)
    inst:ListenForEvent("giveuptarget", function(inst) 
       inst:AddTag("cuddly")
    end)
	]]--
    inst:ListenForEvent("newcombattarget", function(inst, data) 
        if data.target ~= nil then
			OnNewTarget(inst)
        end
    end)

	local cuddlyness_thread
	cuddlyness_thread = inst:StartThread(function()
		local function resume()
			WakeTask(cuddlyness_thread)
		end

		while inst:IsValid() do
			Sleep(30/100)

			if inst:IsAsleep() then
				Game.ListenForEventOnce("entitywake", resume)
				Hibernate()
			end

			if not inst.components.combat.target then
				Sleep(1)
				if not inst.components.combat.target then
					become_nice(inst)
				end
			else
				become_naughty(inst)
			end
		end
	end) 

    return inst
end


local function rainbow()
	local inst = CreateEntity()
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    inst.AnimState:SetBank("collapse")
    inst.AnimState:SetBuild("structure_collapse_fx")
    inst:AddTag("NOCLICK")

    inst.AnimState:PlayAnimation("collapse_large")

	inst:AddTag("FX")
	inst:ListenForEvent("animover", function() inst:Remove() end)

	inst:StartThread(function()
		inst.AnimState:SetMultColour(0.7, 0.3, 0.3, 1)  
		Sleep(0.25)
		inst.AnimState:SetMultColour(0.7, 0.7, 0.3, 1)  
		Sleep(0.25)
		inst.AnimState:SetMultColour(0.3, 0.7, 0.3, 1)  
		Sleep(0.25)
		inst.AnimState:SetMultColour(0.3, 0.7, 0.7, 1)  
		Sleep(0.25)
		inst.AnimState:SetMultColour(0.3, 0.3, 0.7, 1)  
	end)

	return inst
end

--[[
local function KeepTarget(isnt, target)
    return true
end
]]--

return {
    Prefab( "common/monsters/gummybear", bear, assets, prefabs),
	Prefab( "common/monsters/gummybear_rainbow", rainbow, assets, prefabs) 
}
