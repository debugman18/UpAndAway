local manageInputHandlers
local doClearInputHandlers
local doSetupInputHandlers

local doEnterCutScene
local doAbortCutScene

local CAMERA_SLOW_GAINS = {
    -- pan
    3,
    -- heading
    7,
    -- distance
    1,
}

local SpeechListener = Class(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "SpeechListenerReplica")
    self:SetConfigurationKey("SPEECHLISTENER")

    self.inputhandlers = nil

    self.speechgiver = NetEntity(inst, "speechlistener.speaker")

    self.net_input_handlers_enabled = NetBool(inst, "speechlistener.input_handlers")
    self.net_input_handlers_enabled.value = false

    self.net_enter_cutscene = NetSignal(inst, "speechlistener.enter_cutscene")
    self.net_abort_cutscene = NetSignal(inst, "speechlistener.abort_cutscene")

    self.last_camera_heading = nil

    self.is_authority = false

    if inst:HasTag("player") then
        TheMod:AddLocalPlayerPostActivation(function()
            local is_authority = (inst == GetLocalPlayer())
            self.is_authority = is_authority

            if is_authority then
                self.net_input_handlers_enabled:AddOnDirtyFn(manageInputHandlers)

                self.net_enter_cutscene:Connect(doEnterCutScene)
                self.net_abort_cutscene:Connect(doAbortCutScene)
            end
        end)
    end
end)

function SpeechListener:IsAuthority()
    return self.is_authority
end

function SpeechListener:GetSpeaker()
    return self.speechgiver.value
end

function SpeechListener:SetSpeaker(speaker)
    self.speechgiver.value = speaker
end

---

function SpeechListener:Interrupt()
    local speaker = self:GetSpeaker()
    local speechgiver = speaker and replica(speaker).speechgiver
    if speechgiver then
        speechgiver:Interrupt()
    end
end

---

function SpeechListener:ClearInputHandlers()
    self.net_input_handlers_enabled.value = false
end

function SpeechListener:SetupInputHandlers()
    self.net_input_handlers_enabled.value = true
end

---

function SpeechListener:EnterCutScene()
    self.net_enter_cutscene()
end

function SpeechListener:AbortCutScene()
    self.net_abort_cutscene()
end

---

doClearInputHandlers = function(inst)
    local self = replica(inst).speechlistener
    if not self then return end

    if not self.inputhandlers then return end

    self:DebugSay("Clearing input handlers.")

    for _, h in ipairs(self.inputhandlers) do
        h:Remove()
    end

    self.inputhandlers = nil
end

doSetupInputHandlers = function(inst)
    local self = replica(inst).speechlistener
    if not (self and self:IsAuthority()) then return end

    local listener = inst
    local speaker = self:GetSpeaker()

    inst:DoTaskInTime(0, function()
        if not (listener:IsValid() and speaker:IsValid() and self:GetSpeaker() == speaker and replica(speaker).speechgiver) then return end

        if not replica(speaker).speechgiver:IsInterruptible() or self.inputhandlers then return end

        self:DebugSay("Setting up input handlers.")

        local TheInput = _G.TheInput

        local function new_key_handler(name)
            return TheInput:AddKeyUpHandler(_G[name], function()
                if self.inst:IsValid() then
                    self.inst:DoTaskInTime(0, function()
                        if self.inst:IsValid() then
                            self:DebugSay("Interrupted by ", name, ".")
                            self:Interrupt()
                        end
                    end)
                end
            end)
        end

        local function new_control_handler(name)
            return TheInput:AddControlHandler(_G[name], function(down)
                if down and self.inst:IsValid() then
                    self:DebugSay("Interrupted by ", name, ".")
                    self:Interrupt()
                end
            end)
        end

        self.inputhandlers = {
            new_key_handler "KEY_ESCAPE",
            new_control_handler "CONTROL_PRIMARY",
            new_control_handler "CONTROL_SECONDARY",
            new_control_handler "CONTROL_ATTACK",
            new_control_handler "CONTROL_INSPECT",
            new_control_handler "CONTROL_ACTION",
            new_control_handler "CONTROL_CONTROLLER_ACTION",
        }
    end)
end

manageInputHandlers = function(inst)
    local self = replica(inst).speechlistener
    if not self then return end

    if self.net_input_handlers_enabled.value then
        doSetupInputHandlers(inst)
    else
        doClearInputHandlers(inst)
    end
end

---

doEnterCutScene = function(inst)
    local self = replica(inst).speechlistener
    if not self then return end

    if not self:IsAuthority() then
        return
    end

    self:DebugSay("EnterCutScene()")

    local speaker = self:GetSpeaker()
    local listener = inst

    if speaker.components.highlight then
        speaker.components.highlight:UnHighlight()
    end

    local cameracfg = TheMod:GetConfig("CUTSCENE_CAMERA")

    local participants_distance = math.sqrt( listener:GetDistanceSqToInst(speaker) )

    local height = cameracfg.HEIGHT
    local distance = math.max(8, cameracfg.RELATIVE_DISTANCE*participants_distance)

    local angle = -listener:GetAngleToPoint(speaker.Transform:GetWorldPosition()) - 90
    if _G.TheCamera.heading and math.abs(angle - _G.TheCamera.heading) > 90 then
        angle = angle + 180
    end

    local camerapos = (listener:GetPosition() + speaker:GetPosition())/2 + Vector3(0, height, 0)
    if _G.TheCamera.target then
        camerapos = camerapos - _G.TheCamera.target:GetPosition()
    end

    self.last_camera_heading = _G.TheCamera:GetHeadingTarget()

    _G.TheCamera:SetControllable(false)
    _G.TheCamera:SetHeadingTarget(angle)
    _G.TheCamera:SetOffset(camerapos)
    _G.TheCamera:SetDistance(distance)
    _G.TheCamera:SetGains( unpack(CAMERA_SLOW_GAINS) )

    Game.ShowPlayerHUD(listener, false)
end

doAbortCutScene = function(inst)
    local self = replica(inst).speechlistener
    if not self then return end

    if not self:IsAuthority() then return end

    self:DebugSay("AbortCutScene()")

    local listener = inst

    local speaker = self:GetSpeaker()
    local speechgiver = replica(speaker).speechgiver

    local function reset_condition()
        return not speaker:IsValid() or not speechgiver or not (speechgiver:IsInCutScene() or speechgiver:WantsCutScene())
    end

    listener:DoTaskInTime(0.33, function()
        if reset_condition() then
            Game.ShowPlayerHUD(listener, true)

            _G.TheCamera:SetControllable(true)
            _G.TheCamera:SetPaused(false)

            if self.last_camera_heading then
                _G.TheCamera:SetHeadingTarget(self.last_camera_heading)
                self.last_camera_heading = nil
            end

            _G.TheCamera:SetDefault()
            _G.TheCamera:SetGains( unpack(CAMERA_SLOW_GAINS) )

            listener:DoTaskInTime(5, function()
                if reset_condition() then
                    _G.TheCamera:SetDefault()
                end
            end)
        end
    end)
end

---

return SpeechListener
