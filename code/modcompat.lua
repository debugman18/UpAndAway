---
-- Runs mod compatibility code.
--

BindTheMod()
BindGlobal()

-- Stores the compatibility functions. The key is the mod id or name.
-- Each function receives the target's mod modinfo and mod table (as
-- stored in the mod manager).
local MODCOMPAT = {}

local Reflection = wickerrequire "game.reflection"


------------------------------------------------------------------------


--This adds support for Always On Status for our characters.
MODCOMPAT["Always On Status"] = function()
    AddPrefabPostInit("winnie", function(inst)
        pcall(function()
            inst:AddComponent("switch")
        end)
    end) 
end

MODCOMPAT["Too Many Items"] = function()
    local forbidden_prefabs = {
        cloudrealm = true,
        winnie = true,
        duckraptor = true,
    }

    TheMod:AddSimPostInit(function()
        TheMod:Say("Running TMI compatibility code.")
        local status, err = pcall(function()
            local mymod = assert( _G.ModManager:GetMod(modenv.modname), "Unable to find self in the ModManager!" )
            local myPrefabs = assert( mymod.Prefabs )

            local ITEMLIST = require "itemlist"
            if type(ITEMLIST) ~= "table" then
                ITEMLIST = _G.ITEMLIST
                if type(ITEMLIST) ~= "table" then return end
            end

            for prefab_name in pairs(myPrefabs) do
                if not forbidden_prefabs[prefab_name] then
                    TheMod:Say("(TMI) Adding prefab ", prefab_name)
                    table.insert(ITEMLIST, prefab_name)
                end
            end
        end)

        if status then
            TheMod:Say("Ran TMI compatibility code.")
        else
            TheMod:Say("Failed to run TMI compatibility code: ", err)
        end
    end)
end

MODCOMPAT["N Tools"] = function(info, mod)
    if not IsHost() then return end

    TheMod:AddPlayerPostInit(function(player)
        local thread = nil
        local is_running = false

        player:ListenForEvent("invincibletoggle", function(player, data)
            if thread then
                CancelThread(thread)
                thread = nil
                is_running = false
            end

            local ntools_env = assert(mod.env)

            local n_tools_5 = ntools_env.n_tools_5
            if not n_tools_5 then return end

            if is_running then return end
            is_running = true

            if not player.components.health then return end
            local inv = player.components.health.invincible

            local function handler_thread()
                local tb = n_tools_5.togglebutton

                if not (tb and tb:IsEnabled() and tb.onclick) then return end

                if not tb.text then return end

                local function should_refresh()
                    if not (player.components.health and tb.text and tb.onclick) then return false end

                    if inv ~= player.components.health.invincible then
                        return false
                    end

                    local txt = tb.text:GetString()
                    if inv and txt == "Go Invincible" then
                        return true
                    elseif not inv and txt == "Go Vulnerable" then
                        return true
                    end

                    return false
                end

                _G.Yield()

                while should_refresh() do
                    tb.onclick()
                    tb.onclick()
                    if should_refresh() then
                        tb.onclick()
                        _G.Yield()
                    end
                end
            end

            thread = player:StartThread(function()
                handler_thread()
                is_running = false
                thread = nil
            end)
        end)
    end)
end


------------------------------------------------------------------------


local patched_mods = {}

-- info is each mod's modinfo table.
Reflection.FindActiveMod(function(info, mod)
    local handler = MODCOMPAT[info.id] or MODCOMPAT[info.name]
    local id = info.name
    if MODCOMPAT[info.id] then
        id = info.id
    end

    if handler then
        TheMod:Say(("%q"):format(info.name), " is installed. Patching...")
        handler(info, mod)
        patched_mods[id] = true
    end
end)

if Debug() then
    for id in pairs(MODCOMPAT) do
        if not patched_mods[id] then
            TheMod:Say("Mod ", ("%q"):format(id), " was not patched, as it is not installed/enabled.")
        end
    end
end
