#!/usr/bin/env lua5.1

local ARGV = assert( arg )

---

local pkgdepends = {"lfs", "lpeg"}

local innerlibs = {
	"compat",
	"code",
	"matching",
}

local submodules = {
	{"formatting", {}},
	{"asset_normalizer", {}},
	{"syntax", {}},
}

local submodule_root = "modanalyzer."

---

local fs = {}
do
	local NATIVE_DIR_SEP = package.config:sub(1, 1)

	function fs.normalize(path)
		if NATIVE_DIR_SEP ~= "/" then
			path = path:gsub(NATIVE_DIR_SEP, "/")
		end
		return path:gsub("//+", "/"):gsub("/$", "")
	end

	--[[
	-- The rest assumes paths are normalized.
	--]]

	function fs.basename(path)
		local base = path:match("([^/]+)$")
		if base == nil then
			if path == "/" then
				return "."
			else
				return path
			end
		else
			return base
		end
	end

	function fs.dirname(path)
		local dir = path:match("^(.+)/[^/]+$")
		if dir == nil then
			if path == "/" then
				return "/"
			else
				return "."
			end
		else
			return dir
		end
	end
end

package.path = fs.dirname(ARGV[0]).."/?.lua;"..package.path

---

function pkgrequire(name)
	return require(submodule_root..name)
end
local pkgrequire = pkgrequire

function append_map(t, u)
	for k, v in pairs(u) do
		t[k] = v
	end
	return t
end
local append_map = append_map

function merge(...)
	local args = {...}
	local n = select("#", ...)

	local ret = {}
	for i = 1, n do
		local t = args[i]
		if t ~= nil then
			assert( type(t) == "table" )
			append_map(ret, t)
		end
	end
	return ret
end
local merge = merge

function critical_error(...)
	local args = {...}
	local nargs = select("#", ...)

	local all_nil = true
	for i = 1, nargs do
		local v = args[i]
		if v ~= nil then
			all_nil = false
		end
		args[i] = tostring(v)
	end

	if not all_nil then
		io.stderr:write( table.concat(args), "\n" )
	end
	return os.exit(1)
end

---

local failed_modules = {}

---

local function dependency_check(submodule_name, deps)
	local function empty_handler(msg)
		return msg
	end

	local old_require = _G.require
	local root_failure = nil
	_G.require = function(name)
		local status, ret = xpcall(function() return old_require(name) end, empty_handler)
		if not status then
			if not root_failure then
				root_failure = {name = name, msg = ret}
			end
			if failed_modules[name] == nil then
				failed_modules[name] = {}
			end
			failed_modules[name][root_failure.name] = root_failure.msg
			return error(ret, 0)
		else
			return ret
		end
	end

	local failures = failed_modules[submodule_name] or {}

	for _, pkgname in ipairs(deps) do
		root_failure = nil
		pcall(_G.require, pkgname)
		if failed_modules[pkgname] then
			for k, v in pairs(failed_modules[pkgname]) do
				failures[k] = v
			end
		end
	end

	_G.require = old_require

	if next(failures) ~= nil then
		failed_modules[submodule_name] = failures

		local ret = {}

		local keys = {}
		for k, v in pairs(failures) do
			ret[k] = v
			table.insert(ret, k)
		end
		for i, k in ipairs(keys) do
			table.insert(ret, k)
		end
		return ret
	end
end

local function dependency_check_string(submodule_name, deps, verbose)
	local missing = dependency_check(submodule_name, deps)
	if not missing then return end

	local pieces = {
		table.concat{"Missing dependencies for ", submodule_name, " module: ", table.concat(missing, ", "), "."},
	}

	if verbose then
		for i, k in ipairs(missing) do
			local v = assert( missing[k] )
			table.insert(pieces, v)
		end
	end

	return table.concat(pieces, "\n")
end

---

local function NewTimeMeasurer()
	local fn = os.clock
	local t0

	local function ret()
		local t = fn()
		local dt = t - t0
		t0 = t
		return dt
	end

	t0 = fn()
	return ret
end

local function time_format(dt)
	return ("%.03f seconds"):format(dt)
end

local function print_usage(fh)
	fh = fh or io.stderr

	fh:write(("Usage: %s <mod-dir>"):format(ARGV[0]), "\n")
	fh:write("\n")
	fh:write("The argument mod-dir should be the base folder of the mod to be analyzed.\n")
end

local function main()
	local target_dir = ARGV[1]
	if not target_dir then
		print_usage(io.stderr)
		os.exit(1)
	elseif target_dir == "-h" or target_dir == "--help" then
		print_usage(io.stdout)
		os.exit(0)
	end

	target_dir = assert( fs.normalize(target_dir) )

	io.write("Running mod analyzer over mod folder '", target_dir, "'...\n")

	local get_total_time = NewTimeMeasurer()

	local make_compat = pkgrequire "compat"
	make_compat(_G)

	local normalized_innerlibs = {}
	for i, v in ipairs(innerlibs) do
		normalized_innerlibs[i] = submodule_root..v
	end

	do
		dependency_check("main", pkgdepends)
		local msg = dependency_check_string("main", normalized_innerlibs, true)
		if msg then
			io.stderr:write(msg, "\n")
			os.exit(1)
		end
	end

	---

	for _, name in ipairs(normalized_innerlibs) do
		require(name)
	end

	local Code = pkgrequire "code"
	_G.Code = Code

	
	---
	
	local valid_submodules = {}

	for _, spec in ipairs(submodules) do
		local name, subdeps = unpack(spec)

		local msg = dependency_check_string(name, subdeps, false)
		if msg then
			io.stderr:write("WARNING: ", msg, "\n")
		else
			io.write("Loading submodule '", name, "'...")
			io.flush()
			local status, fn = pcall(pkgrequire, name)
			if status then
				io.write(" DONE.\n")
				assert( type(fn) == "function" )
				table.insert(valid_submodules, fn)
			else
				io.write(" ERROR!\n", fn, "\n")
			end
		end
	end

	---

	local lfs = require "lfs"

	-- dirname carries trailing slash.
	local function process_dir(dirname)
		for fname in lfs.dir(dirname) do
			if not fname:find("^%.") then
				local full_name = dirname..fname
				local stat = lfs.attributes(full_name)

				if stat.mode == "directory" then
					process_dir(full_name.."/")
				elseif stat.mode == "file" and fname:find("%.lua$") then
					local code = Code(full_name)
					for _, fn in ipairs(valid_submodules) do
						fn(code)
					end
					code:write()
				end
			end
		end
	end

	process_dir(target_dir.."/")

	---

	local total_dt = get_total_time()
	io.write("Finished running mod analyzer in ", time_format(total_dt), ".\n")
end

---

return main()
