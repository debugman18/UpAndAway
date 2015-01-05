function ServerRPC.VoteForClimbing(player, climbable_inst, favorably)
	local cm = assert( GetClimbingManager() )
	if cm:AddRequest(climbable_inst) then
		if favorably then
			cm:AddAgreeablePlayer(climbable_inst, player)
		else
			cm:AddDisagreeablePlayer(climbable_inst, player)
		end
	end
end
