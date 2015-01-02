local Terraforming = modrequire "lib.terraforming"
local Climbing = modrequire "lib.climbing"

local new_tiles = TheMod:GetConfig("NEW_TILES")


--[[
-- Addition of custom tiles
--]]

local CURRENT_ID = 65

for i, v in ipairs(new_tiles) do
    local v_upper = v:upper()
    TheMod:AddTile(v_upper, CURRENT_ID, v, {noise_texture = "noise_" .. v .. ".tex"}, {noise_texture = "mini_noise_" .. v .. ".tex"})
    Terraforming.MakeTileUndiggable(GROUND[v_upper])

    CURRENT_ID = CURRENT_ID + 1
end


--[[
TheMod:AddTile("WALL_CLOUD", CURRENT_ID, "walls_cloud", {}, {})
CURRENT_ID = CURRENT_ID + 1



TheMod:AddGlobalClassPostConstruct("map/storygen", "Story", function(self)
    if Climbing.IsCloudLevelObject(self.level) then
        local impassible = assert( _G.GROUND.IMPASSABLE )
        self.impassible_value = impassible
        self.gen_params.impassible_value = impassible
    end
end)
]]--
