BindGlobal()

require "behaviours/runaway"
require "behaviours/wander"
local RandomlySelectTarget = modrequire "behaviours.randomlyselecttarget"
local RandomlyWaitNode = modrequire "behaviours.randomlywaitnode"
local ConditionEventNode = modrequire "behaviours.conditioneventnode"

local Lambda = wickerrequire "paradigms.functional"
local Game = wickerrequire "utils.game"

local cfg = wickerrequire("adjectives.configurable")("SKYFLY")


local SkyflyBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

--[[
local function IsNotOnFlower(inst)
	return not Game.FindSomeEntity(inst, 0.5, nil, {"flower"})
end
]]--

local FlowerWeight = (function()
	local farness = cfg:GetConfig("PLAYER_FARNESS")
	local closeness = 1/farness

	return function(flower)
		local player = GetPlayer()

		if player then
			local d2 = player:GetDistanceSqToInst(flower)
			return math.exp(-closeness*d2)
		end
	end
end)()

function SkyflyBrain:OnStart()
    local clock = GetClock()

	local function far_enough(flower)
		return self.inst:GetDistanceSqToInst(flower) > 0.25
	end
    
    local root = PriorityNode(
    {
        --RunAway(self.inst, "scarytoprey", RUN_AWAY_DIST, STOP_RUN_AWAY_DIST),

		SequenceNode {
			RandomlySelectTarget(self.inst, {
				range = cfg:GetConfig("HOP_RANGE"),
				filter = far_enough,
				action = ACTIONS.WALKTO,
				weight = FlowerWeight,
				tags = {"flower"},
			}),
			ParallelNodeAny {
				ConditionEventNode(self.inst, "onreachdestination"),
				WaitNode( 3 ),
			},
			RandomlyWaitNode( unpack(cfg:GetConfig("HOP_COOLDOWN"))	),
		},

		Wander(self.inst),
    }, 1)
        
    self.bt = BT(self.inst, root)        
end

return SkyflyBrain
