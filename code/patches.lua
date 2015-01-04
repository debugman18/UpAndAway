---
-- Loads the patches submodules.
--

local Reflection = wickerrequire "game.reflection"

--TODO: review this once caves are properly in.
modrequire "patches.cave_support"

modrequire "patches.temperature"
modrequire "patches.itemtile"
modrequire "patches.actions"
modrequire "patches.physics"
modrequire "patches.nil_inventoryimage"

modrequire "patches.world_customisation_compat"

if not Reflection.HasModWithId("memspikefix") then
    --TheMod:Say("MemSpikeFix not enabled, loading 'patches.memspikefix'.")
    --Disabled because of invisible things.
    --modrequire 'patches.memspikefix'
else
    TheMod:Say("MemSpikeFix mod detected.")
end


--[[
-- Workaround for RoG tornadobrain.lua crash.
--]]
require "behaviours/leash"
