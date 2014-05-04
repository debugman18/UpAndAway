#!/usr/bin/lua

local folder_parser

local parser_stack
parser_stack = {
	function(l)
		if l:find("^%s*<entity%s") then 
			table.remove(parser_stack)
			return
		end
		if l:find("^%s*<folder%s.-[^/]>%s*$") then
			table.insert(parser_stack, folder_parser)
		end
	end,
}

folder_parser = function(l)
	if l:find("^%s*</folder>") then
		table.remove(parser_stack)
		return
	end
	local fname = l:match('%s*<file%s.-name="([^"]+)"')
	if fname then
		io.write(fname, "\n")
	end
end


local input = arg[1] and assert(io.open(arg[1], "r")) or io.stdin
for l in input:lines() do
	parser_stack[#parser_stack](l)
	if not parser_stack[1] then break end
end
if input ~= io.stdin then input:close() end
