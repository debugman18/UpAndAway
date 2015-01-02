local assert = assert
local tostring = tostring
local string = string
local table = table

local getmetatable, setmetatable = getmetatable, setmetatable
local select = select

---

local lpeg = require "lpeg"

---

local function anywhere(patt)
	return lpeg.P{ patt + lpeg.P(1) * lpeg.V(1) }
end

local patt = (function()
	local expand_patt_spec = (function()
		local function mul(a, b)
			if a == nil then
				return b
			elseif b == nil then
				return a
			else
				return a * b
			end
		end

		local function add(a, b)
			if a == nil then
				return b
			elseif b == nil then
				return a
			else
				return a + b
			end
		end

		local function visit(spec_el, p, concat_op)
			if type(spec_el) == "table" and getmetatable(spec_el) == nil then
				if #spec_el == 0 and concat_op == mul then
					return p
				else
					local alternator = nil
					for _, sub_spec_el in ipairs(spec_el) do
						alternator = visit(sub_spec_el, alternator, add)
					end
					return concat_op(p, alternator)
				end
			else
				if spec_el == "" and concat_op == mul then
					return p
				else
					return concat_op(p, lpeg.P(spec_el))
				end
			end
		end

		return function(spec)
			local start_anchored = false
			local end_anchored = false

			if type(spec) == "table" then
				if type(spec[1]) == "string" then
					start_anchored = (spec[1]:sub(1, 1) == "^")
					if start_anchored then
						spec[1] = spec[1]:sub(2)
					end
				end

				if type(spec[#spec]) == "string" then
					end_anchored = (spec[#spec]:sub(-1) == "$")
					if end_anchored then
						spec[#spec] = spec[#spec]:sub(1, -2)
					end
				end
			end

			local p = nil
			for _, spec_el in ipairs(spec) do
				p = visit(spec_el, p, mul)
			end
			p = p or lpeg.P(0)

			if end_anchored then
				p = p * (-lpeg.P(1))
			end

			if start_anchored then
				p = (-lpeg.B(1)) * p
			end

			return p
		end
	end)()

	local function new(spec)
		if type(spec) ~= "table" then
			spec = {spec}
		end
		return expand_patt_spec(spec)
	end

	return new
end)()

local function new_balanced_patt(boundaries, nestable, inner_patt)
	assert(#boundaries == 2 or #boundaries == 1)

	local b1 = boundaries:sub(1, 1)
	local b2
	if #boundaries == 1 then
		b2 = b1
	else
		b2 = boundaries:sub(2, 2)
	end

	if inner_patt == nil then
		inner_patt = 1 - lpeg.S(boundaries)
	end

	if nestable then
		inner_patt = inner_patt + lpeg.V(1)
	end

	return lpeg.P{ lpeg.P(b1) * inner_patt^0 * lpeg.P(b2) }
end

local function new_shortstrlit_patt(char)
	assert(#char == 1)

	local forbidden_chars = "\r\n\f\\"..char

	local inner_patt = (1 - lpeg.S(forbidden_chars)) + (lpeg.P"\\" * 1)

	return new_balanced_patt(char, false, inner_patt)
end

local dquoted_strlit = new_shortstrlit_patt "\""
local squoted_strlit = new_shortstrlit_patt "'"

local patts = {
	short_strlit = patt {dquoted_strlit + squoted_strlit},
	arglist = patt {new_balanced_patt("()", true)},
	table = patt {new_balanced_patt("{}", true)},
}

local captures = {}
for k, v in pairs(patts) do
	captures[k] = patt{ lpeg.C(v) }
end

---

local function shallow_copier(t)
	return function()
		local u = {}
		for k, v in pairs(t) do
			u[k] = v
		end
		return u
	end
end

---

local internalize = (function()
	local env = {}

	local assert = assert( assert )
	local load = assert( load )

	return function(str)
		return assert( assert( load("return "..str, nil, nil, env) )() )
	end
end)()

---

local _M = {}

_M.patt = patt
_M.NewPattern = patt

_M.NewCaptureSet = shallow_copier(captures)
_M.NewPatternSet = shallow_copier(patts)

_M.internalize = internalize
_M.load = internalize

---

local function process_match_results(substr, first_match, ...) 
	if first_match == nil then
		if substr then
			print("ss '"..substr.."'")
		else
			print "NOMATCH"
		end
		return substr
	else
		print("fm", first_match)
		return first_match, ...
	end
end

function _M.match(patt, s)
	local p = lpeg.C(anywhere(patt))
	if s then
		return process_match_results( lpeg.match(p, s) )
	else
		return function(s)
			return process_match_results( lpeg.match(p, s) )
		end
	end
end

function _M.gsub(patt, s, repl)
	local p = lpeg.Cs((patt / repl + 1)^0)

	if s then
		return lpeg.match(p, s)
	else
		return function(s)
			return lpeg.match(p, s)
		end
	end
end

do
	local function co_body(patt, s)
		coroutine.yield()
		lpeg.match(patt, s)
	end

	function _M.gmatch(patt, s)
		local p = lpeg.P((patt / coroutine.yield + 1)^0)
		local f = coroutine.wrap(co_body)
		f(p, s)
		return f
	end
end

---

return setmetatable(_M, {
	__call = function(_M, p, s, repl)
		if s == nil and repl == nil then
			return patt(p)
		else
			assert(type(s) == "string")
			if repl ~= nil then
				return _M.gsub(p, s, repl)
			else
				return _M.match(p, s)
			end
		end
	end,
})
