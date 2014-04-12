local chestfunctions = require("scenarios/chestfunctions")


local function OnCreate(inst, scenariorunner)

	local items = 
	{
		{
			item = "goldenshovel",
		},
		{
			item = "hambat",
		},
		{
			item = "armorwood",
		},
		{
			item = "trunkvest_winter",
		},
		{
			item = "beefalohat",
		},
		{
			item = "log",
			count = 20,
		},
		{
			item = "flint",
			count = 40,
		},
		{
			item = "cutgrass",
			count = 40,
		},
		{
			item = "twigs",
			count = 40
		},
	}

	chestfunctions.AddChestItems(inst, items)
end

return 
{
	OnCreate = OnCreate
}
