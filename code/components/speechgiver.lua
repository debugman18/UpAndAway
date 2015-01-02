local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"

local Game = wickerrequire "game"
local string = wickerrequire "utils.string"


local function new_speechmanager_queue()
    return {
        allows_cutscenes = true,
        user_allows_cutscenes = true,
    }
end

--[[
-- Pattern identifying a word.
--
-- It corresponds to a sequence of one of more letters or underscores.
--]]
local WORD_PATTERN = "[%a_]+"

local ANCHORED_WORD_PATTERN = "^"..WORD_PATTERN.."$"

local function is_word(str)
    return Pred.IsString(str) and str:find(ANCHORED_WORD_PATTERN)
end


local SpeechGiver = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "SpeechGiver")
    self:SetConfigurationKey("SPEECHGIVER")

    self.defaultvoice = "dontstarve/maxwell/talk_LP"

    -- Constant delay added to every speech line.
    self.constant_speech_delay = 0.75
    -- Number of words per second (ignoring the constant delay).
    self.words_per_second = 3.5

    self.speeches = {}
    self.wordmaps = {}

    self.oninteractfn = nil

    self.speechmanagers = new_speechmanager_queue()
    self.allows_cutscenes = true

    ---

    inst:ListenForEvent("speechgiver_interrupt", function(inst)
        local self = inst.components.speechgiver
        if self then
            self:Interrupt()
        end
    end)
end)
local IsSpeechGiver = Pred.IsInstanceOf(SpeechGiver)
local IsSpeechFn = Pred.IsCallable

------------------------------------------------------------------------

--[[
-- SpeechGiver configuration.
--]]

function SpeechGiver:GetDefaultVoice()
    return self.defaultvoice
end
SpeechGiver.GetDefaultSound = SpeechGiver.GetDefaultVoice

function SpeechGiver:SetDefaultVoice(sound)
    assert( Pred.IsString(sound), "String expected as sound parameter." )
    self.defaultvoice = sound
end
SpeechGiver.SetDefaultSound = SpeechGiver.SetDefaultVoice

function SpeechGiver:GetConstantSpeechDelay()
    return self.constant_speech_delay
end

function SpeechGiver:SetConstantSpeechDelay(dt)
    assert( Pred.IsNonNegativeNumber(dt), "Non-negative number expected as delay parameter." )
    self.constant_speech_delay = dt
end

function SpeechGiver:GetWordsPerSecond()
    return self.words_per_second
end

function SpeechGiver:SetWordsPerSecond(n)
    assert( Pred.IsPositiveNumber(n), "Positive number expected as number of words per second." )
    self.words_per_second = n
end

function SpeechGiver:GetSpeechData(name)
    return self.speeches[name]
end

function SpeechGiver:HasSpeech(name)
    local speech = self:GetSpeechData(name)
    return Pred.IsTable(speech) and IsSpeechFn(speech.fn)
end

local function get_speech_datatable(self, name)
    local data = self.speeches[name]
    if not data then
        data = { args = {} }
        self.speeches[name] = data
    end
    return data
end

function SpeechGiver:AddSpeechData(name, newdata)
    assert( Pred.IsString(name), "String expected as speech name." )

    local data = get_speech_datatable(self, name)

    if IsSpeechFn(newdata) then
        data.fn = newdata
    elseif Pred.IsTable(newdata) then
        local args = data.args
        for k, v in pairs(newdata) do
            args[k] = v
        end
    else
        error( "Function or table expected as speech data." )
    end
end

function SpeechGiver:AddSpeechCallback(name, cb)
    assert( Pred.IsCallable(cb), "Function expected as speech callback." )
    get_speech_datatable(self, name).onfinish = cb
end

function SpeechGiver:AddSpeechTable(t)
    assert( Pred.IsTable(t), "Table expected as speech table." )
    for k, v in pairs(t) do
        self:AddSpeechData(k, v)
    end
end

function SpeechGiver:ClearSpeeches()
    self:ClearQueue()
    self.speeches = {}
end

function SpeechGiver:AddWordMap(original, translation)
    assert( is_word(original), "Word expected as word to be mapped." )
    assert( Pred.IsString(translation) or Pred.IsCallable(translation), "String or function expected as word to be mapped to." )
    self.wordmaps[original:lower()] = translation
end

