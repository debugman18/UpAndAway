BindGlobal()

require("constants")
local StaticLayout = require("map/static_layout")

return {
    Sandbox = {
        Any = {
            --[[
            ["UpMagnetBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
                    areas = {
                        item_area = function() return PickSome(1, {"magnet"}) end,							
                        resource_area = function() return PickSomeWithDups(math.random(3,5), {"gears"}) end,
                        },
                }),
            ["UpCottonBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
                    areas = {
                        item_area = function() return PickSome(1, {"cotton_hat","cotton_vest"}) end,							
                        resource_area = function() return PickSomeWithDups(math.random(3,5), {"cloud_cotton","cloud_cotton","cloud_cotton","silk","silk"}) end,
                        },
                }),
            ["UpAlchemyBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
                    areas = {
                        item_area = function() return PickSome(1, {"bonestew"}) end,							
                        resource_area = function() return PickSomeWithDups(math.random(3,5), {"nightmarefuel", "nightmarefuel", "nightmarefuel"}) end,
                        },
                }),
            ["UpBeansBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
                    areas = {
                        item_area = function() return  nil end,							
                        resource_area = function() return PickSomeWithDups(math.random(3,5), {"greenbean"}) end,
                        },
                }),
            ]]--
        },
        Rare = {},
    },
}
