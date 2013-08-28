local Add = {}


function Add.Names(names)
	for k, v in pairs(names) do
		STRINGS.NAMES[k:upper()] = v
	end
end


function Add.QuotesFor(prefab)
	return function(quotes)
		for k, v in pairs(quotes) do
			STRINGS.CHARACTERS[k:upper()].DESCRIBE[prefab:upper()] = v
		end
	end
end


return Add
