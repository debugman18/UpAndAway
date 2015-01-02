if IsWorldgen() then return Recipe end

local mod_recipes = {}

local function get_mod_assetmap()
    local map = {}

    if not modenv.Assets then return map end

    for _, asset in ipairs(modenv.Assets) do
        map[_G.resolvefilepath(assert(asset.file))] = asset
    end

    return map
end

local function require_atlas(atlasname, mod_assetmap, recname)
    local asset = mod_assetmap[atlasname]

    if not asset then
        atlasname = _G.resolvefilepath(atlasname)
        asset = mod_assetmap[atlasname]
    end

    if not asset then
        if atlasname:find(MODROOT, 1, true) ~= 1 then return end
    end

    local err
    if not asset then
        err = "not declared"
    elseif asset.type ~= "ATLAS" then
        err = ("has invalid type '%s'"):format(tostring(asset.type))
    end

    if err then
        return error( ("Atlas '%s' required by recipe '%s' %s in modmain's Assets table."):format(tostring(atlasname), tostring(recname), err) )
    end
end

local function validate_recipe_assets(rec, mod_assetmap)
    require_atlas(rec.atlas, mod_assetmap, rec.name)

    if type(rec.ingredients) ~= "table" then
        return error( ("Recipe '%s' has self.ingredients of invalid type %s"):format(tostring(rec.name), tostring(type(rec.ingredients))) )
    end

    for _, ing in ipairs(rec.ingredients) do
        require_atlas(ing.atlas, mod_assetmap, rec.name)
    end
end

TheMod:AddPostRun(function(mainname)
    if mainname ~= "main" then return end

    TheMod:Say("Validating mod recipe assets..")

    local mod_assetmap = get_mod_assetmap()

    for recname, rec in pairs(mod_recipes) do
        validate_recipe_assets(rec, mod_assetmap)
    end

    TheMod:Say("Mod recipe assets validated.")

    mod_recipes = {}
end)

return function(recipes)
    for k, v in pairs(recipes) do
        mod_recipes[k] = v
    end
end
