local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"

local Configurable = wickerrequire "adjectives.configurable"
local Debuggable = wickerrequire "adjectives.debuggable"


local SpeechGiver = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self)

	self.defaultvoice = "dontstarve/maxwell/talk_LP"

	-- Constant delay added to every speech.
	self.constant_speech_delay = 0.5
	-- Number of words per second (ignoring the constant delay).
	self.words_per_second = 2

	self.speeches = {}

	self.current_speechmanager = nil
end)
local IsSpeechGiver = Pred.IsInstanceOf(SpeechGiver)
local IsSpeech = Pred.IsCallable

------------------------------------------------------------------------

--[[
-- SpeechGiver configuration.
--]]

function SpeechGiver:GetDefaultVoice()
	return self.defaultvoice
end
SpeechGiver.GetDefaultSound = SpeechGiver.GetDefaultVoice

function SpeechGiver:SetDefaultVoice(sound)
	assert( Pred.IsString(sound), "Strings expected as sound parameter." )
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

function SpeechGiver:GetSpeech(name)
	return self.speeches[name]
end

function SpeechGiver:AddSpeech(name, speech)
	assert( Pred.IsString(name), "String expected as speech name." )
	assert( IsSpeech(speech), "Function expected as speech." )
	self.speeches[name] = speech
end

function SpeechGiver:AddSpeechTable(t)
	assert( Pred.IsTable(t), "Table expected as speech table." )
	for k, v in pairs(t) do
		self:AddSpeech(k, v)
	end
end

function SpeechGiver:ClearSpeeches()
	self.speeches = {}
end

------------------------------------------------------------------------

--[[
-- Utility functions related to SpeechGiver.
--]]

local function speechgiver_count_words(str)
	local n = 0
	for _ in str:gmatch("%S+") do
		n = n + 1
	end
	return n
end

local function speechgiver_compute_duration(self, str, modifier)
	return self.constant_speech_delay + speechgiver_count_words(str)*modifier/self.words_per_second
end

local function speechgiver_onfinishspeech(self)
	self.current_speechmanager = nil
end

------------------------------------------------------------------------

--[[
-- SpeechManager class.
--]]

---
-- An object of this class is passed as the first parameter to speeches.
local SpeechManager = Class(Configurable, function(self, speechgiver, speechname, speech, listener)
	assert( IsSpeechGiver(speechgiver) )
	assert( Pred.IsString(speechname) )
	assert( IsSpeech(speech) )
	assert( Pred.IsEntityScript(listener) )

	Configurable._ctor(self)

	self.speechgiver = speechgiver
	self.speechname = speechname
	self.speech = speech
	self.inst = speechgiver.inst
	self.listener = self.listener

	self.speed = 1

	self.inputhandlers = nil

	self.interruptible = true
	self.is_cutscene = false
	self.thread = nil
end)
local IsSpeechManager = Pred.IsInstanceOf(SpeechManager)


local function disable_listener(self)
	local li = self.listener
	if not li:IsValid() then return end

	if li.components.playercontroller then
		li.components.playercontroller:Enable(false)
	end

	if li.brain and not li.brain.stopped then
		li.brain:Stop()
	end

	if li.components.health then
		li.components.health:SetInvincible(true)
	end
end

local function clear_input_handlers(self)
	if not self.inputhandlers then return end

	for _, h in ipairs(self.inputhandlers) do
		h:Remove()
	end

	self.inputhandlers = nil
end

local function enable_listener(self)
	clear_input_handlers(self)

	local li = self.listener
	if not li:IsValid() then return end

	if li.components.playercontroller then
		li.components.playercontroller:Enable(true)
	end

	if li.brain and li.brain.stopped then
		li.brain:Start()
	end

	if li.components.health then
		li.components.health:SetInvincible(false)
	end
end


local function setup_input_handlers(self)
	disable_listener(self)
	if not self.interruptible or self.inputhandlers or not self.listener:HasTag("player") then return end

	local TheInput = _G.TheInput

	local function cb()
		self:Interrupt()
	end

	self.inputhandlers = {
		TheInput:AddControlHandler(_G.CONTROL_PRIMARY, cb),
		TheInput:AddControlHandler(_G.CONTROL_SECONDARY, cb),
		TheInput:AddControlHandler(_G.CONTROL_ATTACK, cb),
		TheInput:AddControlHandler(_G.CONTROL_INSPECT, cb),
		TheInput:AddControlHandler(_G.CONTROL_ACTION, cb),
		TheInput:AddControlHandler(_G.CONTROL_CONTROLLER_ACTION, cb),
	}
