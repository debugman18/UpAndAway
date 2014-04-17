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
	
    scheduler:ExecuteInTime(2, function()            
		
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

        GetPlayer():RemoveComponent("ambrosiarespawn")
    end)
end

local AmbrosiaRespawn = Class(function(self, inst)
	self.inst = inst

	if not self.inst.components.resurrector then
		self.inst:AddComponent("resurrector")
	end	

	if self.inst.components.resurrectable then
		self.inst.components.resurrector.doresurrect = doresurrect
		self.inst.components.resurrector.active = true
	end	
end)

return AmbrosiaRespawn	