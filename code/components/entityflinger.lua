local Pred = wickerrequire 'lib.predicates'

local Game = wickerrequire 'utils.game'

local Debuggable = wickerrequire 'adjectives.debuggable'


local TopoMeta = modrequire 'lib.topology_metadata'

local Physics = modrequire 'lib.physics'

local BitMask = modrequire 'lib.bitmask'


--[[
-- Returns the list of nodes within the minimum and maximum distances to
-- the given point.
--
-- Each entry is a table with the node itself and its effective maximum
-- and minimum distances.
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
			if dist - inradius >= min_dist and dist + inradius <= max_dist then
				table.insert(ret, {
					node = node,
					min_dist = dist - 0.95*inradius,
					max_dist = dist + 0.95*inradius,
				})
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


	local node_center = Point(node.cent[1], 0, node.cent[2])
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
		if Pred.IsUnblockedPoint(test_pt, 2) then
			return test_pt
		end
	end
end


local EntityFlinger = Class(Debuggable, function(self, inst)
	self.inst = inst
	self.inst:AddTag("NOFLING")

	Debuggable._ctor(self, "EntityFlinger")

	self:SetConfigurationKey("ENTITYFLINGER")


	--[[
	-- Private variables, use the corresponding methods.
	--]]
	self.min_dist = 32
	self.max_dist = 256
	self.height = 32
	self.attraction_radius = 4
	self.activity_radius = 0.25
	self.attraction_speed = 2

	self.attraction_test = nil

	self.motion_curve_gen = nil


	self.attraction_task = nil
	self.wants_to_die = false
	self.wants_to_attract = false


	--[[
	-- Tracked entities during the fling pre and post phases.
	--]]
	self.pre_fling = {}
	self.post_fling = {}

	--[[
	-- Entities being attracted.
	--]]
	self.attracted_ents = setmetatable({}, {__mode = "k"})


	self.entity_cleaner = function(ent)
		for _, kind in ipairs{"pre_fling", "post_fling"} do
			local tasks = self[kind][ent]
			if tasks then
				for task in pairs(tasks) do
					--[[
					-- We can clear entries of a table during iteration,
					-- what we can't is add new ones.
					--]]
					_G.KillThread(task)
					tasks[task] = nil
				end
			end
			self[kind][ent] = nil
		end
		self:Touch()
	end
end)


function EntityFlinger:WantsToDie()
	return self.wants_to_die
end

function EntityFlinger:RequestDeath()
	self.wants_to_die = true
end

function EntityFlinger:Touch()
	if self:WantsToDie() then
		if next(self.pre_fling) == nil and next(self.post_fling) == nil and next(self.attracted_ents) == nil then
			self.inst:Remove()
		end
	end
end


function EntityFlinger:WantsToAttract()
	return not self:WantsToDie() and self.wants_to_attract
end


local function get_metric(self, m)
	if Pred.IsCallable(m) then
		m = m(self.inst)
	end
	assert( Pred.IsPositiveNumber(m), "Invalid value!" )
	return m
end

--[[
-- Can be a function.
--]]
function EntityFlinger:SetMinimumDistance(d)
	OuterAssert( Pred.IsPositiveNumber(d) or Pred.IsCallable(d), "Invalid distance parameter." )
	self.min_dist = d
end

function EntityFlinger:GetMinimumDistance()
	return get_metric(self, self.min_dist)
end

--[[
-- Can be a function.
--]]
function EntityFlinger:SetMaximumDistance(d)
	OuterAssert( Pred.IsPositiveNumber(d) or Pred.IsCallable(d), "Invalid distance parameter." )
	self.max_dist = d
end

function EntityFlinger:GetMaximumDistance()
	return get_metric(self, self.max_dist)
end

--[[
-- Can be a function.
--]]
function EntityFlinger:SetHeight(h)
	OuterAssert( Pred.IsPositiveNumber(h) or Pred.IsCallable(h), "Invalid height parameter." )
	self.height = h
end

function EntityFlinger:GetHeight()
	return get_metric(self, self.height)
end

--[[
-- Can be a function.
--]]
function EntityFlinger:SetAttractionRadius(r)
	OuterAssert( Pred.IsPositiveNumber(r) or Pred.IsCallable(r), "Invalid radius parameter." )
	self.attraction_radius = r
end

function EntityFlinger:GetAttractionRadius()
	return get_metric(self, self.attraction_radius)
end

--[[
-- Can be a function.
--
-- Distance to stop attracting and start lifting.
--]]
function EntityFlinger:SetActivityRadius(r)
	OuterAssert( Pred.IsPositiveNumber(r) or Pred.IsCallable(r), "Invalid radius parameter." )
	self.activity_radius = r
end

function EntityFlinger:GetActivityRadius()
	return get_metric(self, self.activity_radius)
end

--[[
-- Can be a function.
--]]
function EntityFlinger:SetAttractionSpeed(s)
	OuterAssert( Pred.IsPositiveNumber(s) or Pred.IsCallable(s), "Invalid speed parameter." )
	self.attraction_speed = s
end

function EntityFlinger:GetAttractionSpeed()
	return get_metric(self, self.attraction_speed)
end

--[[
-- Test for which entities can be attracted.
--]]
function EntityFlinger:SetAttractionTest(fn)
	self.attraction_test = fn
end

function EntityFlinger:GetAttractionTest()
	return self.attraction_test
end

--[[
-- A function of elapsed time describing the position of the entity being
-- flinged at time t.
--]]
function EntityFlinger:SetMotionCurveGenerator(F)
	OuterAssert( Pred.IsCallable(F), "Invalid curve generator parameter." )
	self.motion_curve_gen = F
end

function EntityFlinger:GetMotionCurveGenerator()
	return self.motion_curve_gen
end

function EntityFlinger:GetMotionCurve(victim)
	return self:GetMotionCurveGenerator()(self.inst, victim)
end


function EntityFlinger:GetFlingDestination()
	local MAX_TRIES = 4

	local tentative = {
		min_dist = self:GetMinimumDistance(),
		max_dist = self:GetMaximumDistance(),
	}

	local candidates = nodes_within_distance(self.inst, tentative.min_dist, tentative.max_dist)

	if #candidates == 0 then return end

	for _ = 1, MAX_TRIES do
		local chosen = candidates[math.random(#candidates)]
		local pt = random_pt_at_distance(chosen.node, self.inst, chosen.min_dist + (chosen.max_dist - chosen.min_dist)*math.random())
		if pt then return pt end
	end
end


local TrackInst = {}
local UntrackInst = {}

function TrackInst.pre_fling(self, inst)
	if not self.pre_fling[inst] then
		self.pre_fling[inst] = setmetatable({}, {__mode = "k"})
		self.inst:ListenForEvent("onremove", self.entity_cleaner, inst)
	end
end

function UntrackInst.pre_fling(self, inst)
	if self.pre_fling[inst] then
		self.pre_fling[inst] = nil
		self.inst:RemoveEventCallback("onremove", self.entity_cleaner, inst)
	end
end

function TrackInst.post_fling(self, inst)
	UntrackInst.pre_fling(self, inst)
	if not self.post_fling[inst] then
		self.post_fling[inst] = setmetatable({}, {__mode = "k"})
		self.inst:ListenForEvent("onremove", self.entity_cleaner, inst)
	end
end

function UntrackInst.post_fling(self, inst)
	if self.post_fling[inst] then
		self.post_fling[inst] = nil
		self.inst:RemoveEventCallback("onremove", self.entity_cleaner, inst)
	end
end


local function IsCloseToPlayer(pt)
	pt = Game.ToPoint(pt)
	local p_pos = GetPlayer():GetPosition()
	local dx, dz = pt.x - p_pos.x, pt.z - p_pos.z
	return (dx*dx + dz*dz) < 25^2
end

local function DisableEntity(inst)
	if inst.brain then
		inst.brain:Stop()
	end
	if inst.sg then
		inst.sg:GoToState "idle"
		inst.sg:Stop()
	end
	if inst.components.playercontroller then
		inst.components.playercontroller:Enable(false)
	end
	if inst.Physics then
		inst.Physics:ClearMotorVelOverride()
		inst.Physics:SetMotorVel(0, 0, 0)
		inst.Physics:Stop()
	end
	if inst.components.locomotor then
		inst.components.locomotor:Stop()
	end
end

local function EnableEntity(inst)
	if inst.brain then
		inst.brain:Start()
	end
	if inst.sg then
		inst.sg:Start()
	end
	if inst.components.playercontroller then
		inst.components.playercontroller:Enable(true)
	end
end


local Begin = {}


function Begin.post_fling(self, inst)
	local UPDATE_PERIOD = 0.5

	if not (inst:IsValid() and inst.Physics) then return end

	TrackInst.post_fling(self, inst)
	local thread = self.inst:StartThread(function()
		DisableEntity(inst)

		Physics.PushDamping(
			inst,
			math.min(
				Physics.GetDamping(inst),
				0.75
			)
		)
		Physics.PushRestitution(
			inst,
			math.max(
				Physics.GetRestitution(inst),
				0.1
			)
		)

		if inst:HasTag("player") then
			inst.AnimState:PlayAnimation("wakeup")
			inst.AnimState:Pause()
			_G.TheFrontEnd:DoFadeIn(2.5)
		end

		inst.Physics:SetMotorVel(0, 1, 0)
		inst.Physics:SetMotorVel(0, 0, 0)

		local function get_height()
			local _, h = inst.Transform:GetWorldPosition()
			return h
		end

		while inst:IsValid() and get_height() > 0.1 do
			_G.Sleep(UPDATE_PERIOD)
		end

		_G.Sleep(1)

		if inst:HasTag("player") then
			inst.AnimState:Resume()
			inst.sg:GoToState "wakeup"
		end

		Physics.PopDamping(inst)
		Physics.PopRestitution(inst)

		EnableEntity(inst)

		UntrackInst.post_fling(self, inst)

		self:DebugSay("Post fling over [", inst, "] ended")

		self:Touch()
	end)
	self.post_fling[inst][thread] = true
end

function EntityFlinger:Fling(inst)
	self:DebugSay("Fling([", inst, "])")

	local pt = self:GetFlingDestination()

	if not pt or not inst:IsValid() or self:WantsToDie() then
		if inst:IsValid() then
			local targ_pos = inst:GetPosition()
			targ_pos.y = 0
			Game.Move(inst, targ_pos)
		end
		self:Touch()
		return
	end

	if inst:IsValid() and (inst:HasTag("player") or IsCloseToPlayer(pt)) then
		Game.Move(inst, pt + Point(0, self:GetHeight(), 0))
		Begin.post_fling(self, inst)
	else
		Game.Move(inst, pt)
	end
end


function Begin.pre_fling(self, victim)
	local UPDATE_PERIOD = 0.1

	if not (victim:IsValid() and victim.Physics and self.inst:IsValid() and self.inst.components.entityflinger) then return end

	TrackInst.pre_fling(self, victim)
	local thread = self.inst:StartThread(function()
		local UPDATE_FREQUENCY = 1/UPDATE_PERIOD

		local f = self:GetMotionCurve(victim)


		DisableEntity(victim)

		victim.Transform:SetRotation(0)

		if victim:HasTag("player") then
			if victim:HasTag("player") then
				victim.AnimState:PlayAnimation("idle_inaction_sanity", true)
			end
			victim:DoTaskInTime(1, function()
				_G.TheFrontEnd:Fade(false, 16)
			end)
		end


		victim.Physics:Teleport((self.inst:GetPosition() + f(0)):Get())

		local t = 0

		while victim:IsValid() and self.inst:IsValid() and self.inst.components.entityflinger do
			t = t + UPDATE_PERIOD

			local next_offset = f(t)
			if not next_offset then break end
			local next_pt = self.inst:GetPosition() + next_offset

			victim.Physics:SetMotorVel(( (next_pt - victim:GetPosition())*UPDATE_FREQUENCY ):Get())

			_G.Sleep(UPDATE_PERIOD)
		end

		EnableEntity(victim)

		self:Fling(victim)

		UntrackInst.pre_fling(self, victim)
	end)

	self.pre_fling[victim][thread] = true
end

function EntityFlinger:StartFlinging(inst)
	self:DebugSay("StartFlinging([", inst, "])")

	if self:WantsToDie() then
		self:Touch()
	else
		if IsCloseToPlayer(inst) then
			Begin.pre_fling(self, inst)
		else
			self:Fling(inst)
		end
	end
end

function EntityFlinger:ApplyAttraction(victim)
	local UPDATE_PERIOD = 0.15

	if not victim.Physics or self.attracted_ents[victim] then return end

	self:DebugSay("Started to attract [", victim, "]")
	self.attracted_ents[victim] = true

	self.inst:StartThread(function()
		DisableEntity(victim)

		victim.Transform:SetRotation(0)

		if victim:HasTag("player") then
			victim.AnimState:PlayAnimation("idle_inaction_sanity", true)
		end

		_G.Sleep(UPDATE_PERIOD*math.random())

		local cb = nil

		--local old_vel_summand = Vector3(0, 0, 0)

		while self:WantsToAttract() and victim:IsValid() and self.inst:IsValid() and self.inst.components.entityflinger do
			local attr_radius = self:GetAttractionRadius()
			local activ_radius = self:GetActivityRadius()

			local d2 = victim:GetDistanceSqToInst(self.inst)
			
			if d2 > attr_radius*attr_radius then
				self:DebugSay("[", victim, "] escaped the attraction radius.")
				break
			end

			if d2 <= activ_radius*activ_radius or victim:IsAsleep() then
				self:DebugSay("[", victim, "] entered the eye of the storm.")
				cb = self.StartFlinging
				break
			end


			--local cur_vel = Vector3(victim.Physics:GetVelocity())

			self:DebugSay("victim speed: ", Point(victim.Physics:GetVelocity()):Length())

			local vel_direction = (self.inst:GetPosition() - victim:GetPosition()):Normalize()

			local new_vel = vel_direction*self:GetAttractionSpeed()

			victim.Physics:SetMotorVel(new_vel:Get())


			--victim.Physics:SetMotorVel(self:GetAttractionSpeed(), 0, 0)

			self:DebugSay("new victim speed: ", Point(victim.Physics:GetVelocity()):Length())


			_G.Sleep(UPDATE_PERIOD)
		end

		if victim:IsValid() then
			--[[
			local cur_vel = Vector3(victim.Physics:GetVelocity())
			victim.Physics:SetMotorVel((cur_vel - old_vel_summand):Get())
			]]--
			victim.Physics:SetMotorVel(0, 0, 0)
		end

		EnableEntity(victim)

		self.attracted_ents[victim] = nil

		if self:WantsToDie() then
			self:Touch()
		elseif cb then
			cb(self, victim)
		end
	end)
end

EntityFlinger.StartAttracting = (function()
	local collision_mask = BitMask(_G.COLLISION.OBSTACLES)

	local function MakeStepper(self)
		local function test(ent)
			if
				ent.Physics
				and not self.attracted_ents[ent]
				and not self.pre_fling[ent]
				and not self.post_fling[ent]
				and ent.Physics:GetMass() > 0
				and collision_mask:Query( ent.Physics:GetCollisionMask() )
			then
				local p = self:GetAttractionTest()
				return not p or p(ent)
			end
		end

		return function()
			local Ents = Game.FindAllEntities(self.inst, self:GetAttractionRadius(), test, nil, {"NOFLING"})

			for _, e in ipairs(Ents) do
				self:ApplyAttraction(e)
			end
		end
	end

	return function(self)
		self:DebugSay("StartAttracting()")

		self.wants_to_attract = true

		local UPDATE_PERIOD = 0.6

		self.attraction_task = self.inst:DoPeriodicTask(UPDATE_PERIOD, MakeStepper(self), UPDATE_PERIOD*math.random())
	end
end)()

function EntityFlinger:StopAttracting()
	self.wants_to_attract = false
	self.attracted_ents = setmetatable({}, {__mode = "k"})
end

function EntityFlinger:OnSave()
	local data = {}
	local tracked_guids = {}
	
	for _, kind in ipairs{"pre_fling", "post_fling"} do
		local tracked_insts = self[kind]
		local datum = {}
		data[kind] = datum
		for inst in pairs(tracked_insts) do
			if inst:IsValid() then
				local guid = inst.GUID
				table.insert(datum, guid)
				table.insert(tracked_guids, guid)
			end
		end
	end

	return data, tracked_guids
end

function EntityFlinger:LoadPostPass(newents, data)
	if not data then return end
	for _, kind in ipairs{"pre_fling", "post_fling"} do
		local datum = data[kind]
		if datum then
			for _, guid  in ipairs(datum) do
				local inst = newents[guid]
				if inst then
					self.inst:DoTaskInTime(0.1, function()
						Begin[kind](self, inst)
					end)
				end
			end
		end
	end
end


return EntityFlinger
