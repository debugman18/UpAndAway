BindGlobal()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/follow"
require "behaviours/faceentity"

local STOP_RUN_DIST = 2
local SEE_PLAYER_DIST = 10

local AVOID_PLAYER_DIST = 2
local AVOID_PLAYER_STOP = 2

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 50


local SheepBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function GetFaceTargetFn(inst)
    local target = GetClosestInstWithTag("player", inst, 4)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= 6*6 and not target:HasTag("notarget")
end


local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
	   inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function EatFoodAction(inst)

    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

function SheepBrain:OnStart()
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        Follow(self.inst, function() return self.inst.components.follower and self.inst.components.follower.leader end, 1, 5, 5, false),
        --FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
        RunAway(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST, nil, true),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST),		
        DoAction(self.inst, EatFoodAction)
    }, .25)
    self.bt = BT(self.inst, root)
end

return SheepBrain
