require "behaviours/chaseandattack"
require "behaviours/wander"
require "behaviours/doaction"

local MAX_CHASE_TIME = 20
local MAX_WANDER_DIST = 20

local START_FACE_DIST = 10
local KEEP_FACE_DIST = 20

local EelBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

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

function EelBrain:OnStart()

    local clock = GetClock()
    
    local root = PriorityNode(
    {
        ChaseAndAttack(self.inst, MAX_CHASE_TIME),
		Wander(self.inst),
    }, 1)
        
    self.bt = BT(self.inst, root)
         
end

return EelBrain
