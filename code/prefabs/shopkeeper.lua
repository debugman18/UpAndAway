BindGlobal()

-- Configuration table.
-- See rc.lua and configloader.lua.
local cfg = Configurable("SHOPKEEPER")

local is_a_cow = cfg("IS_A_COW")


local assets =
{
    Asset("ANIM", "anim/shop_basic.zip"),
    Asset("SOUND", "sound/maxwell.fsb"),
}

local prefabs =
{
    "maxwell_smoke",
    "magic_beans",
    "kettle_item",
}

local shopkeeper_speech = modrequire "resources.shopkeeper_speech"

-- Name of the quest for reaching the cloudrealm.
local PRIMARY_QUEST = "reachtheclouds"


-------------------------------------------------------------------------------------------------
--This makes it so that you cannot kill the shopkeeper.
--It is used as a callback for the HIT speech.
local function onhit_speechcallback(inst, speech_mgr)
    if inst:HasTag("permanent") then return end

    local doer = speech_mgr.listener

    local pos = Vector3( doer.Transform:GetWorldPosition() )
    GetPseudoSeasonManager():DoLightningStrike(pos)
    
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
local function OnHit(inst, data)
    local attacker = data.attacker

    if inst.components.speechgiver:IsInCutScene() and not (attacker and attacker:HasTag("player")) then
        return
    end

    inst.components.speechgiver:CancelAll()
    local quester = attacker and attacker.components.quester
    if quester then
        quester:AddQuest(PRIMARY_QUEST)
        quester:SetFlag(PRIMARY_QUEST, "hitshopkeeper", true)
    end
    if attacker then
        inst.components.speechgiver:PlaySpeech("HIT", attacker)
    end
end

-------------------------------------------------------------------------------------------------
-- Functions for trading cows for beans.
--
-- Below, buyer refers to the buyer of cows (the shopkeeper) and seller to the one who sells them
-- (the player).

local function canNegotiate(buyer, seller)
    local quester = seller.components.quester
    local numbeans = quester and quester:GetAttribute(PRIMARY_QUEST, "numbeans")
    return numbeans and numbeans > 0
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

        local quester = assert( seller.components.quester )
        local numbeans = assert( quester:GetAttribute(PRIMARY_QUEST, "numbeans") )
        quester:SetAttribute(PRIMARY_QUEST, "numbeans", math.max(0, numbeans - 1))

        return true
    end
end


local MAX_COW_DIST = cfg("MAX_COW_DIST")
local MAX_COW_DIST_SQ = MAX_COW_DIST*MAX_COW_DIST

-- Under "normal usage", buyer is the shopkeeper and seller is the player.
--
-- Returns true if the negotiation was successful, and false/nil otherwise.
local function negotiateCows(buyer, seller)
    if not seller.components.leader or not seller.components.leader.followers then return false end

    local cows = Game.FindAllEntities(buyer, MAX_COW_DIST, is_a_cow)

    for _, cow in ipairs(cows) do
        if not canNegotiate(buyer, seller) then break end

        performTransaction(buyer, seller, cow)
    end

    if buyer.beans_to_give and buyer.beans_to_give > 0 then
        -- This is just to prevent Beefalos from hanging out mooing, distracting from the speech.
        for cow in pairs(seller.components.leader.followers) do
            if cow:IsValid() and cow.components.follower and is_a_cow(cow) then
                cow.components.follower:SetLeader(nil)
                if cow.brain and cow.brain.bt then
                    cow.brain.bt:Reset()
                end
            end
        end

        return true
    end
end

-------------------------------------------------------------------------------------------------

