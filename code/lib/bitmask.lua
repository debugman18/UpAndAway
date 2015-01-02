--[[
-- Very basic bit mask implementation, intended to be used with physics
-- collision masks.
--]]

local Pred = wickerrequire "lib.predicates"

--[[
-- Returns the bits set by a number, counting from 0.
--]]
local function get_bits(n)
    assert( n >= 0 )
    local ret = {}

    for i = 0, math.huge do
        if n == 0 then break end
        if n % 2 == 1 then
            table.insert(ret, i)
        end
        n = math.floor(n/2)
    end

    return ret
end

local BitMask = Class(function(self, n)
    --[[
    -- Powers of two which when summed give n.
    --]]
    self.binary_factors = {}

    local binary_factors = self.binary_factors
    for _, i in ipairs(get_bits(n)) do
        table.insert(binary_factors, 2^i)
    end
end)

Pred.IsBitMask = Pred.IsInstanceOf(BitMask)

--[[
-- Checks if n has all the bits in self set.
--]]
function BitMask:Query(n)
    assert( Pred.IsBitMask(self) )
    for _, factor in ipairs(self.binary_factors) do
        if math.floor(n/factor) % 2 ~= 1 then
            return false
        end
    end
    return true
end


return BitMask
