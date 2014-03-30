BindGlobal()

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

local generateSpeeches = modrequire 'resources.shopkeeper_speech'


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
		TheMod:DebugSay "I have nothing to give you!"
	elseif inst.gavebeans then
		if inst.components.maxwelltalker then
			inst.components.maxwelltalker:SetSpeech("BEANS_HINT")
			inst.task = inst:StartThread(function() inst.components.maxwelltalker:DoTalk(inst) end)
			if inst.components.maxwelltalker:IsTalking() then inst.components.maxwelltalker:StopTalking() end
		end
		inst.flagger = false
	else
		TheMod:Say "If this is printing, there's new flagging logic to account for!"
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
		TheMod:DebugSay "This should be a pause."
		
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
		TheMod:DebugSay "What else do you expect from me?"
	end
end

local function has_given_quest(inst)
	return inst.customer
end

local function try_despawn(inst)
	if not inst:IsValid() then return end

	TheMod:DebugSay("Attempting to despawn [", inst, "]...")
	
	local sm = GetSeasonManager()
	if not has_given_quest(inst)
		and inst:IsAsleep()
		and sm and not sm:IsRaining()
	then
		TheMod:DebugSay("Despawned [", inst, "].")
		inst:Remove()
		return
	end
	TheMod:DebugSay("Did not despawn [", inst, "].")
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
	TheMod:DebugSay "Item refused."
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
		TheMod:DebugSay "This should be a pause."
		
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

	inst:AddTag("shopkeeper")
	
	------------------------------------------------------
	
	anim:SetBank("shop")
	anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", true)

    local minimap = inst.entity:AddMiniMapEntity()
    --This will be his own minimap icon.
    --minimap:SetIcon("monkey_barrel.png")	

	inst.flagger = true
	inst.numbeans = CFG.SHOPKEEPER.NUMBEANS

 
	inst:AddComponent("talker")
	inst.entity:AddLabel()
	inst.Label:SetFontSize(35)
	inst.Label:SetFont(TALKINGFONT)
	inst.Label:SetPos(0,5,0)

	------------------------------------------------------
 
	--[[
	if TheMod:Debug() then
		--All of this is related to trading.
		
		inst:AddComponent("trader")
		inst.components.trader:SetAcceptTest(ShouldAcceptItem)
		inst.components.trader.onaccept = OnGetItemFromPlayer
		inst.components.trader.onrefuse = OnRefuseItem
	end
	]]--
	
	------------------------------------------------------

	inst:AddComponent("named")
	inst.components.named:SetName("Shopkeeper")

	--inst:AddComponent("talkable")
	inst.OnLoad = onload
	inst.OnSave = onsave
	
	--All of this is related to the speeches.
	inst:AddComponent("maxwelltalker")
	inst.components.maxwelltalker.speeches = generateSpeeches()
	
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

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("shopkeeper.tex")

	inst:ListenForEvent("rainstop", function() try_despawn(inst) end, GetWorld())
	inst:ListenForEvent("entitysleep", try_despawn)
	inst:DoTaskInTime(0, try_despawn)

	return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets, prefabs)
