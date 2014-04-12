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

local shopkeeper_speech = modrequire "resources.shopkeeper_speech"


-------------------------------------------------------------------------------------------------
--This makes it so that you cannot kill the shopkeeper.
--It is used as a callback for the HIT speech.
local function onhit_speechcallback(inst, speech_mgr)
	local doer = speech_mgr.listener

	local pos = Vector3( doer.Transform:GetWorldPosition() )
	GetSeasonManager():DoLightningStrike(pos)
	
	if doer.components.combat then
		doer.components.combat:GetAttacked(nil, 0)
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/disappear")

	local fx = SpawnPrefab("maxwell_smoke")
	if fx then
		fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	end

	inst:Remove()
end

-- This works even if the attacker is not the player.
local function OnHit(inst, attacker)
	inst.components.speechgiver:PlaySpeech("HIT", attacker or GetPlayer())
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
		buyer.beans_to_give = (buyer.beans_to_give or 0) + 1

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

	for cow in pairs(seller.components.leader.followers) do
		if not canNegotiate(buyer, seller) then break end

		if cow:IsValid() and is_a_cow(cow) and distsq(cow:GetPosition(), buyer:GetPosition()) <= maxdistsq then
			performTransaction(buyer, seller, cow)
		end
	end

	return buyer.beans_to_give and buyer.beans_to_give > 0
end

-------------------------------------------------------------------------------------------------

local function flagplayer(inst)
	if inst.components.speechgiver:IsSpeaking() then return end

	if not inst.customer then
		inst.components.speechgiver:PlaySpeech("FLAG_PLAYER", GetPlayer())
	elseif not inst.gavebeans and inst.numbeans > 0 then
		inst.components.speechgiver:PlaySpeech("BEAN_REMINDER", GetPlayer())
	elseif not inst.gavebeans then
		TheMod:DebugSay "I have nothing to give you!"
	else
		if not inst.gavebeans then
			TheMod:Say "If this is printing, there's new flagging logic to account for!"
		end
	end
end

-------------------------------------------------------------------------------------------------

-- This handles explicit interaction through clicking on him.
-- (speech triggers and cow trading)
--
-- The setting of flags such as inst.gavebeans is done as speech callbacks.
-- See the configuration of the speechgiver component below.
--
-- When this does not return true, the "I can't do that." message is displayed
-- by the player.
local function oninteract(inst, doer)
	inst.components.speechgiver:CancelAll()

	if not inst.customer then
		inst.components.speechgiver:PlaySpeech("BEAN_QUEST", doer)
		return true
	elseif inst.numbeans > 0 and negotiateCows(inst, doer) then
		inst.components.speechgiver:PlaySpeech("BEAN_SUCCESS", doer)
		inst.components.speechgiver:PushSpeech("BEAN_HINT", doer)
		return true
	elseif inst.numbeans > 0 and not inst.gavebeans then
		inst.components.speechgiver:PlaySpeech("BEAN_REMINDER", doer)
		return true
	elseif inst.gavebeans then
		inst.components.speechgiver:PlaySpeech("BEAN_HINT", doer)
		inst.components.speechgiver:ForbidCutScenesInQueue()
		return true
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
	data.customer  = inst.customer or nil
	data.gavebeans = inst.gavebeans or nil

	data.numbeans = inst.numbeans
	data.beans_to_give = inst.beans_to_give ~= 0 and inst.beans_to_give or nil
end

local function onload(inst, data)
	if not data then return end

	inst.customer = data.customer
	inst.gavebeans = data.gavebeans

	inst.numbeans = data.numbeans or inst.numbeans
	inst.beans_to_give = data.beans_to_give

	if inst.beans_to_give == 0 then
		inst.beans_to_give = nil
	end

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
	--This gives you magic beans in exchange for gold. For testing purposes only.
	if ShouldAcceptItem(inst, item) then
		inst.customer = true

		inst.beans_to_give = 1

		inst.components.speechgiver:PlaySpeech("BEAN_SUCCESS", doer)
		inst.components.speechgiver:PushSpeech("BEAN_HINT", doer)
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
	inst:AddTag("character")
	
	------------------------------------------------------
	
	anim:SetBank("shop")
	anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", true)

    local minimap = inst.entity:AddMiniMapEntity()
    --This will be his own minimap icon.
    --minimap:SetIcon("monkey_barrel.png")	

	inst.numbeans = CFG.SHOPKEEPER.NUMBEANS

 
	inst.entity:AddLabel()
	inst:AddComponent("talker")
	inst.Label:SetFontSize(35)
	inst.Label:SetFont(TALKINGFONT)
	inst.Label:SetPos(0,5,0)

	------------------------------------------------------
 
	if TheMod:Debug() then
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
	inst:AddComponent("speechgiver")
	do
		local speechgiver = inst.components.speechgiver

		speechgiver:AddSpeechTable(shopkeeper_speech.SPEECHES)
		speechgiver:AddWordMapTable(shopkeeper_speech.WORD_MAP)

		speechgiver:SetOnInteractFn(oninteract)

		speechgiver:AddSpeechCallback("HIT", onhit_speechcallback)
		speechgiver:AddSpeechCallback("BEAN_QUEST", function(inst)
			inst.customer = true
		end)

		speechgiver:AddSpeechData("BEAN_SUCCESS", {
			givebeans = function(inst, player)
				if inst.beans_to_give and inst.beans_to_give > 0 then
					for i = 1, inst.beans_to_give do
						if i ~= 1 then
							Sleep(0.5)
						end
						local reward = SpawnPrefab("magic_beans")
						player.components.inventory:GiveItem(reward)
						-- This is just to ensure the game saves correctly
						-- in the middle of this.
						inst.beans_to_give = inst.beans_to_give - 1
					end
				end
				inst.gavebeans = true
				inst.beans_to_give = nil
			end,
		})
	end
	
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
	
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("shopkeeper.tex")

	inst:ListenForEvent("rainstop", function() try_despawn(inst) end, GetWorld())
	inst:DoTaskInTime(0, function(inst)
		try_despawn(inst)
		if inst:IsValid() then
			inst:ListenForEvent("entitysleep", try_despawn)
		end
	end)

	return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets, prefabs)
