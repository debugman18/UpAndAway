local Pred = wickerrequire "lib.predicates"

local Debuggable = wickerrequire "adjectives.debuggable"

local FunctionQueue = wickerrequire "gadgets.functionqueue"

local Game = wickerrequire "game"
local AL = Game.AmbientLighting


---
-- World entity component for handling the ambiance of the cloud realm, such
-- as ambient light.
--
-- It is not networked. Instead, it relies on components.staticannouncer to
-- broadcast the charge/uncharge events across the network.
--
-- @author simplex
--
-- @class table
-- @name CloudAmbientManager
local CloudAmbientManager = Class(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "CloudAmbientManager")

    self:SetConfigurationKey("CLOUD_AMBIENT")

    self.colours = {}
    self.colours.UNCHARGED = self:GetConfig "UNCHARGED_COLOUR"
    self.colours.CHARGED = self:GetConfig "CHARGED_COLOUR"
    self.current_colour = self.colours.UNCHARGED

    self.transition_time = self:GetConfig "COLOUR_TRANSITION_TIME"

    self.onStateChangeCleanup = FunctionQueue()

	local function OnChangeState(inst, state)
		--self:Say("OnChangeState => ", state)
		local _self = inst.components.cloudambientmanager
        if self == _self then
            if self.onStateChangeCleanup then
                self:onStateChangeCleanup()
                self.onStateChangeCleanup = FunctionQueue()
            end
            self:OnEnterState(state)
        end
	end

    self.inst:ListenForEvent("upandaway_charge_broadcast", function(inst)
		return OnChangeState(inst, "CHARGED")
    end)
    self.inst:ListenForEvent("upandaway_uncharge_broadcast", function(inst)
		return OnChangeState(inst, "UNCHARGED")
    end)

	local function initialize_self()
		assert( GetPseudoClock() )
		self:ApplyColour()
		self.inst:DoTaskInTime(0, function()
			self:ApplyColour()
		end)
	end
	if IsDST() then
		assert( GetPseudoClock() == nil )
		TheMod:AddPrefabPostInit("world_network", initialize_self)
	else
		assert( GetPseudoClock(), "The clock should be added before cloudambientmanager!" )
		initialize_self()
	end
end)

function CloudAmbientManager:ApplyColour()
    for _, phase in ipairs{"day", "dusk", "night", "cave"} do
        AL.SetPhaseColour(phase, self.current_colour)
    end

    AL.SetAmbientColour(self.current_colour)
end

--[[
-- The effects are local to each player, not networked.
--]]
local function do_charged_effects(self)
    if IsDedicated() then return end

    local Sleep = _G.Sleep

    Sleep(self:GetConfig "FX_TRANSITION_DELAY")


    local wait = (function()
        local min, max = unpack(self:GetConfig "LIGHTNING_DELAY")
        return function()
            Sleep(min + (max - min)*math.random())
        end
    end)()

    local strike = (function()
        local prefab = "cloud_lightning_nonet"

        local min_radius, max_radius = unpack(self:GetConfig "LIGHTNING_DISTANCE")

        return function()
            local player = GetLocalPlayer()
            if not player then return end

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
    local clock = assert( GetPseudoClock() )

    local target_colour = assert( self.colours[state] )

    local colour_transition_time = self.transition_time
    if self.inst:GetTimeAlive() <= 2*_G.FRAMES then
        colour_transition_time = 0
    end
    clock:LerpAmbientColour(self.current_colour, target_colour, colour_transition_time)

    if state == "CHARGED" then
		if not IsDedicated() then
			local thread = self.inst:StartThread(function() do_charged_effects(self) end)
			table.insert(self.onStateChangeCleanup, function()
				CancelThread(thread)
			end)
		end
    end

    self.current_colour = target_colour
end


return CloudAmbientManager
