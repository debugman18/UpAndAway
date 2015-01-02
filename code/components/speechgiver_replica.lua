local SpeechGiver = Class(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "SpeechGiverReplica")
    self:SetConfigurationKey("SPEECHGIVER")

    self.net_interruptible = NetBool(inst, "speechgiver.interruptible")
    self.net_interruptible.value = true

    self.net_cutscene = NetBool(inst, "speechgiver.cutscene")
    self.net_cutscene.value = false

    self.net_wants_cutscene = NetBool(inst, "speechgiver.wants_cutscene")
    self.net_wants_cutscene.value = false

    RegisterServerEvent(inst, "speechgiver_interrupt")
end)

---

function SpeechGiver:IsInterruptible()
    return self.net_interruptible.value
end

function SpeechGiver:MakeInterruptible()
    self.net_interruptible.value = true
end

function SpeechGiver:MakeNonInterruptible()
    self.net_interruptible.value = false
end

function SpeechGiver:Interrupt()
    if self:IsInterruptible() then
        ServerRPC.PushServerEvent(self.inst, "speechgiver_interrupt")
    end
end

---

function SpeechGiver:IsInCutScene()
    return self.net_cutscene.value
end
SpeechGiver.IsInCutscene = SpeechGiver.IsInCutScene
SpeechGiver.IsCutScene = SpeechGiver.IsInCutScene
SpeechGiver.IsCutscene = SpeechGiver.IsInCutScene

function SpeechGiver:WantsCutScene()
    return self.net_wants_cutscene.value
end
SpeechGiver.WantsCutscene = SpeechGiver.WantsCutScene

function SpeechGiver:SetIsCutScene(b)
    self.net_cutscene.value = (b and true or false)
end

function SpeechGiver:SetWantsCutScene(b)
    self.net_wants_cutscene.value = b and true or false
end

---

function SpeechGiver:CanInteractWith(someone)
    return self.inst:IsValid()
        and someone and someone:IsValid()
        and replica(someone).speechlistener
        and not self:IsInCutScene()
        and self:IsInterruptible()
end

---

return SpeechGiver
