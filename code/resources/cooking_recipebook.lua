--This adds the new crockpot recipes.

local CFG = TheMod:GetConfig()

BindTheMod()

AddIngredientValues({

    "crystal_fragment_black",
    "crystal_fragment_light",
    "crystal_fragment_quartz",
    "crystal_fragment_relic",
    "crystal_fragment_spire",
    "crystal_fragment_water",
    "crystal_fragment_white"

}, {crystal = 1}, true)

AddIngredientValues({

    "jellycap_red",
    "jellycap_blue",
    "jellycap_green",
    "cloud_jelly",

}, {jelly = 1}, true)

AddIngredientValues({

    "greenbean",
    "greenbean_cooked"

}, {greenbean = 1}, true)

AddIngredientValues({

    "rubber"

}, {rubber=1}, true)

local greenjelly = {
    name = "greenjelly",
    test = function(cooker, names, tags) return tags.greenbean == 1 and tags.jelly == 3 end,
    priority = 1,
    weight = 1,
    foodtype = "VEGGIE",
    health = CFG.GREENJELLY.HEALTH_VALUE,
    hunger = CFG.GREENJELLY.HUNGER_VALUE,
    sanity = CFG.GREENJELLY.SANITY_VALUE,
    perishtime = CFG.COOKEDJELLY.PERISH_TIME,
    cooktime = CFG.COOKEDJELLY.COOK_TIME,
}

local redjelly = {
    name = "redjelly",
    test = function(cooker, names, tags) return tags.rubber == 1 and tags.jelly == 3 end,
    priority = 1,
    weight = 1, 
    foodtype = "VEGGIE",
    health = CFG.REDJELLY.HEALTH_VALUE,
    hunger = CFG.REDJELLY.HUNGER_VALUE,
    sanity = CFG.REDJELLY.SANITY_VALUE,
    perishtime = CFG.COOKEDJELLY.PERISH_TIME,
    cooktime = CFG.COOKEDJELLY.COOK_TIME,
}

local crystalcandy = {
    name = "crystalcandy",
    test = function(cooker, names, tags) return tags.crystal == 3 and tags.inedible == 1 end,
    priority = 1,
    weight = 1, 
    foodtype = "VEGGIE",
    health = CFG.REDJELLY.HEALTH_VALUE,
    hunger = CFG.REDJELLY.HUNGER_VALUE,
    sanity = CFG.REDJELLY.SANITY_VALUE,
    perishtime = CFG.COOKEDJELLY.PERISH_TIME,
    cooktime = CFG.COOKEDJELLY.COOK_TIME,	
}

AddCookerRecipe("cookpot", greenjelly)
AddCookerRecipe("cookpot", redjelly)
AddCookerRecipe("cookpot", crystalcandy)