function SpeechGiver:AddWordMapTable(t)
    assert( Pred.IsTable(t), "Table expected as word map table." )
    for k, v in pairs(t) do
        self:AddWordMap(k, v)
    end
end

local function default_oninteractfn(inst, doer)
    local self = inst.components.speechgiver
    if self and self:HasSpeech("NULL_SPEECH") then
        self:PlaySpeech("NULL_SPEECH", doer)
        return true
    end
end

function SpeechGiver:GetOnInteractFn()
    return self.oninteractfn or default_oninteractfn
end

function SpeechGiver:SetOnInteractFn(fn)
    assert( fn == nil or Pred.IsCallable(fn), "Function expected as oninteract handler." )
    self.oninteractfn = fn
end


function SpeechGiver:ForbidCutScenes()
    self.allows_cutscenes = false
end
SpeechGiver.ForbidCutscenes = SpeechGiver.ForbidCutScenes

function SpeechGiver:ForbidCutScenesInQueue()
    self.speechmanagers.allows_cutscenes = false
end
SpeechGiver.ForbidCutscenesInQueue = SpeechGiver.ForbidCutScenesInQueue

---

local function speechgiver_setiscutscene(self, b)
    replica(self.inst).speechgiver:SetIsCutScene(b)
end

local function speechgiver_setwantscutscene(self, b)
    replica(self.inst).speechgiver:SetWantsCutScene(b)
end

function SpeechGiver:MakeInterruptible()
    replica(self.inst).speechgiver:MakeInterruptible()
end

function SpeechGiver:MakeNonInterruptible()
    replica(self.inst).speechgiver:MakeNonInterruptible()
end

-- Resets any state change which may have been caused by the last running
-- speech.
function SpeechGiver:ResetSpeechState()
    self:MakeInterruptible()
    speechgiver_setiscutscene(self, false)
    speechgiver_setwantscutscene(self, false)
end

------------------------------------------------------------------------

--[[
-- SpeechGiver state query and manipulation.
--]]

function SpeechGiver:AllowsCutScenes()
    return self.allows_cutscenes and self.speechmanagers.allows_cutscenes and self.speechmanagers.user_allows_cutscenes
end
SpeechGiver.AllowsCutscenes = SpeechGiver.AllowsCutScenes

function SpeechGiver:IsSpeaking()
    return self.speechmanagers[1] and self.speechmanagers[1]:IsRunning()
end
SpeechGiver.IsTalking = SpeechGiver.IsSpeaking

------------------------------------------------------------------------

--[[
-- Utility functions related to SpeechGiver.
--]]

local function speechgiver_internal_mapword(self, word, listener)
    local word_lc = word:lower()

    local mapped = self.wordmaps[word_lc]
    if not mapped then return end

    if Pred.IsCallable(mapped) then
        mapped = mapped(listener, self.inst)
        if not mapped then
            return
        elseif not Pred.IsString(mapped) then
            return error("String expected as result of mapping function for '"..word.."'.")
        end
    end

    if word:find("%l") then
        if word:find("%u") then
            return string.capitalize(mapped)
        else
            return mapped:lower()
        end
    else
        return mapped:upper()
    end
end

function SpeechGiver:MapWord(word, listener)
    assert( Pred.IsString(word), "String expected as word to be mapped." )
    assert( Pred.IsEntityScript(listener), "Entity expected as listener argument." )

    return speechgiver_internal_mapword(self, word, listener) or word
end

function SpeechGiver:MapText(txt, listener)
    assert( Pred.IsString(txt), "String expected as text to be mapped." )
    assert( Pred.IsEntityScript(listener), "Entity expected as listener argument." )
    return txt:gsub(WORD_PATTERN, function(word)
        return speechgiver_internal_mapword(self, word, listener)
    end)
end

local function speechgiver_count_words(str)
    local n = 0
    for _ in str:gmatch("%S+") do
        n = n + 1
    end
    return n
end

local function speechgiver_compute_speech_duration(self, str, modifier)
    return self:GetConstantSpeechDelay() + (speechgiver_count_words(str)*modifier)/self:GetWordsPerSecond()
end

local function speechgiver_onfinishspeech(self)
    if not self.inst:IsValid() then return end

    if self.speechmanagers[1] then
        table.remove(self.speechmanagers, 1)
    end
    if not self.speechmanagers[1] then
        self:ClearQueue()
    else
        self.speechmanagers[1]:Start()
    end
end

