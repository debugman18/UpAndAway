local METADATA_FILE_NAME = "upandaway_cave_support_metadata"

---

if IsWorldgen() then
	local storage_error = Lambda.Error("Storage support is not available at worldgen.")
	return {
		SaveMetadata = storage_error,
		LoadMetadata = storage_error,
	}
end

---

require "dumper"

local function encode(data)
	local ret = _G.DataDumper(data)
	if type(ret) ~= "string" then
		return error("string expected as result of dumping metadata, got "..tostring(ret))
	end
	return ret
end

local function decode(str)
    assert( type(str) == "string", "string expected as stored modinfo" )
    local fn = assert( loadstring(str) )

    local env = {}
    setfenv(fn, env) -- runs it in an empty environment

    local ret = fn()

    if not str:find("^return ") then
        ret = env
    end

	if type(ret) ~= "table" then
		return error("table expected as result of loading metadata persistent string, got "..tostring(ret))
	end

    return ret
end

local function do_save(data)
	require "mainfunctions"
	_G.SavePersistentString(METADATA_FILE_NAME, encode(data))
end

local function do_load(cb)
	local loaded_str = nil

	TheSim:GetPersistentString(METADATA_FILE_NAME, function(load_success, str)
		local status = load_success and type(str) == "string" and #str > 0
		if status then
			loaded_str = str
		end
		if cb ~= nil then
			cb(loaded_str)
		end
	end)

	if loaded_str ~= nil then
		return decode(loaded_str)
	end
end

---

local cached_metadata = nil

function SaveMetadata(data)
	cached_metadata = data
	do_save( data )
end

function LoadMetadata(cb)
	if cached_metadata ~= nil then
		if cb ~= nil then
			cb(cached_metadata)
		end
		return cached_metadata
	end

	local ret = do_load(cb)
	if ret == nil then
		ret = {}
	end
	cached_metadata = ret
	return ret
end
