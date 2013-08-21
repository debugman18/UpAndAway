local quakelevels =
{
	beanstalkQuake=
    {
		prequake = -3,                                                          --the warning before the quake
		quaketime = function() return GetRandomWithVariance(3,4) end, 	        --how long the quake lasts
		debrispersecond = function() return GetRandomWithVariance(3,2) end, 	--how much debris falls every second
		nextquake = function() return TUNING.TOTAL_DAY_TIME * 100 end, 	        --how long until the next quake
	},
}

local prefabs = 
{
	--Vanilla prefabs.
	"goldnugget",
	"skeleton",
	"marble",
	
	--Mod prefabs.
	"beanstalk_chunk",
	"golden_egg",
	"cloud_turf",
	"magic_beans",
}

local assets =
{
    Asset("ANIM", "anim/beanstalk.zip"),
	Asset("ANIM", "anim/beanstalk_chopped.zip" ),	
    Asset("SOUND", "sound/tentacle.fsb"),
}

--See whether or not the beanstalk has been chopped down.
local function OnLoad(inst, data)

	local anim = inst.entity:AddAnimState()
	
    if data then
	
        inst.isChopped = data.isChopped or false
		
        if inst.isChopped == true then
			
			anim:SetBuild("beanstalk")
            inst.SoundEmitter:KillSound("loop")
            inst.AnimState:PlayAnimation("idle_hole","loop")
	        inst.AnimState:SetTime(math.random()*2)    
            inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_hiddenidle_LP","loop") 
            inst:RemoveTag("wet")
            inst:AddTag("stone")
			
        elseif inst.isChopped == false then
		
			anim:SetBuild("beanstalk")
            inst.SoundEmitter:KillSound("loop")
            inst.AnimState:PlayAnimation("idle","loop")
	        inst.AnimState:SetTime(math.random()*2)    
            inst:RemoveTag("stone")
            inst:AddTag("wet")
			
        end
		
    end
	
end

--Save the current state of the beanstalk.
local function OnSave(inst, data)

    data.isChopped = inst.isChopped or false
	
end

--Longupdate things.
local function OnLongUpdate(inst, dt)

    inst.isChopped = (inst.isChopped or false)

end

--Fixes silly string.
local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end

--Makes the beanstalk climbable.
local function OnActivate(inst)

	--GetPlayer():DoTaskInTime(2, function()
	
	SetHUDPause(true)
	
	local function startadventure()
		
		local function onsaved()
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
			SaveGameIndex.data.slots[self.current_slot].modes.adventure = {world = 1}
		end
		
		--local levels = require("map/levels")				
		local level = 8
		local slot = SaveGameIndex:GetCurrentSaveSlot()		
		local customoptions = {
			preset = {"SKY_LEVEL_1"},
		}
		
		--local options = CustomizationScreen.options
		local character = GetPlayer().prefab		
		SetHUDPause(false)	
		
		--options = {
		--	preset = "SKY_LEVEL_1",
		--}

		
		--CustomizationScreen:LoadPreset("SKY_LEVEL_1")
		--GetPlayer().goneUp = true
		--GetPlayer().goneUpRemember = false	
		
		SaveGameIndex:FakeAdventure(onsaved, slot, level)	
		
		--SaveGameIndex:StartSurvivalMode(slot, character, customoptions, onsaved)
	end
	
	local function rejectadventure()
		SetHUDPause(false) 
		inst.components.activatable.inactive = true
		ProfileStatsSet("portal_rejected", true)
	end		
	
	local options = {
		{text="YES", cb = startadventure},
		{text="NO", cb = rejectadventure},  
	}


	TheFrontEnd:PushScreen(PopupDialogScreen(
	
	"Up and Away", 
	"The land above is strange and foreign. Do you want to continue?",
	
	options))
	
	--end)
	
end

--Beanstalks drop loot.
local function DropLoot(inst) 

    if inst.isChopped == true then

        local loot = {}
				
		--Remove any previous (random) loot table.
        inst.components.lootdropper:SetLoot(loot)
		
		--Beanstalk chunk drops.
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 1.0)	
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.75)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)
		inst.components.lootdropper:AddChanceLoot("beanstalk_chunk", 0.5)

		--Skeleton drops.
		inst.components.lootdropper:AddChanceLoot("skeleton", 0.6)
		inst.components.lootdropper:AddChanceLoot("skeleton", 0.2)
		
		--Gold nugget drops.
		inst.components.lootdropper:AddChanceLoot("goldnugget", 0.7)
		inst.components.lootdropper:AddChanceLoot("goldnugget", 0.5)
		
		--Marble drops.
		inst.components.lootdropper:AddChanceLoot("marble", 0.8)
		inst.components.lootdropper:AddChanceLoot("marble", 0.8)
		
		--Cloud turf drops.
		inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
		inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
		inst.components.lootdropper:AddChanceLoot("cloud_turf", 0.5)
		
		--Golden egg drops.
		inst.components.lootdropper:AddChanceLoot("golden_egg", 0.3)
		inst.components.lootdropper:AddChanceLoot("golden_egg", 0.3)
		
		--Magic bean drops.
		inst.components.lootdropper:AddChanceLoot("magic_beans", 0.21)
		inst.components.lootdropper:AddChanceLoot("magic_beans", 0.18)
		inst.components.lootdropper:AddChanceLoot("magic_beans", 0.15)
		inst.components.lootdropper:AddChanceLoot("magic_beans", 0.12)	

		--Drop loot near the beanstalk.
		inst.components.lootdropper:DropLoot()
		
    end
	
