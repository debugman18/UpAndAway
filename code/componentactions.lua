TheMod:AddComponentsActions {
    SCENE = {
		climbable = function(inst, doer, actions, right)
			if replica(inst).climbable and replica(doer).climbingvoter then
				table.insert(actions, ACTIONS.CLIMB)
			end
		end,

        brewer = function(inst, doer, actions, right)
            if inst:HasTag("donebrewing") then
                table.insert(actions, ACTIONS.HARVEST)
            end
        end,

        withdrawable = function(inst, doer, actions, right)
            if right then
                table.insert(actions, ACTIONS.WITHDRAW)
            end
        end,

        speechgiver = function(inst, doer, actions, right)
            local sg = replica(inst).speechgiver
            if sg and sg:CanInteractWith(doer) then
                table.insert(actions, ACTIONS.BEGINSPEECH)
            end
        end,
    },
}
