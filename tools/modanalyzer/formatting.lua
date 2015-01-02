local USE_HARDTABS = false
local TABWIDTH = 4

---

local lpeg = require "lpeg"
local Mat = pkgrequire "matching"

local loc = lpeg.locale()

---

local captures = Mat.NewCaptureSet()
local patts = Mat.NewPatternSet()

patts.ws = Mat {loc.space^1}
patts.initial_ws = Mat {"^", patts.ws}

append_map(captures, {
	ws = lpeg.C(patts.ws),
	initial_ws = lpeg.C(patts.initial_ws),
})

---

local TAB = "\t"
local SOFTTAB = (" "):rep(TABWIDTH)

local BAD_WS = TAB
local GOOD_WS = SOFTTAB

if USE_HARDTABS then
	BAD_WS, GOOD_WS = GOOD_WS, BAD_WS
end

local function process_line(line)
	local s = Mat.gsub(patts.initial_ws, line, function(ws)
		return ws:gsub(BAD_WS, GOOD_WS)
	end)
	return s
end

---

return function(code)
	for i, v in ipairs(code) do
		code[i] = process_line(v)
	end
	return code
end