end

local function stalk_state(inst)

    if inst.isChopped == false then
	
        inst:RemoveTag("pillaremerging")
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_idle_LP","loop") 
        inst:RemoveEventCallback("animover", stalk_state)
        inst.isChopped = false
        inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)
		
    elseif inst.isChopped == true then
	
        inst:RemoveTag("pillarretracting")
        inst:RemoveEventCallback("animover", stalk_state)
        inst.isChopped = true
        inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)
		
    end

end

local function livingStalk(inst)

    inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)

    if inst.isChopped == false then
	
        inst.AnimState:PlayAnimation("emerge") 
        inst.AnimState:PushAnimation("idle", "loop")
        inst:ListenForEvent("animover", stalk_state)
        inst:AddTag("pillaremerging")
        inst:RemoveTag("stone")
        inst:AddTag("wet")
		
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge") 
		
        -- TheCamera:Shake(shakeType, duration, speed, scale)		
        TheCamera:Shake("FULL", 5.0, 0.05, .2)

    end
	
end

--This makes it rain items.
local function DoShake(inst)

    local world = GetWorld()
    local quaker = world.components.quaker

    if quaker and math.random() > 0.3 then
        quaker:ForceQuake("beanstalkQuake")
		
    else
        TheCamera:Shake("FULL", 5.0, 0.05, .2)
		
    end
end

--This doesn't do anything.
local function OnDeath(inst)
    print "Slayed the beanstalk."
end

--This does things when the beanstalk is chopped down.
local function OnChopped(inst)
	print "Was chopped."
	inst.isChopped = true
	
    if inst.isChopped == false then
	
        livingStalk(inst,true)
        return
		
    end

    inst:DoTaskInTime(1.0,DoShake,inst)

    inst:AddTag("pillarretracting")

	inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)
    --inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)

    inst.SoundEmitter:KillSound("loop")
    inst.AnimState:PlayAnimation("retract",false)
    inst:ListenForEvent("animover", stalk_state)
    inst.AnimState:PushAnimation("idle_hole","loop")
    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_die")
    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_die_VO")

    inst:RemoveTag("wet")
    inst:AddTag("stone")

    DropLoot(inst) 
	
end

--This changes the screen some if the player is far.
local function onfar(inst)
	TheCamera:SetDistance(100)
    if not inst.components.health:IsDead() then
        --inst.AnimState:SetMultColour(.1, .1, .1, 0.)
    end
	
end

--This changes the screen some if the player is near.
local function onnear(inst)
	TheCamera:SetDistance(100)
    if not inst.components.health:IsDead() then
        -- inst.AnimState:SetMultColour(1, 1, 1, 1)
    end

end

local function OnHit(inst, attacker, damage)  
    
    if attacker.components.combat and attacker ~= GetPlayer() and math.random() > 0.5 then
        attacker.components.combat:SetTarget(nil)
		
        if inst.components.health.currenthealth and inst.components.health.currenthealth <0 then
            inst.components.health:DoDelta(damage*.6, false, attacker)
        end
		
    end	
	
    if not inst.components.health:IsDead() and not inst.isChopped then
	
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_hurt_VO")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", "loop")
		
        -- :Shake(shakeType, duration, speed, scale)
        if attacker == GetPlayer() then
    	    TheCamera:Shake("SIDE", 0.7, 0.05, .4)
        end	
		
    end
end

local function fn(Sim)

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()	
	local light = SpawnPrefab("exitcavelight")	
	
    inst.entity:AddSoundEmitter()

    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_idle_LP","loop")
	
    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.isChopped = false
	
    inst.OnLongUpdate = OnLongUpdate

    --MakeObstaclePhysics(inst, 3, 24)
    inst.Physics:SetCollisionGroup(COLLISION.GROUND)
    trans:SetScale(2,2,2)
	   
	inst:AddTag("beanstalk")
	
    inst:AddTag("wet")

	--local minimap = inst.entity:AddMiniMapEntity()
	--minimap:SetIcon( "tentapillar.png" )

	anim:SetBank("tentaclepillar")
	anim:SetBuild("beanstalk")
	
	inst.AnimState:PlayAnimation("emerge") 
    inst.AnimState:PushAnimation("idle", "loop")	

	light.Transform:SetPosition(inst.Transform:GetWorldPosition())	
	
    -- anim:SetMultColour(.2, 1, .2, 1.0)

    -------------------
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.TENTACLE_HEALTH)
    inst.components.health:SetMinHealth(10)
    -------------------
    
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 30)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    -------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({})
    ---------------------  

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)
    --inst:ListenForEvent("death", OnDeath)
    --inst:ListenForEvent("minhealth", OnChopped)
	
	inst:AddComponent("activatable")
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.OnActivate = OnActivate	
	inst.components.activatable.quickaction = true
	
    inst:AddComponent("inspectable")
	
    return inst		
end

return Prefab( "common/monsters/beanstalk", fn, assets, prefabs )