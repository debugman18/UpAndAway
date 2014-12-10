--FIXME: not MP compatible

BindGlobal()

local BeardedLady = HostClass(function(self, inst)
    self.inst = inst
end)

function BeardedLady:OnSave(data)
    if self.inst.components.beard then
        return  { growth = self.inst.components.beard.daysgrowth }
    end
end

function BeardedLady:OnLoad(data)
    if data.growth then
        print ("loaded beardfabricator: "..data.growth)
        self.inst:AddComponent("beard")
        local beard_days = {4, 8, 16}
        local beard_bits = {1, 3,  9}   

        self.inst.components.beard.onreset = function()
            self.inst.AnimState:ClearOverrideSymbol("beard")
        end

        self.inst.components.beard.prize = "beardhair"
        self.inst.components.beard:AddCallback(beard_days[1], function()
            self.inst.AnimState:OverrideSymbol("beard", "beard", "beard_short")
            self.inst.components.beard.bits = beard_bits[1]
        end)

        self.inst.components.beard:AddCallback(beard_days[2], function()
            self.inst.AnimState:OverrideSymbol("beard", "beard", "beard_medium")
            self.inst.components.beard.bits = beard_bits[2]
        end)  

        self.inst.components.beard:AddCallback(beard_days[3], function()
            self.inst.AnimState:OverrideSymbol("beard", "beard", "beard_long")
            self.inst.components.beard.bits = beard_bits[3]
        end)

        self.inst.components.beard.daysgrowth = data.growth

        if self.inst.components.beard.daysgrowth >= 4 and self.inst.components.beard.daysgrowth < 8 then
            
            local cb = self.inst.components.beard.callbacks[beard_days[1]]
            cb()

        elseif self.inst.components.beard.daysgrowth >= 8 and self.inst.components.beard.daysgrowth < 16 then

            local cb = self.inst.components.beard.callbacks[beard_days[2]]
            cb()

        elseif self.inst.components.beard.daysgrowth >= 16 then

            local cb = self.inst.components.beard.callbacks[beard_days[3]]
            cb()
        end
    end
end

return BeardedLady	
