--TODO: check precisely how resurrection should work in MP.

BindGlobal()

local function doresurrect(inst, dude)
    dude:ClearBufferedAction()

    if dude.HUD then
        dude.HUD:Hide()
    end

    if dude.components.playercontroller then
        dude.components.playercontroller:Enable(false)
    end

    TheCamera:SetDistance(9)
    dude.components.hunger:Pause()
    dude.components.health:SetPercent(.5)
    dude.components.health:SetInvincible(true)
    
    dude:DoTaskInTime(2, function()            
        dude.sg:GoToState("wakeup")
        
        dude:DoTaskInTime(2, function() 
            if dude.HUD then
                dude.HUD:Show()
            end

            if dude.components.hunger then
                dude.components.hunger:SetPercent(1)
            end
            
            if dude.components.sanity then
                dude.components.sanity:SetPercent(.5)
            end

            if dude.components.playercontroller then
                dude.components.playercontroller:Enable(true)
            end
            
            dude.components.hunger:Resume()
            
            TheCamera:SetDefault()
        end)

        dude:DoTaskInTime(3, function() 
            dude.components.health:SetInvincible(false)
        end)  
    end)

    if inst.components.ambrosiarespawn then
        inst.components.ambrosiarespawn:Disable()
    end
end

local AmbrosiaRespawn = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    self.enabled = false

    if not inst.components.resurrector then
        inst:AddComponent("resurrector")
        inst.components.resurrector.doresurrect = doresurrect
    end
end)

function AmbrosiaRespawn:Enable()
    if self.enabled then return end
    self.enabled = true

    if self.inst.components.resurrector and self.inst.components.resurrectable then
        self.inst.components.resurrector.active = true
    end	
end

function AmbrosiaRespawn:Disable()
    if not self.enabled then return end
    self.enabled = false

    if self.inst.components.resurrector then
        self.inst.components.resurrector.active = false
    end
end

function AmbrosiaRespawn:OnSave()
    local enabled = self.enabled and true or nil
    if enabled then
        self:Disable()
        self.inst:DoTaskInTime(0, function(inst)
            if inst.components.ambrosiarespawn then
                inst.components.ambrosiarespawn:Enable()
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
