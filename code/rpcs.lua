function ServerRPC.VoteForClimbing(player, climbable_inst, favorably)
	local cm = assert( GetClimbingManager() )
	if favorably then
		cm:AddAgreeablePlayer(climbable_inst, player)
	else
		cm:AddDisagreeablePlayer(climbable_inst, player)
	end
end
