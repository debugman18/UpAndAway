local chestfunctions = require("scenarios/chestfunctions")


local function OnCreate(inst, scenariorunner)

	local items = 
	{
		{
			item = "goldnugget",
			count = 8,
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
		{
			item = "mandrake",
			count = 5,
		},
	}

	chestfunctions.AddChestItems(inst, items)
end

return 
{
	OnCreate = OnCreate
}