local function flagplayer(inst, player)
    -- For singleplayer compatibility.
    if player == nil then
        player = GetLocalPlayer()
    end

    local quester = player and player.components.quester

    if not quester or inst.components.speechgiver:IsSpeaking() then return end

    if not quester:StartedQuest(PRIMARY_QUEST) then
        inst.components.speechgiver:PlaySpeech("FLAG_PLAYER", player)
    elseif not quester:GetFlag(PRIMARY_QUEST, "gotbeans") and quester:GetAttribute(PRIMARY_QUEST, "numbeans") > 0 then
        inst.components.speechgiver:PlaySpeech("BEAN_REMINDER", player)
    elseif not quester:GetFlag(PRIMARY_QUEST, "gotbeans") then
        TheMod:DebugSay "I have nothing to give you!"
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
    local quester = doer.components.quester
    if not quester then return end

    quester:AddQuest(PRIMARY_QUEST)
    if not quester:HasAttribute(PRIMARY_QUEST, "numbeans") then
        quester:SetAttribute(PRIMARY_QUEST, "numbeans", cfg("NUMBEANS"))
    end

    local numbeans = quester:GetAttribute(PRIMARY_QUEST, "numbeans")
    local gavebeans = quester:GetFlag(PRIMARY_QUEST, "gotbeans")

    inst.components.speechgiver:CancelAll()

    if quester:GetFlag(PRIMARY_QUEST, "hitshopkeeper") then
        inst.components.speechgiver:PlaySpeech("ALL_IS_FORGIVEN", doer)
    end

    if not quester:StartedQuest(PRIMARY_QUEST) then
        inst.components.speechgiver:PushSpeech("BEAN_QUEST", doer)
        return true
    elseif numbeans > 0 and negotiateCows(inst, doer) then
        inst.components.speechgiver:PushSpeech("BEAN_SUCCESS", doer)
        inst.components.speechgiver:PushSpeech("BEAN_HINT", doer)
        if not (quester:GetFlag(PRIMARY_QUEST, "gotkettle") and quester:GetFlag(PRIMARY_QUEST, "gotlectern")) then
            inst.components.speechgiver:PushSpeech("GIVE_GIFTS", doer)
        end
        return true
    elseif numbeans > 0 and not gavebeans then
        inst.components.speechgiver:PushSpeech("BEAN_REMINDER", doer)
        inst.components.speechgiver:ForbidCutScenesInQueue()
        return true
    elseif gavebeans then
        inst.components.speechgiver:PushSpeech("BEAN_HINT", doer)
        inst.components.speechgiver:ForbidCutScenesInQueue()
        return true
    else
        TheMod:DebugSay "What else do you expect from me?"
    end
end

local function has_received_quest(player)
    local q = player.components.quester
    return q and q:StartedQuest(PRIMARY_QUEST)
end

local function has_given_quest(inst)
    --[[
    return Game.FindSomePlayer(has_received_quest) ~= nil
    ]]--
    return inst.gave_quest or false
end

local function try_despawn(inst)
    if not inst:IsValid() or inst:HasTag("permanent") then return end

    TheMod:DebugSay("Attempting to despawn [", inst, "]...")
    
    local sm = GetPseudoSeasonManager()
    if not has_given_quest(inst)
        and inst:IsAsleep()
        and not (sm and sm:IsRaining())
    then
        TheMod:DebugSay("Despawned [", inst, "].")
        inst:Remove()
        return
    end
    TheMod:DebugSay("Did not despawn [", inst, "].")
end

-------------------------------------------------------------------------------------------------

--This runs when the shopkeeper is awake.
local function start_proximity_task(inst)
    if inst.shop_proximity_task then return end

    local function should_alert(player)
        local quester = player.components.quester
        if quester and quester:StartedQuest(PRIMARY_QUEST) and not quester:GetFlag(PRIMARY_QUEST, "gotkettle") then
            if Game.FindSomeEntity(inst, MAX_COW_DIST, is_a_cow) then
                return true
            end
        end
    end

    inst.shop_proximity_task = inst:StartThread(function()
        while inst:IsValid() do
            if not inst.components.speechgiver:IsSpeaking() then
                local player = Game.FindSomePlayerInRange(inst, 9, should_alert)
                if player then
                    inst.components.speechgiver:PlaySpeech("COW_ALERT", player)
                end
            end

            Sleep(1)
        end

        inst.shop_proximity_task = nil
    end)
end

--This runs when the shopkeeper sleeps.
local function stop_proximity_task(inst)
    if inst.shop_proximity_task then
        _G.KillThread(inst.shop_proximity_task)
        inst.shop_proximity_task = nil
    end
end

-------------------------------------------------------------------------------------------------