------------------------------------------------------------------------

--[[
-- SpeechManager class.
--]]

---
-- An object of this class is passed as the first parameter to speeches.
local SpeechManager = HostClass(Debuggable, function(self, speechgiver, speechname, speech, listener)
    assert( IsSpeechGiver(speechgiver), "SpeechGiver object expected." )
    assert( Pred.IsString(speechname), "String expected as speech name." )
    assert( Pred.IsTable(speech), "Table expected as speech data." )
    assert( IsSpeechFn(speech.fn), "Function expected as speechfn." )
    assert( Pred.IsEntityScript(listener), "Entity expected as listener." )
    assert( listener.components.speechlistener, "SpeechListener component expected in listener." )

    Debuggable._ctor(self, self, false)
    self:SetConfigurationKey("SPEECHMANAGER")

    self.inst = speechgiver.inst

    self.speechgiver = speechgiver
    self.speechname = speechname
    self.speech = speech
    self.speaker = self.inst
    self.listener = listener

    self.speed = 1
    self.voice = nil

    self.inputhandlers = nil

    self.interruptible = true
    self.wants_cutscene = false
    self.is_cutscene = false
    self.thread = nil

    self.last_camera_heading = nil
end)
local IsSpeechManager = Pred.IsInstanceOf(SpeechManager)

function SpeechManager:__tostring()
    return ("SpeechManager([%s] saying %s to [%s])"):format(tostring(self.speaker), self.speechname, tostring(self.listener))
end

function SpeechManager:GetSpeechName()
    return self.speechname
end

function SpeechManager:IsInterruptible()
    return self.interruptible
end

function SpeechManager:WantsCutScene()
    return self.wants_cutscene
end

function SpeechManager:IsCutScene()
    return self.is_cutscene
end
SpeechManager.IsCutscene = SpeechManager.IsCutScene

function SpeechManager:SetWantsCutScene(b)
    self.wants_cutscene = b
    speechgiver_setwantscutscene(self.speechgiver, b)
end
SpeechManager.SetWantsCutscene = SpeechManager.SetWantsCutScene

function SpeechManager:SetIsCutScene(b)
    self.is_cutscene = b
    speechgiver_setiscutscene(self.speechgiver, b)
end
SpeechManager.SetIsCutscene = SpeechManager.SetIsCutScene

local function disable_listener(self)
    local sl = self.listener.components.speechlistener
    if sl then
        sl:DisableEntity()
    end
end

local function clear_input_handlers(self)
    local sl = self.listener.components.speechlistener
    if sl then
        sl:ClearInputHandlers()
    end
end

local function enable_listener(self)
    local sl = self.listener.components.speechlistener
    if sl then
        sl:EnableEntity()
    end
end

local function setup_input_handlers(self)
    local sl = self.listener.components.speechlistener
    if sl then
        sl:SetupInputHandlers()
    end
end

function SpeechManager:IsRunning()
    return self.thread ~= nil
end

function SpeechManager:Silence()
    self:DebugSay("Silence()")
    self:ShutUp()
    self:KillSound()
    if self.listener then
        Game.ShowPlayerHUD(self.listener, true)
    end
end

local function speechmanager_onstartspeech(self)
    if not self.inst:IsValid() then return end

    self:DebugSay("Starting speech.")

    if self.listener:IsValid() then
        self.inst:FacePoint(self.listener.Transform:GetWorldPosition())
        self.listener:FacePoint(self.inst.Transform:GetWorldPosition())

        local sname = self:GetSpeechName()
        self.inst:PushEvent("startedspeaking", {speech = sname, listener = self.listener})
        self.listener:PushEvent("startedlistening", {speech = sname, speaker = self.inst})
    end
end

local function speechmanager_onfinishspeech(self, instant)
    self:ExitCutscene()

    self:DebugSay("Finishing speech.")

    enable_listener(self)

    if not self.inst:IsValid() then return end

    if not instant and self.listener:IsValid() then
        self.listener:DoTaskInTime(0.15, function()
            if not self.speechgiver:IsSpeaking() then
                self:Silence()
            end
        end)
    else
        self:Silence()
    end

    do
        local sname = self:GetSpeechName()
        if self.inst:IsValid() then
            self.inst:PushEvent("finishedspeaking", {speech = sname, listener = self.listener})
        end
        if self.listener:IsValid() then
            self.listener:PushEvent("finishedlistening", {speech = sname, speaker = self.inst})
        end
    end

    speechgiver_onfinishspeech(self.speechgiver)
