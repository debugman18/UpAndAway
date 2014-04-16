---
-- Loads the patches submodules.
--


modrequire 'patches.temperature'
modrequire 'patches.itemtile'
modrequire 'patches.actions'
modrequire 'patches.physics'
modrequire 'patches.nil_inventoryimage'

modrequire 'patches.world_customisation_compat'


--[[
-- Workaround for RoG tornadobrain.lua crash.
--]]
require "behaviours/leash"
