function ImageAssets(suffix)
	if type(suffix) == "table" then
		return ImageAssets()(suffix)
	end

	local base = "images/"
	if suffix and #suffix > 0 then
		base = base..suffix.."/"
	end

	return function(list)
		local ret = {}

		for _, name in ipairs(list) do
			table.insert(ret, Asset(
				"ATLAS",
				base..name..".xml"
			))
			table.insert(ret, Asset(
				"IMAGE",
				base..name..".tex"
			))
		end

		return ret
	end
end

InventoryImageAssets = ImageAssets "inventoryimages"

function AnimationAssets(list)
	local ret = {}

	local base = "anim/"
	for _, name in ipairs(list) do
		table.insert(ret, Asset(
			"ANIM",
			base..name..".zip"
		))
	end

	return ret
end
