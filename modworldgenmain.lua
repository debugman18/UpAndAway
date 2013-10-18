local rawget = GLOBAL.rawget


local IS_WGEN = (rawget(GLOBAL, "SEED") ~= nil)


local run_handler = (function()
		if IS_WGEN then
				return GLOBAL.xpcall
		else
				return function(f) return true, f() end
		end
end)()


local status, err = run_handler(function()
	TheMod = GLOBAL.require("upandaway" .. '.wicker.init')(env)

	-- This enables us to access configurations through TUNING.UPANDAWAY (for backwards compatibility)
	TheMod:AddMasterConfigurationKey("UPANDAWAY")
	GLOBAL.assert( TUNING.UPANDAWAY )

	TheMod:Run("worldgen_main")
end, GLOBAL.require("debug").traceback)


if IS_WGEN and not status then GLOBAL.pcall(function()
	local io = GLOBAL.require("io")
	local os = GLOBAL.require("os")
	
	local now = os.date("%x %X")
	
	local f = io.open(MODROOT .. "log/worldgen_log.txt", "w")

	if status then
		f:write("[", now, "] The mod ran successfully.\n")
	else
		f:write("[", now, "] The mod failed to run. The error follows:\n")
		f:write(err, "\n")
	end

	f:close()
end) end


if not status then return GLOBAL.error(err, 0) end