end

function SpeechManager:Start()
    if self:IsRunning() then return end

    if not self.listener:IsValid() or not self.listener.components.speechlistener then
        self:Cancel()
        return
    end

    self.listener.components.speechlistener:SetSpeaker(self.speaker)

    self.speaker.components.speechgiver:ResetSpeechState()

    if self:IsInterruptible() then
        self.speaker.components.speechgiver:MakeInterruptible()
    else
        self.speaker.components.speechgiver:MakeNonInterruptible()
    end

    self.thread = self.inst:StartThread(function()
        if not self.listener:IsValid() then return end

        speechmanager_onstartspeech(self)
        self.speech.fn(self, self.speech.args)
        speechmanager_onfinishspeech(self)

        if self.speech.onfinish then
            self.speech.onfinish(self.inst, self)
        end

        self.thread = nil
    end)
end

function SpeechManager:Cancel()
    if not self:IsRunning() then return end

    self:DebugSay("Cancel()")

    CancelThread(self.thread)
    self.thread = nil

    speechmanager_onfinishspeech(self, true)
end

function SpeechManager:Interrupt()
    if not self:IsInterruptible() then return end

    self:DebugSay("Interrupt()")

    self.speechgiver.speechmanagers.user_allows_cutscenes = false

    self:AbortCutScene()
end

function SpeechManager:PlayVoice()
    if self.inst.SoundEmitter and not self.inst.SoundEmitter:PlayingSound("speechvoice") then
        self.inst.SoundEmitter:PlaySound(self:GetVoice(), "speechvoice")
    end
end

function SpeechManager:KillVoice()
    if self.inst.SoundEmitter then
        self.inst.SoundEmitter:KillSound("speechvoice")
    end
end

------------------------------------------------------------------------

--[[
-- Methods of SpeechManager meant to be used from within a speech.
--
-- @README@
--]]


--[[
-- The following are configuration methods meant to be used primarily from
-- within a speech.
--]]

function SpeechManager:GetVoice()
    return self.voice or self.speechgiver:GetDefaultVoice()
end

--[[
-- Sets the voice for the current speech.
--
-- The default voice for all speeches given by the entity should be set in
-- the SpeechGiver component, not here.
--]]
function SpeechManager:SetVoice(s)
    assert( Pred.IsString(s), "String expected as voice parameter." )
    self.voice = s
end

function SpeechManager:GetSpeed()
    return self.speed
end

--[[
-- Speed of text flow. A speed of 1 means the default speed of the SpeechGiver component.
--]]
function SpeechManager:SetSpeed(s)
    assert( Pred.IsPositiveNumber(s), "Positive number expected as speed parameter." )
    self.speed = s
end

function SpeechManager:MakeInterruptible()
    self:DebugSay("MakeInterruptible()")
    self.interruptible = true
    self.speaker.components.speechgiver:MakeInterruptible()
    setup_input_handlers(self)
end

function SpeechManager:MakeNonInterruptible()
    self:DebugSay("MakeNonInterruptible()")
    self.interruptible = false
    self.speaker.components.speechgiver:MakeNonInterruptible()
    clear_input_handlers(self)
end
SpeechManager.MakeUninterruptible = SpeechManager.MakeNonInterruptible


--[[
-- The following are methods with active effects, most of which may ONLY be
-- used from within a speech (since they assume they are run in a dedicated
-- thread).
--]]

-- May be called outside of a speech.
function SpeechManager:PlaySound(s)
    self:KillSound()
    if self.inst.SoundEmitter then
        self.inst.SoundEmitter:PlaySound(s, "speechsound")
    end
end

-- May be called outside of a speech.
function SpeechManager:KillSound()
    if self.inst.SoundEmitter then
        self.inst.SoundEmitter:KillSound("speechsound")
    end
end

-- Must NOT be called outside of a speech.
function SpeechManager:Say(line)
    if not (self.inst:IsValid() and self.listener:IsValid()) then return end

    assert( Pred.IsNumber(line) or Pred.IsWordable(line), "String expected as line to be played." )

    line = tostring(line)

    if self:Debug() then
        self:Say("Saying line \"", line:sub(1, 12), "...\".")
    end

    line = self.speechgiver:MapText(line, self.listener)

    self:PlayVoice()

    local total_delay = speechgiver_compute_speech_duration(self.speechgiver, line, self:GetSpeed())

    if self.inst.components.talker then
        self.inst.components.talker:Say(line, total_delay)
    end

    Sleep(total_delay)

    Sleep(0.5)
