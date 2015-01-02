---
-- Postinits to tweak the burnable behaviour.
--



local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local Climbing = modrequire "lib.climbing"


local ext_cfg = TheMod:GetConfig("FIRE", "EXTINGUISH")

local function get_extinguish_factor()
    local extinguish_factor = ext_cfg.SPEED[Climbing.GetLevelHeight()]
    if not Pred.IsNumber(extinguish_factor) then
        extinguish_factor = ext_cfg.SPEED.default
    end
    assert( Pred.IsPositiveNumber(extinguish_factor) )
    return extinguish_factor
end


local function explosive_common(explosive, inst)
    inst:DoTaskInTime(0, function(inst)
        local explosive = inst.components.explosive
        if inst:IsValid() and explosive then
            explosive.OnIgnite = Lambda.Nil
            explosive.OnBurnt = Lambda.Nil

            local burnable = inst.components.burnable
            if burnable then
                local oldonextinguish = burnable.onextinguish
                burnable.onextinguish = function(inst)
                    local persisted = inst.persists
                    if oldextinguish then oldextinguish(inst) end
                    inst.persists = persisted
                end
            end
        end
    end)
end

local function burnable_common(burnable, inst)
    inst:DoTaskInTime(0, function(inst)
        local burnable = inst.components.burnable
        if inst:IsValid() and burnable then

            if get_extinguish_factor() == math.huge then
                burnable:Extinguish()
            end
            burnable:SetOnIgniteFn(function(inst)
                local burnable = inst.components.burnable
            
                if burnable and burnable.burntime then
                    local dt = inst.components.burnable.burntime/get_extinguish_factor()
                    dt = math.min(dt, inst.components.burnable.burntime - 0.2)
                    dt = math.max(dt, 0)

                    inst:DoTaskInTime(dt, function(inst)
                        if inst.components.burnable then
                            inst.components.burnable:Extinguish()
                        end
                    end)
                end
            end)
        end
    end)
end

local function fueled_common(fueled, inst)
    inst:DoTaskInTime(0, function(inst)
        local fueled = inst.components.fueled
        local factor = get_extinguish_factor()

        if inst:IsValid() and fueled and fueled.fueltype == "BURNABLE" then
            local oldDoUpdate = fueled.DoUpdate
            fueled.DoUpdate = function(self, ...)
                local oldrate = self.rate
                self.rate = self.rate*factor
                oldDoUpdate(self, ...)
                self.rate = oldrate
            end
        end
    end)
end


TheMod:AddComponentPostInit("burnable", function(burnable, inst)
    if Pred.IsCloudLevel() then
        burnable_common(burnable, inst)
    end
end)

TheMod:AddComponentPostInit("explosive", function(explosive, inst)
    if Pred.IsCloudLevel() then
        explosive_common(explosive, inst)
    end
end)

TheMod:AddComponentPostInit("fueled", function(fueled, inst)
    if Pred.IsCloudLevel() then
        fueled_common(fueled, inst)
    end
end)
