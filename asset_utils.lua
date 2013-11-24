local function NewAssetInserter(kind, extension, base)
	base = base and #base > 0 and (base.."/") or ""

	local function inserter(infix)
		if type(infix) == "table" then
			return inserter()(infix)
		end

		local prefix = base

		if infix and #infix > 0 then
			prefix = base..infix.."/"
		end

		return function(list)
			local ret = {}

			for _, name in ipairs(list) do
				table.insert(ret, Asset(
					kind,
					prefix..name.."."..extension
				))
			end

			return ret
		end
	end

	return inserter
end

local function Combine(f, g)
	if type(f) == "table" and type(g) == "table" then
		return GLOBAL.JoinArrays(f, g)
	end
	return function(...)
		local f2, g2 = f, g

		if type(f) == "function" then
			f2 = f(...)
		end
		if type(g) == "function" then
			g2 = g(...)
		end

		return Combine(f2, g2)
	end
end


ImageAtlases = NewAssetInserter("ATLAS", "xml", "images")
ImageTextures = NewAssetInserter("IMAGE", "tex", "images")
ImageAssets = Combine(ImageAtlases, ImageTextures)

InventoryImageAtlases = ImageAtlases "inventoryimages"
InventoryImageTextures = ImageTextures "inventoryimages"
InventoryImageAssets = ImageAssets "inventoryimages"

AnimationAssets = NewAssetInserter("ANIM", "zip", "anim")
