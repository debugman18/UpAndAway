
local assets =
{
	Asset("ANIM", "anim/shop_basic.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
}

--These are the shopkeeper's speeches.
local SPEECH =
{
	--This is the speech that is loaded if no speech is defined.
	NULL_SPEECH=
	{
	    
		delay = 2,
		disableplayer = true,
		skippable = true,
		
		{
			string = "You... You shouldn't be here.",
			wait = 2,
			anim = nil,
			sound = nil,
		},
		{
			string = "Really. Something is off in this universe.",
			wait = 1,
			anim = nil,
			sound = nil,			
		},
	},
	
	--This is the speech where he asks for beefalo in exchange for magic beans.
	BEAN_QUEST =
	{
	    
		delay = 1,
		disableplayer = true,
		skippable = true,
		
		{
			string = "Hello there, (fella/darling).",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",		
		},
		{
			string = "You look tired.",
			wait = 2,
			anim = nil,
			sound = nil,			
		},		
		{
			string = "What if I told you I had something that could get you out?",
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = "That could whisk you away from this miserable plane?",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "Interested?",
			wait = 2,
			anim = nil,
			sound = nil,			
		},
		{
			string = "Then let's make a deal.",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "I have need of some Beefalo.",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "Those hairy beasts you've seen roaming the grasslands.",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "Bring me a few...",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "...Let's say three.",
			wait = 2,
			anim = nil,
			sound = nil,			
		},
		{
			string = "And I'll give you the ticket out.",
			wait = 3,
			anim = nil,
			sound = nil,			
		},
		{
			string = "Get to it, (fella/darling).",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",		
		},		
	},	
		
	--This is for when a trade is successful.	
	BEAN_SUCCESS =
	{
	    
		disableplayer = false,
		skippable = false,
		
		{
			string = "Best of luck, (fella/darling).",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",		
		},
	},
	
	--This is for when the player attacks the shopkeeper.	
	HIT =
	{
	    
		delay = 2,
		disableplayer = false,
		skippable = false,
		
		{
			string = "...",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",			
		},
	},	
	
	--This is for when the player keeps bugging the shopkeeper about the beans.	
	BEAN_REMINDER =
	{
	    
		delay = 2,
		disableplayer = false,
		skippable = false,
		
		{
			string = "Get to it, (fella/darling).",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",			
		},
	},		
	
	--This is to flag the player down.	
	FLAG_PLAYER =
	{
	    
		delay = 2,
		disableplayer = false,
		skippable = true,
		
		{
			string = "Hey you! Yes, you there!",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",			
		},
	},			
}

-------------------------------------------------------------------------------------------------

--These are various functions which play speeches.
local function activatebeanquest(inst)
	
			if GetPlayer():HasTag("return_customer") and not GetPlayer():HasTag("recieved_beans") then
	
			local conv_index = 1
			TheCamera:SetDistance(14)
	
			inst:DoTaskInTime(1.5, function()	
				if inst.components.maxwelltalker then
					if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
					inst.components.maxwelltalker.speech = "BEAN_REMINDER"
					inst.components.maxwelltalker:SetSpeech("BEAN_REMINDER")
					inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
					inst:RemoveComponent("playerprox")
					inst.components.activatable.inactive = true
				end
			end) 			
		
		elseif not GetPlayer():HasTag("recieved_beans") then 
	
			if inst.components.maxwelltalker then
				if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
				inst.components.maxwelltalker.speech = "BEAN_QUEST"
				inst.components.maxwelltalker:SetSpeech("BEAN_QUEST")
				inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
				GetPlayer():AddTag("return_customer")
				inst.components.activatable.inactive = true
			end	
		
		else end		
	
end

local function flagplayer(inst)
	if GetPlayer():HasTag("return_customer") and not GetPlayer():HasTag("recieved_beans") then
	
    local conv_index = 1
	TheCamera:SetDistance(9)
	
    inst:DoTaskInTime(1.5, function()	
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
			inst.components.maxwelltalker.speech = "BEAN_REMINDER"
			inst.components.maxwelltalker:SetSpeech("BEAN_REMINDER")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
            inst:RemoveComponent("playerprox")
        end
    end) 			
		
	elseif not GetPlayer():HasTag("recieved_beans") then 
	
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
			inst.components.maxwelltalker.speech = "FLAG_PLAYER"
			inst.components.maxwelltalker:SetSpeech("FLAG_PLAYER")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
		end	
		
	else end	
end

-------------------------------------------------------------------------------------------------

--This makes it so that you cannot kill the shopkeeper.
local function OnHit(inst, attacker)

	local fx = SpawnPrefab("maxwell_smoke")

    local doer = attacker
    if doer then
        local pos = Vector3( doer.Transform:GetWorldPosition() )
        GetSeasonManager():DoLightningStrike(pos)	
		
        if doer.components.combat then
			doer.components.combat:GetAttacked(nil, 0)
		end
    end
    inst.components.maxwelltalker.speech = "HIT"
    inst.components.maxwelltalker:SetSpeech("HIT")
    
    if inst.components.maxwelltalker:IsTalking() then
        inst.components.maxwelltalker:StopTalking()
    end
    
    inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
	
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")		
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())	
	inst:Remove()
    
