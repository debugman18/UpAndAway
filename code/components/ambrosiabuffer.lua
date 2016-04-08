BindGlobal()

local AmbrosiaBuffer = Class(function(self, inst)
   self.inst = inst
end)

function AmbrosiaBuffer:Enable(inst)
    -- Redundancy
    if self.enabled then return end
    self.enabled = true

    TheMod:DebugSay("Ambrosia enabled for entity " .. inst.prefab)

    inst.components.health.minhealth = 1 -- 10 works better, but is more visible. The illusion is ruined.

    inst:ListenForEvent("minhealth", self:Disable(), inst)

    if inst == ThePlayer then
        inst.components.talker:Say(STRINGS.AMBROSIA_ANNOUNCE)
        inst.HUD.controls.status.heart.anim:GetAnimState():SetMultColour(1,1,0,1) 
        inst:DoPeriodicTask(5, function(inst) 
            inst.HUD.controls.status.heart.pulse:GetAnimState():SetMultColour(1,1,0,1)
            inst.HUD.controls.status.heart.pulse:GetAnimState():PlayAnimation("pulse")
        end) 
    end
end

function AmbrosiaBuffer:Disable(inst)
    -- Redundancy
    if not self.enabled then return end
    self.enabled = false

    TheMod:DebugSay("Ambrosia disabled for entity " .. inst.prefab)

    if inst = ThePlayer then
        inst.components.sanity:SetPercent(1)
        inst.components.hunger:SetPercent(1) 
        inst.HUD.controls.status.heart.anim:GetAnimState():SetMultColour(0,0,0,1)                
    end

    inst.components.health:SetPercent(1)

    inst:RemoveEventCallback("minhealth", self:Disable(), )
    inst.components.health.minhealth = nil
    inst.components.health:SetInvincible(false)

    if IsDST() then
        local announcement_string = _G.GetNewRezAnnouncementString(inst, "Ambrosia magic")
        _G.TheNet:Announce(announcement_string, inst.entity, nil, "resurrect")
    end
end

function AmbrosiaBuffer:OnSave()
    local enabled = self.enabled and true or nil

    return {
        enabled = enabled,
    }
end

function AmbrosiaBuffer:OnLoad(data)
    if data and data.enabled then
        self:Enable()
    end
end

return AmbrosiaBuffer	