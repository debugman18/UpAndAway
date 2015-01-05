local Climbable = Class(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "ClimbableReplica")

	-- This IS signed.
    self.net_direction = NetTinyByte(inst, "climbable.direction")
end)

function Climbable:SetDirection(direction)
	assert( direction == 1 or direction == -1 )

    self.net_direction.value = direction
end

function Climbable:GetDirection()
    return self.net_direction.value
end

function Climbable:GetDirectionString()
	local dir = self:GetDirection()
    if not dir or dir == 0 then return "" end
    if dir > 0 then
        return "UP"
    else
        return "DOWN"
    end
end

return Climbable