--This handles the remembering.
local function onsave(inst, data)
    data.beans_to_give = inst.beans_to_give ~= 0 and inst.beans_to_give or nil
    data.gave_quest = inst.gave_quest or nil
    data.permanent = inst:HasTag("permanent") or nil
end

local function onload(inst, data)
    if not data then return end

    inst.beans_to_give = data.beans_to_give
    if inst.beans_to_give == 0 then
        inst.beans_to_give = nil
    end

    inst.gave_quest = data.gave_quest or false

    if data.permanent then
        inst:AddTag("permanent")
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
    
    MakeObstaclePhysics(inst, 1)

    inst:AddTag("shopkeeper")
    inst:AddTag("notarget")
    inst:AddTag("character")
    
    ------------------------------------------------------
    
    anim:SetBank("shop")
    anim:SetBuild("shop_basic")
    anim:PlayAnimation("idle", true)

    ------------------------------------------------------
 
    inst:AddComponent("talker")
    do
        local talker = inst.components.talker

        talker.fontsize = 35
        talker.font = TALKINGFONT
        --talker.offset = Vector3(0, 5, 0)
    end

    -- optimization stuff.
    inst:AddTag("_named")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:RemoveTag("_named")

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

        speechgiver:AddSpeechCallback("ALL_IS_FORGIVEN", function(inst, mgr)
            local quester = mgr.listener.components.quester
            if quester then
                quester:SetFlag(PRIMARY_QUEST, "hitshopkeeper", false)
            end
        end)

        speechgiver:AddSpeechCallback("BEAN_QUEST", function(inst, mgr)
            local quester = mgr.listener.components.quester
            if quester then
                quester:StartQuest(PRIMARY_QUEST)
                inst.gave_quest = true
            end
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
                if player.components.quester then
                    player.components.quester:SetFlag(PRIMARY_QUEST, "gotbeans", true)
                end
                inst.beans_to_give = nil
            end,
        })

        speechgiver:AddSpeechData("GIVE_GIFTS", {
            givekettle = function(inst, player)
                local quester = player.components.quester

                if not quester or quester:GetFlag(PRIMARY_QUEST, "gotkettle") or not player.components.inventory then return end
                quester:SetFlag(PRIMARY_QUEST, "gotkettle", true)

                local kettle = assert( SpawnPrefab("kettle_item"), "Failed to spawn kettle_item." )
                player.components.inventory:GiveItem(kettle)
            end,
            givelectern = function(inst, player)
                local quester = player.components.quester

                if not quester or quester:GetFlag(PRIMARY_QUEST, "gotlectern") or not player.components.inventory then return end
                quester:SetFlag(PRIMARY_QUEST, "gotlectern", true)

                local blueprint = assert( SpawnPrefab("research_lectern_blueprint"), "Failed to spawn research_lectern_blueprint." )
                player.components.inventory:GiveItem(blueprint)
            end,
        })

        speechgiver:AddSpeechData("LEVEL_ONE_BOSSES_SLAIN", {
            giveumbrella = function(inst, player)
                local quester = player.components.quester

                local umbrella = assert( SpawnPrefab("shopkeeper_umbrella"), "Failed to spawn kettle_item." )
                player.components.inventory:GiveItem(umbrella)
            end,
            giveportal = function(inst, player)
                local quester = player.components.quester

                --local portal = assert( SpawnPrefab("cloud_portal_blueprint"), "Failed to spawn research_lectern_blueprint." )
                --player.components.inventory:GiveItem(portal)
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
    inst:ListenForEvent("attacked", OnHit)
    inst:ListenForEvent("blocked", OnHit)
    
    inst:AddComponent("health")
    inst.components.health:SetInvincible(true)
    
    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("shopkeeper.tex")

    inst:ListenForEvent("rainstop", function() try_despawn(inst) end, GetWorld())
    inst:DoTaskInTime(0, function(inst)
        try_despawn(inst)
        if inst:IsValid() then
            inst:ListenForEvent("entitysleep", try_despawn)
        end
    end)

    inst:ListenForEvent("entitywake", start_proximity_task)
    inst:ListenForEvent("entitysleep", stop_proximity_task)

    return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets, prefabs)
