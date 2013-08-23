-- Configuration table.
-- See rc.lua and configloader.lua.
local CFG = TUNING.UPANDAWAY

local is_a_cow = CFG.SHOPKEEPER.IS_A_COW


local assets =
{
	Asset("ANIM", "anim/shop_basic.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
}

local prefabs =
{
	"maxwell_smoke",
	"magic_beans",
}

--These are the shopkeeper's speeches.
local SPEECH =
{
	--This is the speech that is loaded if no speech is defined.
	NULL_SPEECH=
	{
		
		delay = 2,
		disableplayer = false,
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
		disableplayer = false,
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
			string = "I have need of a Beefalo.",
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
			string = "Bring me one...",
			wait = 3,
			anim = nil,
			sound = nil,
		},
		{
			string = "...And I'll give you the ticket out.",
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
			string = "You fulfilled your end of the bargain.",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "Now for me to keep mine.",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "Your ticket out of here.",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "Best of luck, (fella/darling).",
			wait = 2,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
	},

	--This is for when the player attacks the shopkeeper.
	--(the entity gets removed, it will never run!)
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
		
		delay = 0.25,
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
		
		delay = 0.25,
		disableplayer = false,
		skippable = true,
		
		{
			string = "Hey you! Yes, you there!",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
	},

	--This gives the player a hint about the beans.
	BEANS_HINT =
	{
		
		delay = 0.25,
		disableplayer = false,
		skippable = true,
		
		{
			string = "Now, you can't just plant those beans in any old soil.",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "They require a powerful fertilizer.",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "Bonemeal, perhaps.",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "Then...",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
		{
			string = "...Just let the moon do the rest.",
			wait = 3,
			anim = nil,
			sound = "dontstarve/common/destroy_metal",
		},
	},
}

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
	
	--inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
	
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local beef = 1
local function beefalocheck(inst)
	local owner = GetPlayer()
	if owner and owner.components.leader then
		local x,y,z = owner.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x,y,z, 12, {"beefalo"})
		
		for k,v in pairs(ents) do
			if v.components.follower and owner.components.leader:IsFollower(v) and not GetPlayer():HasTag("received_beans") and GetPlayer():HasTag("return_customer") then
				print "Happy shopkeeper"
			
				if inst.updatetask then
					inst.updatetask:Cancel()
					inst.updatetask = nil
				end
				
				--This knows what to spawn.
				local beanprize = SpawnPrefab("magic_beans")
				local fx = SpawnPrefab("maxwell_smoke")

				if v.prefab == "beefalo" then
					v:AddTag("beefalofortrade")
				end
				
				--Happily removes the beefalo from your possesion.
				local beefalofortrade = TheSim:FindFirstEntityWithTag("beefalofortrade")
				fx.Transform:SetPosition(beefalofortrade.Transform:GetWorldPosition())
				beefalofortrade:Remove()
				inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")
			
				--Gives the player the magic beans.
				beanprize.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
		
							end
		end
	end
end

local function beefalotrade(inst)
	inst.updatetask = inst:DoPeriodicTask(beef, beefalocheck, 1)
end


-------------------------------------------------------------------------------------------------
-- Functions for trading cows for beans.
--
-- Below, buyer refers to the buyer of cows (the shopkeeper) and seller to the one who sells them
-- (the player).

local function canNegotiate(buyer, seller)
	return buyer.numbeans > 0
end

local function performTransaction(buyer, seller, cow)
	if seller.components.inventory then
		local reward = SpawnPrefab("magic_beans")

		seller.components.inventory:GiveItem(reward)

		if seller.components.leader then
			seller.components.leader:RemoveFollower(cow)
		end

		--Creates smoke for effect.
		local fx = SpawnPrefab("maxwell_smoke")
		if not fx.SoundEmitter then fx.entity:AddSoundEmitter() end
		fx.Transform:SetPosition(cow.Transform:GetWorldPosition())
		fx.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")

		cow:Remove()
		buyer.numbeans = buyer.numbeans - 1

		return true
	end
end

-- Under "normal usage", buyer is the shopkeeper and seller is the player.
--
-- Returns true if the negotiation was successful, and false/nil otherwise.
local function negotiateCows(buyer, seller)
	if not seller.components.leader or not seller.components.leader.followers then return false end

	local maxdistsq = CFG.SHOPKEEPER.MAX_COW_DIST^2

	local completed_transaction = false

	for cow in pairs(seller.components.leader.followers) do
		if not canNegotiate(buyer, seller) then break end

		if cow:IsValid() and is_a_cow(cow) and distsq(cow:GetPosition(), buyer:GetPosition()) <= maxdistsq then
			if performTransaction(buyer, seller, cow) then
				completed_transaction = true
			end
		end
	end

	return completed_transaction
end

-------------------------------------------------------------------------------------------------

local function greetPlayer(inst)
	if not inst.flagger or inst.customer then return end

	if inst.components.maxwelltalker then
		if inst.components.maxwelltalker:IsTalking() then return end
		inst.components.maxwelltalker:SetSpeech("FLAG_PLAYER")
		inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
	end
end

local function flagplayer(inst)
	if not inst.flagger then return end

	if inst.components.maxwelltalker and inst.components.maxwelltalker:IsTalking() then return end

	if not inst.customer then
		greetPlayer(inst)	
	elseif not inst.gavebeans and inst.numbeans > 0 then
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
			inst.components.maxwelltalker:SetSpeech("BEAN_REMINDER")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
		end
	elseif not inst.gavebeans then
		print "I have nothing to give you!"
	elseif inst.gavebeans then
		if inst.components.maxwelltalker then
			inst.components.maxwelltalker:SetSpeech("BEANS_HINT")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
		end
		inst.flagger = false
	else
		print "If this is printing, there's new flagging logic to account for!"
	end
end

-------------------------------------------------------------------------------------------------

-- This handles explicit interaction through clicking on him.
-- (speech triggers and cow trading)
local function onactivate(inst, doer)
	if inst.components.maxwelltalker and inst.components.maxwelltalker:IsTalking() then
		inst.components.maxwelltalker:StopTalking()
	end

	inst:DoTaskInTime(0, function(inst)
		if inst.components.activatable then inst.components.activatable.inactive = true end
	end)

	if not inst.customer then
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
			inst.components.maxwelltalker:SetSpeech("BEAN_QUEST")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
		end
		inst.customer = true
	elseif inst.numbeans > 0 and negotiateCows(inst, doer) then
		print "This should be a pause."
		
		--Confirms the trade via short dialogue.
		inst:DoTaskInTime(1, function()
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
				inst.components.maxwelltalker:SetSpeech("BEAN_SUCCESS")
				inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
			end
		end)

		inst.gavebeans = true
	elseif inst.numbeans > 0 then
		-- When explicitly clicking on him, I think he should remind the player even if he gave beans already.
		--TheCamera:SetDistance(14)
	
		if inst.components.maxwelltalker then
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
			inst.components.maxwelltalker:SetSpeech("BEAN_REMINDER")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
		end
	else
		print "What else do you expect from me?"
	end
end

-------------------------------------------------------------------------------------------------

--This handles the remembering.
local function onsave(inst, data)
	data.gavebeans = inst.gavebeans or nil
	data.customer  = inst.customer or nil
	-- It's best to store a value which, if absent (save corruption, mod disabling, etc.), should default to false (or nil).
	data.doneflagging = not inst.flagger or nil
	data.numbeans = inst.numbeans
end

local function onload(inst, data)
	if not data then return end

	inst.gavebeans = data.gavebeans
	inst.customer = data.customer
	inst.flagger = not data.doneflagging
	inst.numbeans = data.numbeans or inst.numbeans

	-- This is just for inconsistent save data.
	if inst.gavebeans then
		inst.customer = true
	end
end

-------------------------------------------------------------------------------------------------
-- Testing functions

--This knows what to do if the player doesn't do the trades requirements.
local function OnRefuseItem(inst, item)
	print "Item refused."
end

--This checks if the item fulfils particular requirements, and if it does, it returns true.
local function ShouldAcceptItem(inst, item)
	--Example trade. Gold nugget is what we give the shopkeep.
	if item.prefab == "goldnugget" then
		return true
	end
end

--This knows what to do if the player successfully gives us a particular item.
local function OnGetItemFromPlayer(inst, giver, item)
	inst.customer = true
	
	--This gives you magic beans in exchange for gold. For testing purposes only.
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
				inst.components.maxwelltalker:SetSpeech("BEAN_SUCCESS")
				inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
			end
			inst.gavebeans = true
		end)
	end
end

-- End of testing functions
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
	
	MakeObstaclePhysics(inst, 1)
	
	------------------------------------------------------
	
	anim:SetBank("shop")
	anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", true)


	inst.flagger = true
	inst.numbeans = CFG.SHOPKEEPER.NUMBEANS

 
	inst:AddComponent("talker")
	inst.entity:AddLabel()
	inst.Label:SetFontSize(35)
	inst.Label:SetFont(TALKINGFONT)
	inst.Label:SetPos(0,5,0)

	------------------------------------------------------
 
	if CFG.DEBUG then
		--All of this is related to trading.
		
		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst.components.trader.onrefuse = OnRefuseItem
	end
	
	------------------------------------------------------

	inst:AddComponent("named")
	inst.components.named:SetName("Shopkeeper")

	--inst:AddComponent("talkable")
	inst.OnLoad = onload
	inst.OnSave = onsave
	
	--All of this is related to the speeches.
	inst:AddComponent("maxwelltalker")
	inst.components.maxwelltalker.speeches = SPEECH
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(8, 8)
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
	inst.components.activatable.OnActivate = onactivate
	inst.components.activatable.quickaction = true

	return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets, prefabs)
