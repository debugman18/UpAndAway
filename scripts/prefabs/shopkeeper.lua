SLEEP = "sleep"

local assets =
{
	Asset("ANIM", "anim/shop_basic.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
}

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
		
		inst:ListenForEvent("turnedon", function() phonographon(inst) end, inst.phonograph)
		
		--Gives the player the magic beans.
        beanprize.Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		--Creates smoke for effect.
		inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")		
		fx.Transform:SetPosition(beanprize.Transform:GetWorldPosition())	
        print "This should be a pause."		
    end
end

--This knows what to do if the player doesn't do those requirement things.
local function OnRefuseItem(inst, item)
    print "Item refused."
end

-------------------------------------------------------------------------------------------------

--This is the act of speaking.
local function onTalk(inst)
	inst.speech = speeches[speech or "SPEECH_1"]	
	inst:Show()
	
	if inst.speech then
		if inst.speech.delay then
			print "This should be a pause."
		end

		canskip = true
		
		local length = #inst.speech or 1
		
		--the loop that goes on while the speech is happening.
		for k, section in ipairs(inst.speech) do 
			local wait = section.wait or 1

			--Make with the talking, but not the moving of the lips.
	        if section.string then 
		        inst.SoundEmitter:PlaySound(inst.speech.voice or defaultvoice, "talk")
		        if inst.components.talker then
					inst.components.talker:Say(section.string, wait)
				end
			end

			--If there's an extra sound to be played it plays here.
			if section.sound then
				inst.SoundEmitter:PlaySound(section.sound)
			end

			--Patience, young shopkeeper.
			Sleep(wait)

			--It shuts the face hole.
			if section.string then	
				inst.SoundEmitter:KillSound("talk")
	        end
			
			--More patience, young shopkeeper.
        	Sleep(section.waitbetweenlines or 0.5)
		end
		
		--Talking sounds will stop.
		inst.SoundEmitter:KillSound("talk")	

		--This gives control back to the player.
		if inst.speech.disableplayer and inst.wilson and inst.wilson.sg.currentstate.name == "sleep" then		
			inst.wilson.sg:GoToState("wakeup") 
			inst.wilson:DoTaskInTime(1.5, function() 
				inst.wilson.components.playercontroller:Enable(true)			
				GetPlayer().HUD:Show()
				TheCamera:SetDefault()
			end)
		end
		
		--Reset the speech to nothing.
		inst.speech = nil
	end
	
	--[[
	for k,v in pairs(inputhandlers) do
	        v:Remove()
	end
	--]]
	
end	

--These are the shopkeeper's speeches.
local SPEECH =
{
	NULL_SPEECH=
	{
	    --The player can skip the dialogue, and is practically non-existent until the dialogue is finished or skipped.
		disableplayer = true,
		skippable = true,
		
		{
			string = "You... You shouldn't be here.",
			wait = 2
		},
		{
			string = "Really. Something is off in this universe.",
			wait = 1
		},
	},
	
	SPEECH_1 =
	{
	    --The player can skip the dialogue, and is practically non-existent until the dialogue is finished or skipped.
		disableplayer = true,
		skippable = true,
		
		{
			string = "Hello there, (fella/darling).",
			wait = 3
		},
		{
			string = "You look tired.",
			wait = 3
		},		
		{
			string = "What if I told you I had something that could get you out?",
			wait = 3
		},
		{
			string = "That could whisk you away from this miserable plane?",
			wait = 3
		},
		{
			string = "Interested?",
			wait = 3
		},
		{
			string = "Then lets make a deal.",
			wait = 3
		},
		{
			string = "I have need of some Beefalo.",
			wait = 3
		},
		{
			string = "Those hairy beasts you've seen roaming the grasslands.",
			wait = 3
		},
		{
			string = "Bring me a few...",
			wait = 3
		},
		{
			string = "...Lets say three.",
			wait = 3
		},
		{
			string = "And I'll give you the ticket out.",
			wait = 3
		},
		{
			string = "Get to it, (fella/darling).",
			wait = 3
		},		
	},
}
	
--This is the constructor for the shopkeeper.
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    inst.Transform:SetTwoFaced()
	
	------------------------------------------------------
	
    anim:SetBank("shop")
    anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", "loop")
 
    inst.entity:AddLabel()
    inst.Label:SetFontSize(28)
    inst.Label:SetFont(TALKINGFONT)
    inst.Label:SetPos(0,5,0)
    inst.Label:Enable(false) 
 
    ------------------------------------------------------
    --All of this is related to trading.
	
	
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem	
	
	--[[
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate	
	inst.components.activatable.quickaction = true 
	--]]
	
	------------------------------------------------------
 
	--All of this is related to the speeches.
	
    inst:AddComponent("talker")
	inst.components.talker.ontalk = onTalk	
	
    inst:AddComponent("inspectable")
	
    --inst:ListenForEvent( "ontalk", function(inst, data) inst.AnimState:PlayAnimation("dialog_pre") inst.AnimState:PushAnimation("dial_loop", true) end)
    --inst:ListenForEvent( "donetalking", function(inst, data) inst.AnimState:PlayAnimation("dialog_pst") inst.AnimState:PushAnimation("idle", true) end)

    return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets) 
