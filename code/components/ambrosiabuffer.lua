BindGlobal()

local AmbrosiaBuffer = Class(function(self, inst)
    self.enabled = false
    self.inst = inst
end)

function AmbrosiaBuffer:Disable(inst)
    -- Redundancy
    if not self.enabled then return end
    self.enabled = false

    TheMod:DebugSay("Ambrosia disabled for entity " .. inst.prefab)

    inst.components.health:SetInvincible(true)

    if inst.prefab == ThePlayer.prefab then
        inst:RemoveTag("ambrosia_indicator")
        inst.components.sanity:SetPercent(1)
        inst.components.hunger:SetPercent(1)             
    end

    inst.components.health:SetMinHealth(0)
    inst.components.health:SetPercent(1)

    inst:RemoveEventCallback("minhealth", function(inst) self:Disable(inst) end)
    inst.components.health:SetInvincible(false)

    if IsDST() then
        local announcement_string = _G.GetNewRezAnnouncementString(inst, "Ambrosia magic")
        _G.TheNet:Announce(announcement_string, inst.entity, nil, "resurrect")
    end
end

function AmbrosiaBuffer:Enable(inst)
    -- Redundancy
    self.enabled = true

    TheMod:DebugSay("Ambrosia enabled for entity " .. inst.prefab)

    -- Listen for health hitting near-zero.
    inst:ListenForEvent("minhealth", function(inst) self:Disable(inst) end)
    inst.components.health:SetMinHealth(1)

    -- Effects that should only matter to the player.
    if inst.prefab == ThePlayer.prefab then
        inst.components.talker:Say(STRINGS.AMBROSIA_ANNOUNCE[string.upper(inst.prefab)] or STRINGS.AMBROSIA_ANNOUNCE.GENERIC)
        inst:AddTag("ambrosia_indicator")

        -- Listen for hunger hitting zero.
        inst:ListenForEvent("startstarving", function(inst) self:Disable(inst) end)

        -- Listen for sanity hitting zero.
        inst:ListenForEvent("sanitydelta", function(inst, data)
            if (data.newpercent == 0) then
                self:Disable(inst)
            end
        end)

        inst:DoPeriodicTask(5, function(inst)
            if inst:HasTag("ambrosia_indicator") then 
                inst.HUD.controls.status.heart.pulse:GetAnimState():SetMultColour(1,1,0,1)
                inst.HUD.controls.status.heart.pulse:GetAnimState():PlayAnimation("pulse")

                inst.HUD.controls.status.stomach.pulse:GetAnimState():SetMultColour(1,1,0,1)
                inst.HUD.controls.status.stomach.pulse:GetAnimState():PlayAnimation("pulse")

                inst.HUD.controls.status.brain.pulse:GetAnimState():SetMultColour(1,1,0,1)
                inst.HUD.controls.status.brain.pulse:GetAnimState():PlayAnimation("pulse")                
            end
        end) 
    end

end

function AmbrosiaBuffer:OnSave()
    return {
        enabled = self.enabled or nil,
    }
end

function AmbrosiaBuffer:OnLoad(data)
    if data and data.enabled then
        self:Enable(self.inst)
    end
end

return AmbrosiaBuffer	