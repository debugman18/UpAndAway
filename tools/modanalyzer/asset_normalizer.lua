local assert = assert
local tostring = tostring
local string = string
local table = table

---

local lpeg = require "lpeg"
local Mat = pkgrequire "matching"

---

local captures = Mat.NewCaptureSet()
local patts = Mat.NewPatternSet()

append_map(patts, {
	inv_img_path = Mat { "images/inventoryimages/", lpeg.C(lpeg.P(1)^1) * lpeg.P"." * (lpeg.C"xml" + lpeg.C"tex"), "" },

	--[[
	asset = patt {"Asset", "%s*", captures.arglist},
	asset_arglist = patt {"^%(", "%s*", captures.strlit, "%s*,%s*", captures.strlit, "%s*%)$"},
	]]--
})

patts.inv_img_path = lpeg.P {
	"images/inventoryimages/" * lpeg.V"prefab_name" * lpeg.V"ending",
	prefab_name = lpeg.C(lpeg.V"bare_prefab_name"),
	ending = lpeg.P"." * lpeg.C(lpeg.V"bare_ending"),

	bare_prefab_name = #(lpeg.P"." * lpeg.V"bare_ending") + 1 * lpeg.V"bare_prefab_name",
	bare_ending = (lpeg.P"xml" + lpeg.P"tex") * -lpeg.P(1),
}


local short_comment = lpeg.P{
	lpeg.V"cmnt_prefix" * lpeg.P(1)^0,
	cmnt_prefix = lpeg.P"--" + (patts.short_strlit + 1) * lpeg.V"cmnt_prefix",
}

---

local declare_asset = {}

declare_asset.IMAGE = function(prefab)
	return ("inventoryimage_texture(%q)"):format(prefab)
end

declare_asset.ATLAS = function(prefab)
	return ("inventoryimage_atlas(%q)"):format(prefab)
end

---

local process_line = (function()
	local function inv_img_path_matcher(s)
		return lpeg.match(patts.inv_img_path, s)
	end

	local function process_string(contents)
		local s = Mat.internalize(contents)
		--print("GOT ", s)
		local prefab, ext = inv_img_path_matcher(s)
		if prefab ~= nil then
			--print "YAY"
			ext = ext:lower()
			if ext == "tex" then
				return declare_asset.IMAGE(prefab)
			elseif ext == "xml" then
				return declare_asset.ATLAS(prefab)
			else
				return error("Unknown asset extension '"..ext.."'.")
			end
		else
			return ("%q"):format(s)
		end
	end

	local str_patt = lpeg.Cs(lpeg.P {
		-lpeg.P(1) + short_comment + (lpeg.V"str" + 1) * lpeg.V(1),
		str = lpeg.C(patts.short_strlit) / process_string,
	})

	return function(line)
		return lpeg.match(str_patt, line)
	end
end)()

---

return function(code)
	for i, v in ipairs(code) do
		code[i] = process_line(v)
	end
	return code
end
