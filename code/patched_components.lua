--[[
-- Maps names of patched components to tables whose first entry is the patched
-- component and whose second entry is the name of the component which was
-- patched.
--]]
local patched_cmps = {}

local function LoadPatchedCmp(name)
    local cmpdata = patched_cmps[name]
    if not cmpdata then
        cmpdata = pkgrequire("patched_components."..name)
        patched_cmps[name] = cmpdata
    end
    return cmpdata[1], cmpdata[2]
end

function Add(inst, name, ...)
    local cmp, basename = LoadPatchedCmp(name)
    inst.components[basename] = cmp(inst, ...)
    return inst.components[basename]
end

return _M
