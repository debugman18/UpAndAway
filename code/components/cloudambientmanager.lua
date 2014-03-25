
local Pred = wickerrequire 'lib.predicates'

local Debuggable = wickerrequire 'adjectives.debuggable'

local FunctionQueue = wickerrequire 'gadgets.functionqueue'


---
-- World entity component for handling the ambiance of the cloud realm, such
-- as ambient light.
--
-- @author simplex
--
-- @class table
-- @name CloudAmbientManager
local CloudAmbientManager = Class(Debuggable, function(self, inst)
	self.inst = inst
	Debuggable._ctor(self)

	assert( inst.components.clock, "The clock should be added before cloudambientmanager!" )

	self:SetConfigurationKey("CLOUD_AMBIENT")

	self.colours = {}
	self.colours.UNCHARGED = self:GetConfig "UNCHARGED_COLOUR"
	self.colours.CHARGED = self:GetConfig "CHARGED_COLOUR"
	self.current_colour = self.colours.UNCHARGED

	self.transition_time = self:GetConfig "COLOUR_TRANSITION_TIME"
	self.fx_transition_delay = self:GetConfig "FX_TRANSITION_DELAY"

	self.lightning_delay = {unpack(self:GetConfig "LIGHTNING_DELAY")}
	self.lightning_distance = self:GetConfig "MAX_LIGHTNING_DISTANCE"


	self.onStateChangeCleanup = FunctionQueue()

	self.inst:ListenForEvent("upandaway_chargechange", function(inst, data)
		local _self = inst.components.cloudambientmanager
		if self == _self then
			local state = assert( data.state )
			if self.onStateChangeCleanup then
				self:onStateChangeCleanup()
				self.onStateChangeCleanup = FunctionQueue()
			end
			self:OnEnterState(state)
		end
	end)

	self:ApplyColour()
end)

function CloudAmbientManager:ApplyColour()
	local clock = assert( self.inst.components.clock )

	for _, phase in ipairs{"day", "dusk", "night", "cave"} do
		clock[phase .. "Colour"] = self.current_colour
	end

	clock:LerpAmbientColour(self.current_colour, self.current_colour, 0)
end


local function do_charged_effects(self)
	local Sleep = _G.Sleep

	Sleep(self:GetConfig "FX_TRANSITION_DELAY")


	local wait = (function()
		local min, max = unpack(self:GetConfig "LIGHTNING_DELAY")
		return function()
			Sleep(min + (max - min)*math.random())
		end
	end)()

	local strike = (function()
		local player = GetPlayer()
		local prefab = "cloud_lightning"

		local min_radius, max_radius = unpack(self:GetConfig "LIGHTNING_DISTANCE")

		return function()
			local r = min_radius + (max_radius - min_radius)*math.random()
			local theta = 2*math.pi*math.random()

			local pt = player:GetPosition() + Vector3(r*math.cos(theta), 0, r*math.sin(theta))
			
			local it = SpawnPrefab(prefab)
			it.Transform:SetPosition(pt:Get())
		end
	end)()

	
	while true do
		strike()
		wait()
	end
end

function CloudAmbientManager:OnEnterState(state)
	local clock = assert( self.inst.components.clock )

	local target_colour = assert( self.colours[state] )

	local colour_transition_time = self.transition_time
	if self.inst:GetTimeAlive() <= 2*_G.FRAMES then
		colour_transition_time = 0
	end
	clock:LerpAmbientColour(self.current_colour, target_colour, colour_transition_time)

	if state == "CHARGED" then
		local thread = self.inst:StartThread(function() do_charged_effects(self) end)
		table.insert(self.onStateChangeCleanup, function()
			_G.KillThread(thread)
		end)
	end

	self.current_colour = target_colour
end


return CloudAmbientManager
