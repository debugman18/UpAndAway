local env = {}

---

local function get_line_fmt_string(code)
	local n = code:numlines()

	local digits = 1 + math.floor(math.log(n, 10))

	return "%"..("%02d"):format(digits).."d"
end

return function(code)
	if not code:dirty() then return code end

	local fn, msg = code:load(env)
	if not fn then
		io.stdout:write("File '", code:name(), "' failed to load:\n", msg, "\n")

		io.stdout:write("\nCode:\n")

		local faulty_line = msg:match("^%b[]:(%d+):")
		if not faulty_line then
			faulty_line = msg:match("(%d+)")
		end
		if faulty_line then
			faulty_line = tonumber(faulty_line)
		end

		local line_fmt = get_line_fmt_string(code)

		for i, v in ipairs(code) do
			local prefix = (i == faulty_line) and "X" or " "
			io.stdout:write( prefix, " ", line_fmt:format(i), ": ", v, "\n" )
		end

		return critical_error()
	end
	return code
end
