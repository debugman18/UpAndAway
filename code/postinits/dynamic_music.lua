local Climbing = modrequire "lib.climbing"

TheMod:AddComponentPostInit("dynamicmusic", function(self)
	
	local old_StartPlayingBusy = self.StartPlayingBusy
	function self:StartPlayingBusy()
		
		--if Climbing.IsCloudLevelNumber(1) then
		if Climbing.IsCloudLevel() then
			self.inst.SoundEmitter:PlaySound( "upandaway/music/music_work_cloudrealm", "busy")
			self.inst.SoundEmitter:SetParameter( "busy", "intensity", 0 )
		else
			return old_StartPlayingBusy(self)
		end
	end
	
	-- A little patch to support cloud levels alongside caves
	local old_OnStartBusy = self.OnStartBusy
	function self:OnStartBusy()
		
		-- Let the original function set everything up.
		local result = old_OnStartBusy(self)
		
		if Climbing.IsCloudLevel() then
			self.busy_timeout = 15
			
			if not self.is_busy then
				self.is_busy = true
				if not self.playing_danger then
					self.inst.SoundEmitter:SetParameter( "busy", "intensity", 1 )
				end
			end
		end
		
		return result -- This is for the case a future change to the component adds return values.
	end
	
	local old_OnStartDanger = self.OnStartDanger
	function self:OnStartDanger()
		
		--if Climbing.IsCloudLevelNumber(1) then
		if Climbing.IsCloudLevel() then
			self.danger_timeout = 10
			
			if not self.playing_danger then
				local epic = _G.GetClosestInstWithTag("epic", self.inst, 30)
				--local epic = Game.FindSomeEntity(self.inst, 30, nil, {"epic"})
				local soundpath = nil
				
				if epic then
					soundpath = "upandaway/music/music_efs_cloudrealm"
				else
					soundpath = "upandaway/music/music_danger_cloudrealm"
				end
				
				self.inst.SoundEmitter:PlaySound(soundpath, "danger")
				self:StopPlayingBusy()
				self.playing_danger = true
			end
		else
			return old_OnStartDanger(self)
		end
	end
end)
