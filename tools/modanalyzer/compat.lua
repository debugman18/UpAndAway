local _G = _G

local assert = _G.assert( assert )
local _VERSION = assert( _VERSION )

local AT_LEAST_52 = (_VERSION >= "Lua 5.2")

---

local getmetatable = getmetatable

---

local function shallow_copy(t)
	local u = {}
	for k, v in pairs(t) do
		u[k] = v
	end
	return u
end

---

local patches = {}

---

patches.table = {}

function patches.table.insert()
	return function(t, pos, v)
		if v == nil then
			t[#t + 1] = pos
			return
		end
		for i = #t + 1, pos + 1, -1 do
			t[i] = t[i - 1]
		end
		t[pos] = v
	end
end

function patches.table.remove()
	return function(t, pos)
		if pos == nil then
			local l = #t
			local v = t[l]
			t[l] = nil
			return v
		end

		local v = t[pos]

		for i = pos, #t do
			t[i] = t[i + 1]
		end

		return v
	end
end

---

function patches.ipairs(ipairs)
	if AT_LEAST_52 then
		return ipairs
	end
	return function(t)
		local meta = getmetatable(t)
		if meta == nil then
			return ipairs(t)
		end
		local custom_ipairs = rawget(meta, "__ipairs")
		if custom_ipairs == nil then
			return ipairs(t)
		end
		return custom_ipairs(t)
	end
end

function patches.pairs(pairs)
	if AT_LEAST_52 then
		return pairs
	end
	return function(t)
		local meta = getmetatable(t)
		if meta == nil then
			return pairs(t)
		end
		local custom_pairs = rawget(meta, "__pairs")
		if custom_pairs == nil then
			return pairs(t)
		end
		return custom_pairs(t)
	end
end

function patches.load(load)
	if AT_LEAST_52 then
		return load
	end
	local assert = assert( assert )
	local type = assert( type )
	local setfenv = assert( setfenv )
	local loadstring = assert( loadstring )
	return function(ld, source, mode, env)
		local fn, msg
		if type(ld) == "string" then
			fn, msg = loadstring(ld, source)
			if not fn then return fn, msg end
		else
			fn, msg = load(ld, source)
			if not fn then return fn, msg end
		end

		if env ~= nil then
			setfenv(fn, env)
		end

		return fn
	end
end

patches.math = {}

function patches.math.log(log)
	if AT_LEAST_52 then
		return log
	end
	return function(x, b)
		if b ~= nil then
			return log(x)/log(b)
		else
			return log(x)
		end
	end
end

---

local function apply_patches(subenv, subpatches, is_global, is_top_level)
	local retenv = subenv

	for k, patch in pairs(subpatches) do
		local v = retenv[k]
		--assert(v ~= nil)
		if type(patch) == "table" then
			retenv[k] = apply_patches( v, patch, is_global, false )
		else
			assert(type(patch) == "function")
			local newv = patch(v)
			if newv ~= v then
				if retenv == subenv and not (is_top_level or is_global) then
					print "copy"
					retenv = shallow_copy(subenv)
				end
				retenv[k] = newv
			end
		end
	end

	return retenv
end

local function MakeEnvCompat(env)
	local is_global = (env == _G)

	if not env.unpack then
		env.unpack = env.table and env.table.unpack
	end
	if env.table and not env.table.unpack then
		env.table.unpack = env.unpack
	end

	return apply_patches(env, patches, is_global, true)
end

---

return MakeEnvCompat
