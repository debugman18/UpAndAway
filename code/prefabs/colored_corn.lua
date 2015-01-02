BindGlobal()

local MakeWildCrop = pkgrequire "common.wild_crop"
local Prob = wickerrequire "math.probability"

local prefabs_table = MakeWildCrop {
    name = "colored_corn",

    assets = {
        Asset("ANIM", "anim/colored_corn.zip"),
    },

    prefabs = {
        "gemcorn",
    },

    product = "gemcorn",

    build = "colored_corn",
    bank = "colored_corn",

    anims = {
        --idle = "idle", -- This is optional, since it defaults to "idle".
        empty = "idle_empty",
        normal = "idle_normal",
        growing = "idle_growing",
        ripe = "idle_ripe",
        harvested = "idle_harvested",
        rotten = "idle_rotten",

        picking = "picking", -- Optional, if not given no animation is played.
    },

    -- These are the default values, but can be customized.
    --[[
    sounds = {
        growth = "dontstarve/forest/treeGrow",
        picking = "dontstarve/wilson/pickup_reeds",
    },
    ]]--

    -- growth times _in days_ from the previous state.
    times = {
        tonormal = Prob.RandomRange(1, 2),
        togrowing = Prob.RandomRange(1, 5),
        toripe = Prob.RandomRange(1, 3),
    },
}
return prefabs_table
