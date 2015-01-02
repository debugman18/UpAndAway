local SpeechListener = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "SpeechListener")
    self:SetConfigurationKey("SPEECHLISTENER")
end)

function SpeechListener:SetSpeaker(speaker)
    return replica(self.inst).speechlistener:SetSpeaker(speaker)
end

---

-- This just eventually redirects to the speechgiver interrupt.
function SpeechListener:Interrupt()
    return replica(self.inst).speechlistener:Interrupt()
end

function SpeechListener:SetupInputHandlers()
    self:DisableEntity()
    return replica(self.inst).speechlistener:SetupInputHandlers()
end

function SpeechListener:ClearInputHandlers()
    return replica(self.inst).speechlistener:ClearInputHandlers()
end

---

function SpeechListener:EnterCutScene()
    return replica(self.inst).speechlistener:EnterCutScene()
end
SpeechListener.EnterCutscene = SpeechListener.EnterCutScene

function SpeechListener:AbortCutScene()
    return replica(self.inst).speechlistener:AbortCutScene()
end
SpeechListener.AbortCutscene = SpeechListener.AbortCutScene

---

function SpeechListener:DisableEntity()
    local inst = self.inst
    if not inst:IsValid() then return end

    self:DebugSay("Disabling [", inst, "].")

    if inst.components.playercontroller then
        inst.components.playercontroller:Enable(false)
    end

    if inst.brain and not inst.brain.stopped then
        inst.brain:Stop()
    end

    if inst.components.health then
        inst.components.health:SetInvincible(true)
    end
end

function SpeechListener:EnableEntity()
    local inst = self.inst

    self:ClearInputHandlers()

    if not inst:IsValid() then return end

    self:DebugSay("Enabling [", inst, "] listener.")

    if inst.components.playercontroller then
        inst.components.playercontroller:Enable(true)
    end

    if inst.brain and inst.brain.stopped then
        inst.brain:Start()
    end

    if inst.components.health then
        inst.components.health:SetInvincible(false)
    end
end

---

return SpeechListener
