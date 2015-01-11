
local CFG = TheMod:GetConfig()

--local beanlet_cfg = Configurable "BEANLET"
--local zealot_cfg = Configurable "BEANLET_ZEALOT"

local SCARE_RADIUS = CFG.BEANLET.SCARE_RADIUS --beanlet_cfg("SCARE_RADIUS")
local SHARE_ATTACK_RADIUS = CFG.BEANLET_ZEALOT.GANG_UP_RADIUS --zealot_cfg("GANG_UP_RADIUS")

local MAX_RADIUS = math.max(SCARE_RADIUS, SHARE_ATTACK_RADIUS)

---

local SCARE_RADIUS_SQ = SCARE_RADIUS*SCARE_RADIUS
local SHARE_ATTACK_RADIUS = SHARE_ATTACK_RADIUS*SHARE_ATTACK_RADIUS

---

function OnBeanletAttacked(inst, data)
    local is_zealot = inst:HasTag("zealot")

    if is_zealot then
        TheWorld.components.reputation:LowerReputation("bean", 15, true)
    else
        TheWorld.components.reputation:LowerReputation("bean", 8, true)
    end

    local beans = Game.FindAllEntities(inst, MAX_RADIUS, nil, {"beanlet"})
    
    for _, bean in ipairs(beans) do
        local dsq = bean:GetDistanceSqToInst(inst)
        if not bean:HasTag("zealot") then
            if dsq < SCARE_RADIUS_SQ then
                bean:PushEvent("gohome")
            end
        elseif bean.components.combat then
            if dsq < SHARE_ATTACK_RADIUS then
                if is_zealot then
                    bean.components.combat:SuggestTarget(data.attacker)
                else
                    bean.components.combat:SetTarget(data.attacker)
                end
            end
        end
    end
end
