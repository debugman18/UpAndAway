local getmetatable, setmetatable = GLOBAL.getmetatable, GLOBAL.setmetatable

TUNING.UPANDAWAY = TUNING.UPANDAWAY or {}

local cfg_env = setmetatable({
	TUNING = TUNING,
	STRINGS = STRINGS,
	string = string,
	math = math,
	table = table,
	ipairs = ipairs,
	pairs = pairs,
	unpack = unpack,
	select = select,
	getmetatable = getmetatable,
	setmetatable = setmetatable,
	tostring = tostring,
},
{
	__index = TUNING.UPANDAWAY,
	__newindex = TUNING.UPANDAWAY,
})

function LoadConfigurationFunction(f)
	GLOBAL.setfenv(f, cfg_env)
	f()
end

function LoadConfigurationFile(file_name)
	local f = GLOBAL.kleiloadlua(MODROOT .. file_name)
	if type(f) ~= "function" then
		local err_msg = "Error loading configuration file `" .. tostring(file_name) .. "': "
		if not f then
			err_msg = err_msg .. "it doesn't exist."
		else
			err_msg = err_msg .. tostring(f)
		end
		return GLOBAL.error(err_msg)
	end

	LoadConfigurationFunction(f)
end
