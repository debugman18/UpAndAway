BindGlobal()

local AmbrosiaRespawn = Class(function(self, inst)
   self.inst = inst
   self.enabled = false
end)

function AmbrosiaRespawn:Enable(inst)
    if self.enabled then return end
    self.enabled = true
    TheMod:DebugSay("Ambrosia enabled.")

    ThePlayer.components.health.minhealth = 1 -- 10 works better, but is more visible. The illusion is ruined.

    ThePlayer.components.talker:Say("I feel like I can take on anything!")
    ThePlayer.HUD.controls.status.heart.anim:GetAnimState():SetMultColour(1,1,0,1) 
    ThePlayer:DoPeriodicTask(5, function(inst) 
        ThePlayer.HUD.controls.status.heart.pulse:GetAnimState():SetMultColour(1,1,0,1)
        ThePlayer.HUD.controls.status.heart.pulse:GetAnimState():PlayAnimation("pulse")
    end) 

end

function AmbrosiaRespawn:Disable(inst)
    if not self.enabled then return end
    self.enabled = false
    TheMod:DebugSay("Ambrosia disabled.")

    player.components.health:SetPercent(1)
    player.components.sanity:SetPercent(1)
    player.components.hunger:SetPercent(1)

    if IsDST() then
        local announcement_string = _G.GetNewRezAnnouncementString(inst, "Ambrosia magic")
        _G.TheNet:Announce(announcement_string, player.entity, nil, "resurrect")
    end

    ThePlayer:RemoveEventCallback("minhealth")
    ThePlayer.components.health.minhealth = nil
    ThePlayer.components.health:SetInvincible(false)
    ThePlayer.HUD.controls.status.heart.anim:GetAnimState():SetMultColour(0,0,0,1) 
end

function AmbrosiaRespawn:OnSave()
    local enabled = self.enabled and true or nil
    if enabled then
        self.inst:DoTaskInTime(0, function(inst)
            if ThePlayer.components.ambrosiarespawn then
                ThePlayer.components.ambrosiarespawn:Enable()
            end
        end)
    end
    return {
        enabled = enabled,
    }
end

function AmbrosiaRespawn:OnLoad(data)
    if data and data.enabled then
        self:Enable()
    end
end

return AmbrosiaRespawn	
