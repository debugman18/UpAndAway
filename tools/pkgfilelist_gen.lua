#!/usr/bin/lua
--[[
--
-- Script for generating the list of files and directories to be packaged by
-- pkg_archiver.pl.
--
-- simplex
--
--]]

local ARGV = arg


--[[
-- Returns the name of the pkginfo file.
--]]
local function ParseCmdline()
	local function print_usage(fh)
		fh = fh or io.stderr
		fh:write(
([[Usage: %s <pkginfo-file>

pkginfo-file should be a file returning a table describing what to include
in the distribution zip archive. It is assumed to be at the top level mod
directory.
]]):format(
			ARGV[0]
		))
	end

	--[[
	-- pkginfo should be the name of the pkginfo file, passed as the first
	-- (and only) parameter of the script.
	--]]
	local pkginfo = ARGV[1]
	if not pkginfo then
		print_usage()
		os.exit(1)
	elseif pkginfo == "-h" or pkginfo == "--help" then
		print_usage(io.stdout)
		os.exit(0)
	end

	return pkginfo
end

--[[
-- Returns the name of the (real) mod directory, given the pkginfo file
-- path.
--]]
local function GetModdir(pkginfo_name)
	local moddir = pkginfo_name:match("^(.-)[^/" .. package.config:sub(1,1) .. "]+$")
	if not moddir or #moddir == 0 then
		moddir = "./"
	end
	return moddir
end


--[[
-- General utitilies.
--]]

local loadfile_in_env = (function()
	if _VERSION >= "Lua 5.2" then
		return function(fname, env)
			return loadfile(fname, nil, env)
		end
	elseif _VERSION == "Lua 5.1" then
		return function(fname, env)
			local f = loadfile(fname)
			if f then
				setfenv(f, env)
			end
			return f
		end
	else
		return error("Unsupported version " .. _VERSION)
	end
end)()

local function MergeMaps(...)
	local ret = {}
	for _, t in ipairs{...} do
		for k, v in pairs(t) do
			ret[k] = v
		end
	end
	return ret
end

local function JoinArrays(...)
	local ret = {}
	for _, A in ipairs{...} do
		for _, v in ipairs(A) do
			table.insert(ret, v)
		end
	end
	return ret
end

local Asset, ExpandAsset = (function()
	local asset_key = {}

	local function asset_fn(kind, name)
		assert( type(name) == "string", "Asset file name is not a string!" )
		return {[asset_key] = name}
	end

	local function expand_fn(asset)
		local name = asset[asset_key]
		assert( type(name) == "string", "Invalid asset!" )
		return name
	end

	return asset_fn, expand_fn
end)()

local function NewBasicEnv()
	return {
		_PARSING_ENV = true,

		pairs = pairs,
		ipairs = ipairs,
		print = print,
		math = math,
		table = table,
		type = type,
		string = string,
		tostring = tostring,
	}
end

local pseudo_global_env = (function()
	local ret = MergeMaps(
		NewBasicEnv(),
		{
			assert = assert,
			error = error,
			pcall = pcall,
			debug = debug,
			tonumber = tonumber,
		}
	)

	ret._G = ret

	ret.MergeMaps, ret.JoinArrays = MergeMaps, JoinArrays

	return ret
end)()

--[[
-- modname is the mod directory, as in DS's mod environment.
--]]
local function NewParsingEnv(modname)
	local MODROOT = modname .. "/"

	local env = MergeMaps(
		NewBasicEnv(),
		{
			modname = modname,
			
			GLOBAL = pseudo_global_env,
			MODROOT = MODROOT,

			Asset = Asset,
		}
	)

	env.env = env

	env.modimport = function(fname)
		assert( loadfile_in_env(MODROOT..fname, env) )()
	end

	env.Asset = Asset

	return env
end

--[[
-- Tracks the order of variable declaration in the numerical entries.
--]]
local function NewModinfoEnv()
	local meta = {}

	local discovered_vars = {}

	function meta:__newindex(k, v)
		rawset(self, k, v)
		if type(k) == "string" and not discovered_vars[k] then
			discovered_vars[k] = true
			table.insert(self, k)
		end
	end

	meta.__index = {
		_PARSING_ENV = true,
	}

	return setmetatable({}, meta)
end

