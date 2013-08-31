require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/chaseandram"
require "behaviours/chaseandattack"

local STOP_RUN_DIST = 0
local SEE_PLAYER_DIST = 20

local AVOID_PLAYER_DIST = 0
local AVOID_PLAYER_STOP = 0

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 50

local START_FACE_DIST = 14
local KEEP_FACE_DIST = 16

local GO_HOME_DIST = 40

local MAX_CHASE_TIME = 8
local MAX_CHASE_DIST = 40

local MAX_CHARGE_DIST = 15
local CHASE_GIVEUP_DIST = 10

local RUN_AWAY_DIST = 4
local STOP_RUN_AWAY_DIST = 5

local RamBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
	   inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetFaceTargetFn(inst)

    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 40*40) then
        return
    end

    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    
    local homePos = inst.components.knownlocations:GetLocation("home")
    local myPos = Vector3(inst.Transform:GetWorldPosition() )
    if (homePos and distsq(homePos, myPos) > 40*40) then
        return false
    end

    return inst:GetDistanceSqToInst(target) <= KEEP_FACE_DIST*KEEP_FACE_DIST and not target:HasTag("notarget")
end

local function EatFoodAction(inst)

    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and item.components.bait and not item:HasTag("planted") and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

function RamBrain:OnStart()
    local clock = GetClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST),
        WhileNode( function() return self.inst.components.combat.target == nil end,
            "RamAttack",
            ChaseAndRam(self.inst, MAX_CHASE_TIME, CHASE_GIVEUP_DIST, MAX_CHARGE_DIST) ),	
		IfNode( function() return self.inst.components.combat.target ~= nil end, "hastarget", AttackWall(self.inst)),			
        DoAction(self.inst, EatFoodAction),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return RamBrain
