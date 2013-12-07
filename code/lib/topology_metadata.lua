--[[
-- Information about the world topology.
--]]

local Lambda = wickerrequire 'paradigms.functional'


--[[
-- Returns the minimum square distance between a point and a line segment.
--]]
local function distsq_point_to_line_segment(pt, seg_start, seg_end)
	--[[
	-- All "lengths" below are actually the square of them.
	--]]
	
	local base = seg_start
	-- Not normalized.
	local dir = seg_end - seg_start

	local seg_len = dir:LengthSq()
	
	--[[
	-- Coefficient of the projection.
	--]]
	local t = dir:Dot(pt - base)

	if t <= 0 then
		return pt:DistSq(seg_start)
	elseif t >= seg_len then
		return pt:DistSq(seg_end)
	else
		return pt:DistSq(base + dir*(t/seg_len))
	end
end


--[[
-- Receives a topology node and returns its inradius, i.e. the maximum
-- radius of a circle placed in its center such that the circle is completely
-- contained in the node.
--]]
GetNodeInradius = (function()
	local function CalculateInradius(node)
		local r2 = math.huge

		local center = Vector3(node.cent[1], 0, node.cent[2])

		local poly = node.poly
		local n_vertices = #poly
		for i, vertex1 in ipairs(poly) do
			local vertex2 = assert( poly[(i % n_vertices) + 1] )

			r2 = math.min(
				r2,
				distsq_point_to_line_segment(center, Vector3(vertex1[1], 0, vertex1[2]), Vector3(vertex2[1], 0, vertex2[2]))
			)
		end

		assert( r2 < math.huge )
		return math.sqrt(r2)
	end

	local inradii = setmetatable({}, {
		__mode = "k",

		__index = function(t, k)
			local v = CalculateInradius(k)
			t[k] = v
			return v
		end,
	})


	return Lambda.Getter(inradii)
end)()