end
SpeechManager.__call = SpeechManager.Say

-- May be called outside of a speech.
function SpeechManager:ShutUp()
    if self.inst.components.talker then
        self.inst.components.talker:ShutUp()
    end
    self:KillVoice()
end

-- May be called outside of a speech.
function SpeechManager:PlayAnimation(anim, ...)
    if self.inst.AnimState then
        self.inst.AnimState:PlayAnimation(anim, ...)
    end
end

-- May be called outside of a speech.
function SpeechManager:PushAnimation(anim, ...)
    if self.inst.AnimState then
        self.inst.AnimState:PushAnimation(anim, ...)
    end
end

-- Must NOT be called outside of a speech.
function SpeechManager:WaitForEvent(eventname, src)
    local thread = self.thread

    if not thread then return end

    Game.ListenForEventOnce(self.inst, eventname, function()
        self:DebugSay("Got event \"", eventname, "\" from [", src, "].")
        _G.WakeTask(thread)
    end, src)

    self:DebugSay("Waiting for event \"", eventname, "\" from [", src, "]...")
    _G.Hibernate()
end

-- Must NOT be called outside of a speech.
function SpeechManager:WaitForAnimation(src)
    src = src or self.inst
    if src.AnimState then
        self:WaitForEvent("animover", src)
    end
end

-- Must NOT be called outside of a speech.
function SpeechManager:WaitForAnimationQueue(src)
    src = src or self.inst
    if src.AnimState then
        self:WaitForEvent("animqueueover", src)
    end
end

-- May be called outside of a speech.
function SpeechManager:EnterCutScene()
    if not self.listener.components.speechlistener then return end

    self:SetWantsCutScene(true)

    if self:IsCutScene() then return true end

    self:DebugSay("EnterCutScene()")

    if not self.speechgiver:AllowsCutScenes() then
        self:DebugSay("Cut scenes not allowed by the SpeechGiver.")
        return
    end

    self:SetIsCutScene(true)

    setup_input_handlers(self)

    self.listener.components.speechlistener:EnterCutScene()

    return true
end
SpeechManager.EnterCutscene = SpeechManager.EnterCutScene

-- May be called outside of a speech.
function SpeechManager:AbortCutScene()
    if not self:IsCutScene() or not self.listener:HasTag("player") then return true end

    self:DebugSay("AbortCutScene()")

    if self.listener:IsValid() then
        self.listener:DoTaskInTime(_G.FRAMES, function() self:SetIsCutScene(false) end)
    end

    enable_listener(self)

    if self.listener.components.speechlistener then
        self.listener:DoTaskInTime(2*_G.FRAMES, function(listener)
            local sl = listener.components.speechlistener
            if sl then
                sl:AbortCutScene()
            end
        end)
    end

    return true
end
SpeechManager.AbortCutscene = SpeechManager.AbortCutScene

-- May be called outside of a speech.
function SpeechManager:ExitCutScene()
    self:SetWantsCutScene(false)
    return self:AbortCutScene()
end
SpeechManager.ExitCutscene = SpeechManager.ExitCutScene

------------------------------------------------------------------------

--[[
-- Methods of SpeechGiver controlling the flow of speech.
--]]


local function speechgiver_pushspeechmanager(self, mgr)
    self:DebugSay("Pushing speech ", mgr.speechname, " to be heard by [", mgr.listener, "].")
    table.insert(self.speechmanagers, mgr)
    if not self.speechmanagers[1]:IsRunning() then
        self.speechmanagers[1]:Silence()
        self.speechmanagers[1]:Start()
    end
end	

function SpeechGiver:PushSpeech(speechname, listener)
    assert( Pred.IsEntityScript(listener), "Entity expected as listener argument." )

    if not self:HasSpeech(speechname) then
        return error("Invalid speech '"..tostring(speechname).."'", 2)
    end

    local speech = self:GetSpeechData(speechname)
    
    speechgiver_pushspeechmanager( self, SpeechManager(self, speechname, speech, listener) )
end

function SpeechGiver:PlaySpeech(speechname, listener)
    self:ClearQueue()
    self:PushSpeech(speechname, listener)
