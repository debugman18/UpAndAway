BindGlobal()

local CFG = TheMod:GetConfig()

require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local GooseBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, CFG.GOOSE.SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end)
        if target then
            --check for scary things near the food
            local predator = GetClosestInstWithTag("scarytoprey", target, CFG.GOOSE.SEE_PLAYER_DIST)
            if predator then target = nil end
        end
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end

function GooseBrain:OnStart()
    local clock = GetPseudoClock()
    
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        DoAction(self.inst, EatFoodAction, "Eat Food"),
        RunAway(self.inst, "scarytoprey", CFG.GOOSE.SEE_PLAYER_DIST, CFG.GOOSE.STOP_RUN_DIST),
        Wander(self.inst, HomePos, CFG.GOOSE.MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)
end

return GooseBrain