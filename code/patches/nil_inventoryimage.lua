--[[
-- This sets the "nil" inventory image for out items without a proper icon
-- yet.
--
-- It is meant to prevent annoying log errors.
--]]

-- Returns a table mapping our prefabs to true.
local get_ua_prefab_map = (function()
    local prefab_map

    return function()
        if prefab_map then return prefab_map end

        prefab_map = {}

        for _, p in ipairs(_G.Prefabs["MOD_"..modenv.modname].deps) do
            prefab_map[p] = true
        end

        return prefab_map
    end
end)()

TheMod:AddPrefabPostInitAny(function(inst)
    if get_ua_prefab_map()[inst.prefab] then
        local ii = inst.components.inventoryitem
        if ii and not ii.atlasname and not ii.imagename then
            ii.atlasname = inventoryimage_atlas("nil")
            ii:ChangeImageName("nil")
        end
    end
end)