end

function SpeechGiver:Cancel()
    if self.speechmanagers[1] then
        self.speechmanagers[1]:Cancel()
    end
end

function SpeechGiver:ClearQueue()
    self:DebugSay("ClearQueue()")
    local num_mgrs = #self.speechmanagers
    while num_mgrs > 0 do
        self.speechmanagers[1]:Cancel()
        assert( #self.speechmanagers == num_mgrs - 1 )
        num_mgrs = num_mgrs - 1
    end
    self.speechmanagers = new_speechmanager_queue()
    self:ResetSpeechState()
end
SpeechGiver.CancelAll = SpeechGiver.ClearQueue

function SpeechGiver:Interrupt()
    if self.speechmanagers[1] then
        self.speechmanagers[1]:Interrupt()
    end
end

function SpeechGiver:IsInCutScene()
    return replica(self.inst).speechgiver:IsInCutScene()
end
SpeechGiver.IsInCutscene = SpeechGiver.IsInCutScene

function SpeechGiver:CanInteractWith(someone)
    return replica(self.inst).speechgiver:CanInteractWith(someone)
end

function SpeechGiver:InteractWith(someone)
    if self:CanInteractWith(someone) then
        self:DebugSay("Interacting with [", someone, "].")

        self.speechmanagers.user_allows_cutscenes = true
        
        if self:IsSpeaking() and self.speechmanagers[1]:WantsCutScene() then
            if self.speechmanagers[1]:EnterCutScene() then
                return true
            end
        end

        return self:GetOnInteractFn()(self.inst, someone)
    elseif self:IsInCutScene() then
        return true
    end
    TheMod:Say "SpeechGiver:InteractWith failed..."
end

------------------------------------------------------------------------

--[[
-- Saving, loading and related functions. (and miscellanea)
--]]

function SpeechManager:Save(refs)
    table.insert(refs, self.listener.GUID)
    return {
        speechname = self.speechname,
        listener = self.listener.GUID,
    }
end

-- Not a method, but a class function.
function SpeechManager.LoadFrom(speechgiver, data, newents)
    local speechname = data.speechname
    if not speechname then return end

    local listener = newents[data.listener]
    listener = listener and listener.entity
    if not listener then return end

    local speech = speechgiver:GetSpeechData(speechname)
    if not speech then return end

    return SpeechManager(speechgiver, speechname, speech, listener)
end

-------

function SpeechGiver:OnSave()
    if self:IsSpeaking() then
        self:DebugSay("Saving ", #self.speechmanagers, " speeches on queue.")

        local data = {meta = {}}
        local refs = {}

        for k, v in pairs(self.speechmanagers) do
            if IsSpeechManager(v) and v.listener:IsValid() then
                table.insert(data, v:Save(refs))
            else
                data.meta[k] = v
            end
        end

        return data, refs
    end
end

function SpeechGiver:LoadPostPass(newents, data)
    if not data then return end

    self:ClearQueue()

    self:DebugSay("Loading ", #data, " speeches from savedata.")

    if data.meta then
        for k, v in pairs(data.meta) do
            self.speechmanagers[k] = v
        end
    end

    self.inst:DoTaskInTime(0, function()
        if not (self.inst:IsValid() and self.inst.components.speechgiver) then
            return
        end

        for _, mgrdata in ipairs(data) do
            local mgr = SpeechManager.LoadFrom(self, mgrdata, newents)
            if mgr then
                speechgiver_pushspeechmanager(self, mgr)
            end
        end

        if not self.speechmanagers[1] then
            self:ClearQueue()
        end
    end)
end

function SpeechGiver:OnRemoveEntity()
    self:DebugSay("OnRemoveEntity()")
    self:ClearQueue()
end

function SpeechGiver:OnRemoveFromEntity()
    self:DebugSay("OnRemoveFromEntity()")
    self:ClearQueue()
end

function SpeechGiver:OnEntitySleep()
    self:DebugSay("OnEntitySleep()")
    self:ClearQueue()
end

function SpeechGiver:CollectSceneActions(doer, actions)
    if self:CanInteractWith(doer) and not (doer.sg and doer.sg:HasStateTag("moving")) then
        table.insert(actions, _G.ACTIONS.BEGINSPEECH)
    end
end

------------------------------------------------------------------------

return SpeechGiver
