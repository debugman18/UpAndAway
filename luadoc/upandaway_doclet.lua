local html = require "luadoc.doclet.html"

local ipairs, pairs = ipairs, pairs
local table = require "table"
local print = print

-- Directory separator characters.
local ds_chars = "/" .. package.config:sub(1,1)


module(...)

-- Name of the dir inside scripts/
local _modname = "upandaway"

-- doc: table with processed input.
function start(doc)
	-- File names split into two parts: the one before scripts/, and the one after.
	-- Neither includes scripts, properly speaking.
	--
	-- The suffix is the key.
	local split_names = {}

	-- Indexes in doc.files to remove
	local bad_indexes = {}

	for i, filepath in ipairs(doc.files) do
		filepath:gsub("[" .. ds_chars .. "]", "/")

		--print("Processing " .. filepath)

		local pre, suf = filepath:match( "^(.-)/scripts/(.+)$" )
		if not suf then
			suf = filepath:match( "^scripts/(.+)$" )
		end
		if not suf then
			suf = filepath
		end
		if not pre then
			pre = ""
		end
		split_names[suf] = {i = i, pre = pre}
	end

	for suf, data in pairs(split_names) do
		local evil_twin = split_names[_modname .. "/" .. suf]
		if evil_twin and evil_twin.pre == data.pre then
			table.insert(bad_indexes, data.i)
		end
	end

	table.sort(bad_indexes)

	for i = #bad_indexes, 1, -1 do
		local removed = table.remove(doc.files, bad_indexes[i])
		doc.files[removed] = nil
		--print("Removed ", removed)
	end

	html.options = options
	html.logger = logger

	return html.start(doc)
end


return _M
