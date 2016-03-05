local Climbing = modrequire "lib.climbing"

TheMod:AddClassPostConstruct("screens/loadgamescreen", function(self)
    self.MakeSaveTile = (function()
        local MakeSaveTile = self.MakeSaveTile

        return function(self, slotnum, ...)
            local tile = MakeSaveTile(self, slotnum, ...)

            local h = Climbing.GetLevelHeight(slotnum)
            if h > 0 then
                tile.text:SetString(("Cloudrealm %d"):format(h))
            end

            return tile
        end
    end)()
end)

TheMod:AddClassPostConstruct("screens/slotdetailsscreen", function(self)
    self.BuildMenu = (function()
        local BuildMenu = self.BuildMenu

        return function(self, ...)
            BuildMenu(self, ...)

            local slotnum = self.saveslot

            local h = Climbing.GetLevelHeight(slotnum)
            if h > 0 then
                local day = SaveGameIndex:GetSlotDay(slotnum)
                self.text:SetString(("Cloudrealm %d-%d"):format(h, day))
            end
        end
    end)()
end)