-- Turns a value x into a string.
local DumpValue = (function()
	local dovalue

	local doarray
	local dokey
	local dotable

	local function isarray(t)
		local k = nil
		for i = 1, #t do
			k = next(t, k)
			assert( k ~= nil )
		end
		return next(t, k) == nil
	end

	dovalue = function(x)
		if x == nil then return "nil" end

		local ty = type(x)
		if ty == "number" then
			if x == math.floor(x) then
				return ("%d"):format(x)
			else
				return ("%.4f"):format(x)
			end
		elseif ty == "string" then
			return ("%q"):format(x)
		elseif ty == "boolean" then
			return tostring(x)
		elseif ty == "table" then
			return dotable(x)
		else
			return error("Cannot dump value "..tostring(x).." of type "..ty..".")
		end
	end

	doarray = function(t)
		local els = {}
		for i, v in ipairs(t) do
			els[i] = dovalue(v)
		end
		return "{"..table.concat(els, ", ").."}"
	end

	dokey = function(k)
		if type(k) == "table" then
			return error("Cannot serialize a table as a key.")
		end
		if type(k) == "string" and k:find("^[_%a][_%w]*$") then
			return k
		end
		return "["..dovalue(k).."]"
	end

	dotable = function(t)
		if isarray(t) then
			return doarray(t)
		else
			local pieces = {}
			for k, v in pairs(t) do
				table.insert(pieces, dokey(k).." = "..dovalue(v))
			end
			return "{"..table.concat(pieces, ", ").."}"
		end
	end

	return dovalue
end)()

--[[
-- Returns a modinfo parsed in the environment as a string corresponding to a file.
--]]
local function DumpModinfo(modinfo)
	local chunks = {}
	for _, varname in ipairs(modinfo) do
		if type(varname) ~= "string" then
			return error("Modinfo key "..tostring(varname).." is not a string!")
		end
		table.insert(chunks, varname.." = "..DumpValue(modinfo[varname]))
	end
	table.insert(chunks, "")
	return table.concat(chunks, "\n")
end


--[[
-- Actual work.
--]]

--[[
-- Prints the packaging info to fh.
--]]
local function ProcessPkginfo(pkginfo_name, fh)
	local moddir = GetModdir(pkginfo_name)
	fh = fh or io.stdout

	local parsing_env = NewParsingEnv(moddir:sub(1, -2))

	local function parse_modfile(name)
		return assert(loadfile_in_env( moddir..name, parsing_env ))()
	end

	local function parse_modinfo()
		local modinfo = NewModinfoEnv()
		assert(loadfile_in_env( moddir.."modinfo.lua", modinfo ))()
		return modinfo
	end


	local pkginfo = assert(loadfile_in_env( pkginfo_name, NewBasicEnv() ))()
	assert( type(pkginfo) == "table", ("File %s didn't return a table."):format(pkginfo_name) )

	
	local modinfo
	if pkginfo.modinfo_filter then
		modinfo = parse_modinfo()
		modinfo = pkginfo.modinfo_filter(modinfo)
	end


	fh:write("# Package mod dir\n")
	fh:write(pkginfo.moddir, "\n")

	fh:write("\n")

	fh:write("# Directives.", "\n")
	fh:write("%CD ", moddir, "\n")

	fh:write("\n")

	fh:write("# Excluded suffixes\n")
	for _, ext in ipairs(pkginfo.exclude_extensions) do
		fh:write("!.", ext, "\n")
	end

	fh:write("\n")

	fh:write("# Assets\n")
	do
		local file_cache = {}
		for _, asset_file in ipairs(pkginfo.asset_files) do
			for _, asset in ipairs( parse_modfile(asset_file) ) do
				local fname = ExpandAsset(asset)
				if not file_cache[fname] then
					file_cache[fname] = true
					fh:write( ExpandAsset(asset), "\n" )
				end
			end
		end
	end

	fh:write("\n")

	fh:write("# Prefabs\n")
	do
		local PREFAB_ROOT = "scripts/prefabs/"

		local file_cache = {}
		for _, prefab_filelist in ipairs(pkginfo.prefab_files) do
			for _, prefab_file in ipairs( parse_modfile(prefab_filelist) ) do
				assert( type(prefab_file) == "string", "String expected as prefab file name." )
				if not file_cache[prefab_file] then
					file_cache[prefab_file] = true
					fh:write( PREFAB_ROOT..prefab_file..".lua", "\n" )
				end
			end
		end
	end

	fh:write("\n")

	fh:write("# Extra\n")
	for _, extra in ipairs(pkginfo.extra) do
		if not modinfo or extra ~= "modinfo.lua" then
			fh:write(extra, "\n")
		end
	end

	fh:write("\n")

	fh:write("# Empty dirs\n")
	for _, dir in ipairs(pkginfo.empty_directories) do
		fh:write("%EMPTY ", dir, "\n")
	end

	if modinfo then
		local modinfo_str = DumpModinfo(modinfo)

		fh:write("\n")

		fh:write("# Custom modinfo\n")
		fh:write("%OCTET STREAM ", tostring(#modinfo_str), " ", "modinfo.lua\n")
		fh:write(modinfo_str)
	end
end


---------------------------------------------------------------------


--[[
-- Execution.
--]]

ProcessPkginfo(ParseCmdline(), io.stdout)
