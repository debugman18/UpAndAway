BindGlobal()


local Configurable = wickerrequire "adjectives.configurable"

local MakeBeverage = pkgrequire "common.beverage"

local cfg = Configurable("BEVERAGE", "TEA")

-- There's some issues with this animation on characters that aren't Wes.
local function drink_anim(inst, eater)
    eater.AnimState:PlayAnimation("mime8", false)
end

-- oneatenfn for ambrosia tea.
local function ambrosiafn(inst, eater)
    drink_anim(inst, eater)
    if math.random() < 0.1 then
        if eater.components.ambrosiarespawn then
            TheMod:DebugSay("Free respawn. Lucky you.")
            eater.components.ambrosiarespawn:Enable()
        end	
    end	
end	

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
        anim = "greentea",
        inventory_atlas = inventoryimage_atlas("greentea"),

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
        inventory_atlas = inventoryimage_atlas("blacktea"),

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
        inventory_atlas = inventoryimage_atlas("whitetea"),

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
        inventory_atlas = inventoryimage_atlas("petaltea"),

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
        inventory_atlas = inventoryimage_atlas("evilpetaltea"),

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
        inventory_atlas = inventoryimage_atlas("mixedpetaltea"),

        health = 5,
        sanity = -2,

        temperature = 60,
    }),

    floraltea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "floraltea",
        inventory_atlas = inventoryimage_atlas("floraltea"),

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
        inventory_atlas = inventoryimage_atlas("berrytea"),

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
        inventory_atlas = inventoryimage_atlas("berrypulptea"),

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
        inventory_atlas = inventoryimage_atlas("skypetaltea"),

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
        inventory_atlas = inventoryimage_atlas("daturatea"),

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
        inventory_atlas = inventoryimage_atlas("greenertea"),

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
        inventory_atlas = inventoryimage_atlas("cloudfruittea"),

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
        inventory_atlas = inventoryimage_atlas("cottontea"),

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
        inventory_atlas = inventoryimage_atlas("candytea"),

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
        inventory_atlas = inventoryimage_atlas("goldtea"),

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
        inventory_atlas = inventoryimage_atlas("chaitea"),

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
        inventory_atlas = inventoryimage_atlas("oolongtea"),

        health = TUNING.HEALING_TINY,
        sanity = TUNING.SANITY_SMALL,

        temperature = 100,
    }),

    redmushroomtea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("redmushroomtea"),

        health = TUNING.HEALING_TINY,
        sanity = -TUNING.SANITY_SMALL,
        hunger = -3,

        temperature = 100,
    }),

    bluemushroomtea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("bluemushroomtea"),

        health = -TUNING.HEALING_SMALL,
        sanity = TUNING.SANITY_SMALL,
        hunger = -2,

        temperature = 100,
    }),

    greenmushroomtea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("greenmushroomtea"),

        health = -TUNING.HEALING_TINY,
        sanity = TUNING.SANITY_MED,
        hunger = -1,

        temperature = 100,
    }),		

    redjellytea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("redjellytea"),

        health = -3,
        sanity = 30,
        hunger = -30,

        temperature = 100,
    }),

    bluejellytea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("bluejellytea"),

        health = 30,
        sanity = -30,
        hunger = -3,

        temperature = 100,
    }),

    greenjellytea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("greenjellytea"),

        health = -30,
        sanity = -3,
        hunger = 30,

        temperature = 100,
    }),	

    jellytea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("jellytea"),

        health = 3,
        sanity = 3,
        hunger = 3,

        temperature = 99,
    }),	

    --For later...
    
    --redtea = MergeMaps(basic_tea_data, {
        --assets = {
            --Asset("ANIM", "anim/tea.zip"),
        --},

        --build = "tea",
        --anim = "tea",
        --inventory_atlas = "images/inventoryimages/redtea.xml",

        --health = TUNING.HEALING_TINY,
        --sanity = TUNING.SANITY_SMALL,

        --temperature = 100,
    --}),	

    herbaltea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("herbaltea"),

        health = 20,
        sanity = 15,

        temperature = 90,
    }),	

    algaetea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("algaetea"),
        
        health = 0,
        sanity = -6,
        hunger = 10,

        temperature = 90,
    }),	

    marshmallowtea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("marshmallowtea"),

        health = -6,
        sanity = 10,

        temperature = 80,
    }),

    dragontea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("dragontea"),

        health = -40,
        sanity = -5,

        temperature = 200,
    }),	

    ambrosiatea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("ambrosiatea"),

        health = math.random(-40,20),
        sanity = math.random(-40,20),
        hunger = math.random(-40,20),

        temperature = 100,

        oneatenfn = ambrosiafn,
    }),	

    spoiledtea = MergeMaps(basic_tea_data, {
        assets = {
            Asset("ANIM", "anim/tea.zip"),
        },

        build = "tea",
        anim = "tea",
        inventory_atlas = inventoryimage_atlas("spoiledtea"),

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
