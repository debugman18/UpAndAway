local Pred = wickerrequire 'lib.predicates'

local Game = wickerrequire 'utils.game'

local Debuggable = wickerrequire 'adjectives.debuggable'


local TopoMeta = modrequire 'lib.topology_metadata'


--[[
-- Returns the list of nodes within the minimum and maximum distances to
-- the given point.
--
-- It's not exact, since it only considers the nodes' inradii.
--]]
local function nodes_within_distance(pt, min_dist, max_dist)
	pt = Game.ToPoint(pt)


	local world = GetWorld()
	local nodes = world and world.topology and world.topology.nodes
	if not nodes then return {} end


	local ret = {}

	for _, node in ipairs(nodes) do
		local tile = world.Map:GetTileAtPoint(node.x, 0, node.y)
		if tile and tile ~= GROUND.IMPASSABLE then
			local dist = Game.DistanceToNode(pt, node)
			local inradius = TopoMeta.GetNodeInradius(node)
			if dist - inradius <= min_dist and dist + inradius >= max_dist then
				table.insert(ret, node)
			end
		end
	end

	return ret
end

--[[
-- Rotates a point in the plane by a given angle (radians).
--]]
local function rotate_pt(pt, theta)
	local c, s = math.cos(theta), math.sin(theta)
	return Vector3( pt.x*c - pt.z*s, pt.y, pt.x*s + pt.z*c )
end

--[[
-- Returns a random point in the given node at distance dist from origin,
-- provided such a point exists.
--
-- Let P0 be the origin. Let P1 be the center of node, with inradius r.
--
-- Let Pm be the midpoint of the line connecting the two
-- intersecting points of the two circumferences (the degenerate cases are
-- taken into account in the code).
--
-- Let P be the midpoint of the arc of the circumference around origin inside
-- the circle around node.cent (coordinates will be normalized by putting
-- the origin in (0,0,0) for the sake of its definition).
--
-- Let d be the distance from P0 to P1. Let a be the distance from P0 to Pm.
-- Let h be the distance from Pm to any of the points in the circumference
-- intersection.
--]]
local function random_pt_at_distance(node, origin, dist)
	local MAX_TRIES = 16


	local node_center = Vector3(node.cent[1], 0, node.cent[2])
	origin = Game.ToPoint(origin) + Point()
	origin.y = 0

	local r = TopoMeta.GetNodeInradius(node)


	--[[
	-- Theta is the angle which we can use to rotate P to both directions.
	--]]
	local theta

	local dir = node_center - origin
	local d = dir:Length()
	dir:Normalize()


	if d > r + dist then
		return nil
	elseif d <= math.abs(r - dist) then
		theta = math.pi
	else
		local a = (dist*dist - r*r + d*d)/(2*d)
		local h = math.sqrt( dist*dist - a*a )
		theta = math.atan(h/a)
	end

	
	local P = dir*dist

	for _ = 1, MAX_TRIES do
		local ang_delta = -theta + 2*theta*math.random()
		local test_pt = origin + rotate_pt(P, ang_delta)
		if Pred.IsUnblockedPoint(test_pt) then
			return test_pt
		end
	end
end


local EntityFlinger = Class(Debuggable, function(self)
	self:SetConfigurationKey("ENTITYFLINGER")


	--[[
	-- Private variables, use the corresponding methods.
	--]]
	self.min_dist = nil
	self.max_dist = nil
end)
