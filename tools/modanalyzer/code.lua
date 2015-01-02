--[[
-- Patching of std functions to trigger metamethods.
--]]

pkgrequire "compat"

local rawget, rawset = rawget, rawset
local type = type
local pairs, ipairs = pairs, ipairs

---

local get_metadata
local clear_metadata
local pending_build
local build_code
local get_lines
local is_dirty
local get_full_code
do
	local metadata = setmetatable({}, {__mode = "k"})

	local function new_metadata()
		return {
			lines = nil,
			dirty = false,
			fullcode = nil,
		}
	end

	get_metadata = function(self)
		local ret = metadata[self]
		if ret == nil then
			ret = new_metadata()
			metadata[self] = ret
		end
		return ret
	end

	clear_metadata = function(self)
		metadata[self] = nil
	end

	pending_build = function(self)
		local mdata = get_metadata(self)
		return mdata.lines == nil
	end

	build_code = function(self, fh)
		if not pending_build(self) then return end

		local mdata = get_metadata(self)

		local owns_fh = true

		if fh == nil then
			fh = self.filename
			if fh == nil then
				fh = io.stdin
			end
		end

		if type(fh) == "string" then
			if not self.filename then
				self.filename = fh
			end
			fh = assert( io.open(fh, "r") )
		end

		if fh == io.stdin then
			owns_fh = false
		end

		local lines = {}
		mdata.lines = lines

		do
			local i = 1
			for l in fh:lines() do
				rawset(lines, i, l)
				i = i + 1
			end
		end

		if owns_fh then
			fh:close()
		end

		mdata.fullcode = nil
		mdata.dirty = false

		return true
	end

	get_lines = function(self)
		build_code(self)
		return get_metadata(self).lines
	end

	is_dirty = function(self)
		return get_metadata(self).dirty
	end

	get_full_code = function(self, noforce)
		build_code(self)
		local mdata = get_metadata(self)

		local ret = mdata.fullcode
		if ret == nil and not noforce then
			local L = {}
			for i, v in ipairs(get_lines(self)) do
				L[i] = v
			end
			table.insert(L, "")
			ret = table.concat(L, "\n")
			mdata.fullcode = ret
		end
		return ret
	end
end

local function write_code(self, fh)
	if fh == nil or fh == self.filename then
		if not is_dirty(self) or pending_build(self) then return end
		fh = self.filename
	end

	build_code(self)

	local owns_fh = false
	if type(fh) == "string" then
		fh = assert( io.open(fh, "w") )
		owns_fh = true
	elseif fh == nil then
		fh = io.stdout
	end

	local fullcode = get_full_code(self, true)
	if fullcode ~= nil then
		fh:write(fullcode, "\n")
	else
		local lines = get_lines(self)
		assert( type(lines) == "table" )
		for _, l in ipairs(lines) do
			fh:write(l, "\n")
		end
	end

	if owns_fh then
		fh:close()
	end
end

---

local class = {}

local code_meta = {
	__tostring = get_full_code,
	__index = function(self, k)
		local v = class[k]
		if v ~= nil then
			return v
		end

		if type(k) == "number" then
			local lines = get_lines(self)
			return rawget(lines, k)
		end
	end,
	__newindex = function(self, k, v)
		if type(k) == "number" then
			local lines = get_lines(self)
			local oldv = rawget(lines, k)
			if oldv ~= v then
				local mdata = get_metadata(self)
				mdata.dirty = true
				mdata.fullcode = nil
				return rawset(lines, k, v)
			end
		else
			return rawset(self, k, v)
		end
	end,
	__pairs = function(self)
		return pairs(get_lines(self))
	end,
	__ipairs = function(self)
		return ipairs(get_lines(self))
	end,
}

local function is_code(t)
	return getmetatable(t) == code_meta
end

local function require_code(t)
	if not is_code(t) then
		return error("Code object expected.", 3)
	end
	return t
end

---

function class:name()
	require_code(self)
	return self.filename
end

function class:dirty()
	require_code(self)
	return is_dirty(self)
end

function class:lines()
	local i = 0

	local function f(s)
		i = i + 1
		return s[i]
	end

	return f, get_lines(self)
end

function class:clear()
	require_code(self)
	clear_metadata(self)
end

function class:write(fh)
	require_code(self)
	return write_code(self, fh)
end

function class:load(env)
	require_code(self)

	local yield = coroutine.yield
	local ld = coroutine.wrap(function()
		for i, v in ipairs(get_lines(self)) do
			if #v > 0 then
				yield( v )
			end
			yield( "\n" )
		end
	end)

	return load(ld, self.filename, nil, env)
end

function class:numlines()
	require_code(self)
	return #get_lines(self)
end

--[[
function class:read(fh)
	require_code(self)
	self:clear()
	if fh ~= nil then
		self.filename = fh
	end
end
]]--

---

local function new_code(data)
	local self = {}
	if type(data) == "string" then
		self.filename = data
	elseif type(data) == "table" then
		get_metadata(self).lines = data
	else
		return error("string or table expected as constructor parameter for code object.", 2)
	end
	return setmetatable(self, code_meta)
end

---

return setmetatable(class, {
	__call = function(_, ...)
		return new_code(...)
	end,
})
