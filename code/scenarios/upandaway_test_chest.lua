local chestfunctions = require("scenarios/chestfunctions")


local function OnCreate(inst, scenariorunner)

    local items = 
    {
        {
            item = "horn",
        },
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
    }

    chestfunctions.AddChestItems(inst, items)
end

return 
{
    OnCreate = OnCreate
}
