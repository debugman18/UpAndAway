BindGlobal()

local BeardedLady = Class(function(self, inst)
    self.inst = inst
end)

function BeardedLady:OnSave(data)
    local player = GetPlayer()
    if player.components.beard then
        return  { growth = player.components.beard.daysgrowth }
    end
end

function BeardedLady:OnLoad(data)
    local player = GetPlayer()
    if data.growth then
        print ("loaded beardfabricator: "..data.growth)
        player:AddComponent("beard")
        local beard_days = {4, 8, 16}
        local beard_bits = {1, 3,  9}   

        player.components.beard.onreset = function()
            player.AnimState:ClearOverrideSymbol("beard")
        end

        player.components.beard.prize = "beardhair"
        player.components.beard:AddCallback(beard_days[1], function()
            player.AnimState:OverrideSymbol("beard", "beard", "beard_short")
            player.components.beard.bits = beard_bits[1]
        end)

        player.components.beard:AddCallback(beard_days[2], function()
            player.AnimState:OverrideSymbol("beard", "beard", "beard_medium")
            player.components.beard.bits = beard_bits[2]
        end)  

        player.components.beard:AddCallback(beard_days[3], function()
            player.AnimState:OverrideSymbol("beard", "beard", "beard_long")
            player.components.beard.bits = beard_bits[3]
        end)

        player.components.beard.daysgrowth = data.growth

        if player.components.beard.daysgrowth >= 4 and player.components.beard.daysgrowth < 8 then
            
            local cb = player.components.beard.callbacks[beard_days[1]]
            cb()

        elseif player.components.beard.daysgrowth >= 8 and player.components.beard.daysgrowth < 16 then

            local cb = player.components.beard.callbacks[beard_days[2]]
            cb()

        elseif player.components.beard.daysgrowth >= 16 then

            local cb = player.components.beard.callbacks[beard_days[3]]
            cb()
        end
    end
end

return BeardedLady	