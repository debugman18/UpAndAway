--[[
-- Value used as key in GetWorld().meta.
--
-- Changing it breaks compatibility with data stored previously when saving.
--]]
local metadata_key = modinfo.id.."_metadata"


local Lambda = wickerrequire "paradigms.functional"


local function get_mtdata_table()
    local meta = rawget(_G, "GetWorld") and GetWorld() and GetWorld().meta
    if meta then
        local ua = meta[metadata_key]
        if not ua then
            ua = {}
            meta[metadata_key] = ua
        end
        return ua
    end
end

function Get(k)
    local t = get_mtdata_table()
    if t then
        return t[k]
    end
end

function Set(k, v)
    local t = get_mtdata_table()
    if t then
        t[k] = v
    end
end

function Pairs()
    local t = get_mtdata_table()
    if t then
        return pairs(t)
    else
        return Lambda.Iterator.Empty()
    end
end