end


function SpeechManager:GetSpeed()
	return self.speed
end

function SpeechManager:SetSpeed(s)
	assert( Pred.IsPositiveNumber(s), "Positive number expected as speed parameter." )
	self.speed = s
end

function SpeechManager:GetSpeechName()
	return self.speechname
end

function SpeechManager:IsInterruptible()
	return self.interruptible
end

function SpeechManager:MakeInterruptible()
	self.interruptible = true
	setup_input_handlers(self)
end

function SpeechManager:MakeNonInterruptible()
	self.interruptible = false
	clear_input_handlers(self)
end
SpeechManager.MakeUninterruptible = SpeechManager.MakeNonInterruptible


function SpeechManager:IsRunning()
	return self.thread ~= nil
end

function SpeechManager:IsCutScene()
	return self.is_cutscene
end
SpeechManager.IsCutscene = SpeechManager.IsCutScene


local function speechmanager_onstartspeech(self)
	if self:IsInterruptible() then
		setup_input_handlers(self)
	end

	self.inst:FacePoint(self.listener.Transform:GetWorldPosition())
	self.listener:FacePoint(self.inst.Transform:GetWorldPosition())

	local sname = self:GetSpeechName()
	self.inst:PushEvent("startedspeaking", {speech = sname})
	self.listener:PushEvent("startedlistening", {speech = sname})
end

local function speechmanager_onfinishspeech(self)
	enable_listener(self)

	if self.inst.components.talker then
		self.inst.components.talker:ShutUp()
	end
	if self.inst.SoundEmitter then
		self.inst.SoundEmitter:KillSound("speechgiving")
	end

	local sname = self:GetSpeechName()
	self.inst:PushEvent("finishedspeaking", {speech = sname})
	self.listener:PushEvent("finishedlistening", {speech = sname})

	speechgiver_onfinishspeech(self.speechgiver)
end

function SpeechManager:Start()
	if self:IsRunning() then return end

	self.thread = self.inst:StartThread(function()
		speechmanager_onstartspeech(self)
		self.speech(self, self.listener)
		speechmanager_onfinishspeech(self)
	end)
end

function SpeechManager:Cancel()
	if not self:IsRunning() then return end

	_G.KillThread(self.thread)
	self.thread = nil

	speechmanager_onfinishspeech(self)
end

function SpeechManager:EnterCutScene()

end
SpeechManager.EnterCutscene = SpeechManager.EnterCutScene

function SpeechManager:Interrupt()

end
SpeechManager.ExitCutScene = SpeechManager.Interrupt
SpeechManager.ExitCutscene = SpeechManager.Interrupt

------------------------------------------------------------------------

--[[
-- Methods of SpeechGiver that actually do stuff.
--]]

function SpeechGiver:IsSpeaking()
	return self.current_speechmanager and self.current_speechmanager:IsRunning()
end

function SpeechGiver:SpeakTo(inst, speechname)
	self:Cancel()

	local speech = self:GetSpeech(speechname)
	if not speech then
		return error("Invalid speech '"..tostring(speechname).."'", 2)
	end

	self.current_speechmanager = SpeechManager(self, speechname, speech, inst)
	self.current_speechmanager:Start()
end

function SpeechGiver:Cancel()
	if self.current_speechmanager then
		self.current_speechmanager:Cancel()
	end
end

function SpeechGiver:Interrupt()
	if self.current_speechmanager then
		self.current_speechmanager:Interrupt()
	end
end

------------------------------------------------------------------------

function SpeechGiver:OnSave()
	if self:IsSpeaking() and self.current_speechmanager.listener:IsValid() then
		return {
			speechname = self.current_speechmanager.speechname,
			listener = self.current_speechmanager.listener.GUID,
		}, {
			self.current_speechmanager.listener.GUID,
		}
	end
end

function SpeechGiver:LoadPostPass(newents, data)
	if not data then return end

	local speechname = data.speechname
	if not speechname then return end

	local listener = newents[data.listener]
	if not listener then return end

	if not self:GetSpeech(speechname) then return end

	self:SpeakTo(listener, speechname)
end

return SpeechGiver
