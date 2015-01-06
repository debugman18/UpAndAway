local function proportional_test(p, strict)
	if strict then
		local floor = math.floor
		return function(total)
			return floor(p*total + 1)
		end
	else
		local ceil = math.ceil
		return function(total)
			return ceil(p*total)
		end
	end
end

local function all_but(k)
	return function(total)
		return total - k
	end
end

--[[
-- These are the available consensus modes.
--
-- Each is a function receiving the total number of players
-- and returning the minimum amount of players required to
-- approve the motion.
--]]
CONSENSUS_MODES = {
	UNANIMOUS = proportional_test(1),
	SIMPLE_MAJORITY = proportional_test(1/2, true),
	THREE_QUARTERS = proportional_test(3/4),
	EIGHTY_PERCENT = proportional_test(0.8),
	NINETY_PERCENT = proportional_test(0.9),
	ALL_BUT_ONE = all_but(1),
	ALL_BUT_TWO = all_but(2),
	ALL_BUT_THREE = all_but(3),
}
