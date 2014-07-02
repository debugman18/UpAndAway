BindGlobal()


local Configurable = wickerrequire 'adjectives.configurable'

local MakeBeverage = pkgrequire 'common.hotbeverage'

local cfg = Configurable("HOTBEVERAGE", "TEA")


--[[
-- Basic tea data, as used by MakeBeverage.
--]]
local basic_tea_data = {
	bank = "tea",

	perish_time = cfg:GetConfig("PERISH_TIME"),
	heat_capacity = cfg:GetConfig("HEAT_CAPACITY"),
}

--[[
-- Specific tea data.
--]]
local tea_data = {
	greentea = MergeMaps(basic_tea_data, {
		name = "greentea",

		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/greentea.xml",

		health = TUNING.HEALING_SMALL,
		sanity = TUNING.SANITY_TINY,

		temperature = 80,
	}),

	blacktea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/blacktea.xml",

		health = TUNING.HEALING_TINY,
		sanity = TUNING.SANITY_SMALL,

		temperature = 100,
	}),

	whitetea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/whitetea.xml",

		health = TUNING.HEALING_SMALL,
		sanity = TUNING.SANITY_SMALL,

		temperature = 90,
	}),

	petaltea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/petaltea.xml",

		health = 5,
		sanity = 5,

		temperature = 60,
	}),

	evilpetaltea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/evilpetaltea.xml",

		health = 8,
		sanity = -10,

		temperature = 60,
	}),

	mixedpetaltea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/mixedpetaltea.xml",

		health = 5,
		sanity = -2,

		temperature = 60,
	}),

	floraltea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/floraltea.xml",

		health = 0,
		sanity = 10,

		temperature = 70,
	}),

	berrytea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/berrytea.xml",

		health = 5,
		sanity = 10,

		temperature = 60,
	}),

	berrypulptea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/berrypulptea.xml",

		health = 2,
		hunger = 10,

		temperature = 40,
	}),

	skypetaltea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/skypetaltea.xml",

		health = -12,
		sanity = 18,

		temperature = 60,
	}),

	daturatea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/daturatea.xml",

		health = 20,
		sanity = -10,

		temperature = 60,
	}),

	greenertea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/greenertea.xml",

		health = 30,
		sanity = -20,

		temperature = 60,
	}),

	cloudfruittea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/cloudfruittea.xml",

		hunger = 10,
		health = 10,

		temperature = 30,
	}),

	cottontea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/cottontea.xml",

		hunger = 5,
		sanity = 5,

		temperature = 60,
	}),

	candytea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/candytea.xml",

		health = -10,
		sanity = 20,

		temperature = 50,
	}),

	goldtea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		inventory_atlas = "images/inventoryimages/goldtea.xml",

		health = 0,
		sanity = 20,

		temperature = 70,
	}),

	chaitea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		--inventory_atlas = "images/inventoryimages/blacktea.xml",

		health = TUNING.HEALING_TINY,
		sanity = TUNING.SANITY_SMALL,

		temperature = 100,
	}),

	oolongtea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		--inventory_atlas = "images/inventoryimages/blacktea.xml",

		health = TUNING.HEALING_TINY,
		sanity = TUNING.SANITY_SMALL,

		temperature = 100,
	}),

	spoiledtea = MergeMaps(basic_tea_data, {
		assets = {
			Asset("ANIM", "anim/tea.zip"),
		},

		build = "tea",
		anim = "tea",
		--inventory_atlas = "images/inventoryimages/blacktea.xml",

		health = -20,
		sanity = -10,

		temperature = 90,
	}),

}


local basic_teas = (function()
	local ret = {}
	for k in pairs(tea_data) do
		table.insert(ret, k)
	end
	return ret
end)()


for _, tea in ipairs(basic_teas) do
	local sweet_tea = "sweet_"..tea
	tea_data[sweet_tea] = MergeMaps(tea_data[tea], {
		hunger = TUNING.CALORIES_SMALL,
	})
	if STRINGS.NAMES[tea:upper()] then
		STRINGS.NAMES[sweet_tea:upper()] = "Sweet "..STRINGS.NAMES[tea:upper()]
	end
end


local tea_prefabs = {}
for tea, data in pairs(tea_data) do
	table.insert(tea_prefabs, MakeBeverage(tea, data))
end

return tea_prefabs
