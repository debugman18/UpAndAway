---
-- @author simplex



local submodules = {
    "entity_creation",
}


local Configurable = wickerrequire "adjectives.configurable"

local cfg = Configurable "PROFILING"


for _, m in ipairs(submodules) do
    if cfg:GetConfig(m:upper(), "ENABLED") then
        modrequire("profiling." .. m:lower())
    end
end
