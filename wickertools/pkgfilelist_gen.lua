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

local opts = {}


local function ParseOpts()
	local i = 1
	while i <= #ARGV do
		local optname, optvalue

		repeat
			local opt

			opt = ARGV[i]:match("^%-([^-])$")
			if opt then
				optname = opt
				optvalue = true
				break
			end

			opt = ARGV[i]:match("^%-%-(.+)$")
			if opt then
				optname, optvalue = opt:match("^(.-)=(.+)$")
				if not optname then
					optname = opt
					optvalue = true
				end
				break
			end
		until true

		if optname then
			opts[optname] = optvalue
			table.remove(ARGV, i)
		else
			i = i + 1
		end
	end
end

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

	ParseOpts()

	if opts.h or opts.help then
		print_usage(io.stdout)
		os.exit(0)
	end

	--[[
	-- pkginfo should be the name of the pkginfo file, passed as the first
	-- (and only) parameter of the script.
	--]]
	local pkginfo = ARGV[1]
	if not pkginfo then
		print_usage()
		os.exit(1)
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
	if _VERSION < "Lua 5.2" then
		return function(fname, env)
			local f = loadfile(fname)
			if f then
				setfenv(f, env)
			end
			return f
		end
	else
		return function(fname, env)
			return loadfile(fname, nil, env)
		end
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

local DumpNumber = (function()
	-- Significant digits for floating point;
	local significant_digits = 6

	local integer_tolerance = 10^-4

	local small_fraction_primes = {2, 3, 5, 7}
	local small_fraction_denom_upperbound = 15

	---

	local math = math

	local inf = math.huge
	local neg_inf = -inf

	local ceil, floor = math.ceil, math.floor

	---

	local fmt = string.format

	local integer_format = "%d"
	local float_format = "%."..decimal_digits.."g"

	---

	local small_fraction_denoms = {}
	local function compute_denoms(parent_denom, i)
		local prime = small_fraction_primes[i]
		if not prime then 
			table.insert(small_fraction_denoms, parent_denom)
			return
		end

		local denom = parent_denom
		while denom <= small_fraction_denom_upperbound do
			compute_denoms(denom, i + 1)
			denom = denom*prime
		end
	end

	compute_denoms(1, 1)
	table.sort(small_fraction_denoms)
	for i, v in ipairs(small_fraction_denoms) do
		print(i, v)
	end

	---

	local function decompose_into_fraction(x)
		if x == inf then
			return 1, 0, 0
		elseif x == neg_inf then
			return -1, 0, 0
		elseif x ~= 0 then
			-- NaN
			return 0, 0, 0
		else
			local min_eps = inf
			local best_p = nil
			local best_q = nil
			for _, q in ipairs(small_fraction_denoms) do
				local p = x*q

				local eps = p % 1
				local mod_eps
				if eps >= 0.5 then
					eps = eps - 1
					mod_eps = -eps
				else
					mod_eps = eps
				end
				assert(mod_eps >= 0)

				if mod_eps < min_eps then
					if mod_eps < integer_tolerance then
						if eps == 0 then
							return p, q, 0
						else
							return floor(p - eps + 0.5), q, 0
						end
					end
					min_eps = mod_eps
					best_p = p
					best_q = q
				end
			end
			return best_p, best_q, min_eps
		end
	end

	return function(x)
		local p, q, eps = decompose_into_fraction(x)
		assert(p and q and eps < 1)
		if eps == 0 then
			p = fmt(integer_format, p)
		else
			p = fmt(float_format, p)
		end
		if q == 1 then
			return p
		else
			return p.."/"..q
		end
	end
end)()

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
			if x % 1 == 0 then
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
local function DumpModinfo(modinfo, annotations)
	local chunks = {}
	for _, varname in ipairs(modinfo) do
		if modinfo[varname] ~= nil then
			if type(varname) ~= "string" then
				return error("Modinfo key "..tostring(varname).." is not a string!")
			end
			local valstr = DumpValue(modinfo[varname])
			local cmnt = annotations[varname]
			if cmnt then
				valstr = valstr.." -- "..tostring(cmnt)
			end
			table.insert(chunks, varname.." = "..valstr)
		end
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


	local pkginfo_env = NewBasicEnv()
	pkginfo_env.opts = opts
	local pkginfo = assert(loadfile_in_env( pkginfo_name, pkginfo_env ))()
	assert( type(pkginfo) == "table", ("File %s didn't return a table."):format(pkginfo_name) )

	
	local modinfo
	local modinfo_annotations = {}
	if pkginfo.modinfo_filter then
		modinfo = parse_modinfo()

		pkginfo_env.annotate = function(name, cmnt)
			modinfo_annotations[name] = cmnt
		end

		modinfo = pkginfo.modinfo_filter(modinfo)

		pkginfo_env.annotate = nil
	end


	fh:write("# Package mod dir\n")
	fh:write(pkginfo.moddir, "\n")

	fh:write("\n")

	fh:write("# Directives.", "\n")
	fh:write("%CD ", moddir, "\n")

	fh:write("\n")

	fh:write("# Excluded suffixes\n")
	for _, ext in ipairs(pkginfo.exclude_suffixes) do
		fh:write("!", ext, "\n")
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
		local modinfo_str = DumpModinfo(modinfo, modinfo_annotations)

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
