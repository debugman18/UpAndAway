local ClimbingVoter = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self, "ClimbingVoter")

	self:SetConfigurationKey "CLIMBING_VOTER"
end)

---

function ClimbingVoter:Vote(target_inst, favorably)
	return replica(self.inst).climbingvoter:Vote(target_inst, favorably)
end

function ClimbingVoter:BeginPoll(target_inst)
	if not (Pred.IsValidEntity(target_inst) and target_inst.components.climbable) then
		return error("Attempt to begin climbing poll over invalid target ["..tostring(target_inst).."].")
	end

	local cm = assert( GetClimbingManager() )

	local range = assert( self:GetConfig("RANGE") )
	local nearby_players = Game.FindAllPlayersInRange(target_inst, range, function(player)
		return IsSingleplayer() or player.userid ~= nil
	end)
	if #nearby_players >= cm:GetMinimumPlayers() then
		return cm:AddRequest(target_inst)
	else
		TheMod:Say("GATHERPARTY: ", #nearby_players, "/", cm:GetMinimumPlayers())
		return false, "GATHERPARTY"
	end
end

---

return ClimbingVoter
