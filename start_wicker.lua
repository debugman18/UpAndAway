--[[
-- File uniformizing wicker startup between modmain.lua and modworldgenmain.lua
--
-- Returns TheMod.
--]]

GLOBAL.assert(use, "Call modimport on lib/use.lua first!")

return use('wicker.init')(env, {
	id = modinfo.id,

	modcode_root = "code",


	import = use,

	debug = true,
})
