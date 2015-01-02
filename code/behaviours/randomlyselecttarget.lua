BindGlobal()

local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local Game = wickerrequire "utils.game"

local RandomlySelectTarget = Class(BehaviourNode, function(self, inst, opts)
    BehaviourNode._ctor(self, "FindTarget")
    self.inst = inst
    self.range = opts.range or 30
    self.action = ACTIONS.WALKTO
    self.filter = opts.filter or Pred.True
    self.weight = opts.weight or Lambda.One
    self.tags = type(opts.tags) == "string" and {opts.tags} or opts.tags
    self.not_tags = type(opts.not_tags) == "string" and {opts.not_tags} or opts.not_tags
end)

function RandomlySelectTarget:DBString()
    return ("FindTarget on [%s]: status %s"):format(tostring(self.inst), tostring(self.status))
end

function RandomlySelectTarget:Visit()
    if self.status == READY then
        local act = self:GetAction()
        if act then
            self.inst.components.locomotor:PushAction(act)
            self.status = SUCCESS
        else
            self.status = FAILED
        end
    end
end

function RandomlySelectTarget:GetAction()
    local targ = self:PickTarget()
    if targ then
        if Pred.IsCallable(self.action) then
            return self.action(self.inst, targ)
        else
            return BufferedAction(self.inst, targ, self.action)
        end
    end
end

function RandomlySelectTarget:PickTarget()
    local ents = Game.FindAllEntities(self.inst, self.range, self.filter, self.tags, self.not_tags)
    local weights = {}

    for i, v in ipairs(ents) do
        weights[i] = self.weight(v, self.inst) or 0
    end

    local total_weight = Lambda.Fold(Lambda.Add, ipairs(weights))

    for i, v in ipairs(ents) do
        total_weight = total_weight - weights[i]
        if total_weight <= 0 then
            return v
        end
    end
end

return RandomlySelectTarget
