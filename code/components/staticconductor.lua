local CFG = TheMod:GetConfig()

-- The component constructor.
local StaticConductor = HostClass(Debuggable, function(self, inst)
    self.inst = inst

    self.shockrange = CFG.STATIC_CONDUCTOR.SHOCK_RANGE --5
    self.shockdamage = CFG.STATIC_CONDUCTOR.SHOCK_DAMAGE --5

    self.resistance = 0

    self.conductive = true
    self.spreading = false
end)

local dt = 0.5

function StaticConductor:SetDamage(damage)
    self.shockdamage = damage
end

function StaticConductor:SetRange(shockrange)
    self.shockrange = shockrange
end

function StaticConductor:SetResistance(resistance)
    self.resistance = resistance
end

function StaticConductor:StopUpdating()
    if self.task then
        self.task:Cancel()
        self.task = nil
    end
end

function StaticConductor:StartUpdating()
    if not self.task then
        self.task = self.inst:DoPeriodicTask(dt, function() self:OnUpdate(dt) end, dt + math.random()*.67)
    end
end

function StaticConductor:StartSpreading()
    self.spreading = true
    self:StartUpdating()
end

function StaticConductor:StopSpreading()
    self.spreading = false
    self:StopUpdating()
end

local function calc_damage(self, staticresistance) 
    if ((self.shockdamage * dt) - staticresistance) <= 0 then
        return 0
    else
        return -((self.shockdamage * dt) - staticresistance) 
    end
end

function StaticConductor:OnUpdate(dt)

    if self.spreading then
        
        local pos = Vector3(self.inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, self.shockrange)
        local staticresistance = 0

        for k,v in pairs(ents) do
            if not v:IsInLimbo() then
			    if v.components.staticconductor and v.components.staticconductor.conductive then
                    if v.components.inventory then
                        local inventory = v.components.inventory
                        for equipslots,item in pairs(inventory.equipslots) do
                            if item.components.staticconductor and item.components.staticconductor.resistance then
                                staticresistance = item.components.staticconductor.resistance
                            end
                        end
                    end                   
				    local dsq = distsq(pos, Vector3(v.Transform:GetWorldPosition()))                    
			        if dsq < self.shockrange*self.shockrange then
                        if v.components.health then
                            if staticresistance then
				                v.components.health:DoDelta(calc_damage(self, staticresistance))
                            else
                                v.components.health:DoDelta(-self.shockdamage * dt)
                            end
			            end
                    end
			    end
			end
        end
    end
        
    if not self.spreading then
        self:StopSpreading()
    end
    
end

return StaticConductor
