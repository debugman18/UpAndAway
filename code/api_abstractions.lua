---
-- Abstracts the Don't Starve API to increase compatibility across several game versions.
--
-- @class module
-- @name upandaway.api_abstractions

BindGlobal()


wickerrequire "plugins.addgenericclasspostconstruct"


local ModEnv = modrequire "modenv"


--------------------------------------


function try_require(options)
    if type(options) ~= "table" then options = {options} end

    for _, m in ipairs(options) do
        local status, pkg = pcall(require, m)
        if status then return pkg, m end
    end
end

function alias_pkg(target, sources)
    if package.loaded[target] then return end
    if type(sources) ~= "table" then sources = {sources} end
    table.insert(sources, 1, target)
    package.loaded[target] = try_require(sources)
end