end

-------------------------------------------------------------------------------------------------

--This knows what to do if the player doesn't do the trades requirements.
local function OnRefuseItem(inst, item)
    print "Item refused."
end

-------------------------------------------------------------------------------------------------

--This checks if the item fulfils particular requirements, and if it does, it returns true.
local function ShouldAcceptItem(inst, item)
	--Example trade. Gold nugget is what we give the shopkeep.
    if item.prefab == "goldnugget" then
        return true
    end
end

--This knows what to do if the player successfully gives us a particular item.
local function OnGetItemFromPlayer(inst, giver, item)
    
    if item.prefab == "goldnugget" then
	
	    --This knows what to spawn.
        local beanprize = SpawnPrefab("magic_beans") 
		local fx = SpawnPrefab("maxwell_smoke")
		
		--onTalk(inst)
		
		--Gives the player the magic beans.
        beanprize.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
		
		--Creates smoke for effect.
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")		
		fx.Transform:SetPosition(beanprize.Transform:GetWorldPosition())	
        print "This should be a pause."		
		
		--Confirms the trade via short dialogue.
		inst:DoTaskInTime(1.5, function()
			if inst.components.maxwelltalker then
				if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
				inst.components.maxwelltalker.speech = "BEAN_SUCCESS"
				inst.components.maxwelltalker:SetSpeech("BEAN_SUCCESS")
				inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
				GetPlayer():AddTag("recieved_beans")
			end
		end)	
    end
end

-------------------------------------------------------------------------------------------------
	
--This is the constructor for the shopkeeper prefab.
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    inst.Transform:SetTwoFaced()
	
	MakeObstaclePhysics(inst, 2)
	
	------------------------------------------------------
	
    anim:SetBank("shop")
    anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", "loop")
 
    inst:AddComponent("talker")
    inst.entity:AddLabel()
    inst.Label:SetFontSize(35)
    inst.Label:SetFont(TALKINGFONT)
    inst.Label:SetPos(0,5,0)
 
    ------------------------------------------------------
    --All of this is related to trading.
	
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem	
	
	------------------------------------------------------

    inst:AddComponent("named")
    inst.components.named:SetName("Shopkeeper")	

	--inst:AddComponent("talkable")
	
	--All of this is related to the speeches.	
    inst:AddComponent("maxwelltalker")
    inst.components.maxwelltalker.speeches = SPEECH
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(12, 15)
    inst.components.playerprox:SetOnPlayerNear(flagplayer)  	
	
	------------------------------------------------------
	
    inst:AddComponent("inspectable")
	
    --inst:ListenForEvent( "ontalk", function(inst, data) anim:PushAnimation("dial_loop", "loop") end)
    --inst:ListenForEvent( "donetalking", function(inst, data) anim:PushAnimation("idle", "loop") end)
	
    inst:AddComponent("combat")
    inst.components.combat.onhitfn = OnHit	
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(10000000)
	
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = activatebeanquest	
	inst.components.activatable.quickaction = true

    return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets) 
