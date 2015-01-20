local ACTIONS = _G.ACTIONS

local AddStringPatch = (function()
    local patches = {}

    TheMod:AddPlayerPostInit(function(inst)
        local oldactionstringoverride = inst.ActionStringOverride
        function inst:ActionStringOverride(bufaction)
            local tests = bufaction.action and patches[bufaction.action]
            if tests then
                for _, t in ipairs(tests) do
                    if t.target_cond == nil or (bufaction.target and t.target_cond(bufaction.target)) then
                        return t.override
                    end
                end
            end
            if oldactionstringoverride then
                return oldactionstringoverride(inst, bufaction)
            end
        end
    end)

    return function(action, target_condition, override)
        if not action then
            return error("Non-existent action passed as patch parameter.", 2)
        end
        local tests = patches[action]
        if tests == nil then
            tests = {}
            patches[action] = tests
        end
        table.insert(tests, {target_cond = target_condition, override = override})
    end
end)()

--Changes "activate" to "climb down" for "beanstalk_exit".
AddStringPatch(ACTIONS.ACTIVATE, Pred.IsPrefab("beanstalk_exit"), "Climb Down")

--Changes "Give" to "Plant" for beans and mounds.
AddStringPatch(ACTIONS.GIVE, Pred.IsPrefab("mound"), "Plant")

--Changes "Bury" to "Plant" for beans and mounds.
if ACTIONS.BURY then
    AddStringPatch(ACTIONS.BURY, Pred.IsPrefab("mound"), "Plant")
end

--Changes "Give" to "Refine" for the refiner.
AddStringPatch(ACTIONS.GIVE, Pred.IsPrefab("refiner"), "Refine")

--Changes "Give" to "Cook" for the dragonblood tree.
AddStringPatch(ACTIONS.GIVE, Pred.HasTag("dragonblood"), "Cook")

--Changes "Use" to "Eat" for the bean brain.
AddStringPatch(ACTIONS.USEITEM, Pred.IsPrefab("bean_brain"), "Eat")
