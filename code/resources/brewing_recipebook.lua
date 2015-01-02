--[[
-- List of brewing recipes.
--]]



local Lambda = wickerrequire "paradigms.functional"

local Configurable = wickerrequire "adjectives.configurable"
local basic_cfg = Configurable("BEVERAGE")
local tea_cfg = Configurable("BEVERAGE", "TEA")


-- Syntax conveniences.
BindModModule "lib.brewing"

--[[
-- Keep in mind that Recipe, Ingredient, etc. are not the vanilla ones,
-- but those defined in lib.brewing.
--]]

local teas = {
    green = Recipe("greentea", Ingredient("tea_leaves", 1), -3),
    white = Recipe("whitetea", Ingredient("tea_leaves", 2), -2),
    black = Recipe("blacktea", Ingredient("blacktea_leaves"), -1),
}

local black_teas = {
    sweetblack = Recipe("sweet_blacktea", teas.black:GetCondition() + Ingredient("honey"), 1),	
    chai = Recipe("chaitea", Ingredient("datura_petals") + Ingredient("blacktea_leaves"), 0),
    oolong = Recipe("oolongtea", Ingredient("skyflower_petals") + Ingredient("blacktea_leaves"), 0),
    dragon = Recipe("dragontea", Ingredient("dragonblood_sap") + Ingredient("blacktea_leaves"), 0),
}

local veggie_teas = {
    berry = Recipe("berrytea", Ingredient("berries") + Ingredient("tea_leaves"), 0),
    berrypulp = Recipe("berrypulptea", Ingredient("berries", 2), 0),	
    greener = Recipe("greenertea", Ingredient("tea_leaves", 1) + Ingredient("greenbean", 1), 1),
    cloudfruit = Recipe("cloudfruittea", Ingredient("tea_leaves") + Ingredient("cloud_fruit", 1), 0),
    cotton = Recipe("cottontea", Ingredient("tea_leaves") + Ingredient("cloud_cotton", 1), 0),
    candy = Recipe("candytea", Ingredient("candy_fruit") + Ingredient("tea_leaves"), 0),
    herbal = Recipe("herbaltea", Ingredient("cutlichen") + Ingredient("tea_leaves"), 0),
    algae = Recipe("algaetea", Ingredient("cloud_algae_fragment") + Ingredient("tea_leaves"), 0),
    marshmallow = Recipe("marshmallowtea", Ingredient("marshmallow") + Ingredient("tea_leaves"), 0),
    ambrosia = Recipe("ambrosiatea", Ingredient("ambrosia") + Ingredient("tea_leaves"), 0),
}

local flower_teas = {
    petal = Recipe("petaltea", Ingredient("petals", 2), 0),
    evilpetal = Recipe("evilpetaltea", Ingredient("petals_evil", 2), 0),
    mixedpetal = Recipe("mixedpetaltea", Ingredient("petals_evil") + Ingredient("petals"), 0),
    floral = Recipe("floraltea", Ingredient("tea_leaves") + Ingredient("petals"), 0),
    skypetal = Recipe("skypetaltea", Ingredient("skyflower_petals", 2), 0),
    datura = Recipe("daturatea", Ingredient("datura_petals", 2), 0),
    gold = Recipe("goldtea", Ingredient("golden_petals") + Ingredient("tea_leaves"), 0),	
}

local mushroom_teas = {
    redmushroom = Recipe("redmushroomtea", Ingredient("red_cap") + Ingredient("tea_leaves"), 0),
    bluemushroom = Recipe("bluemushroomtea", Ingredient("blue_cap") + Ingredient("tea_leaves"), 0),
    greenmushroom = Recipe("greenmushroomtea", Ingredient("green_cap") + Ingredient("tea_leaves"), 0),	
}

local jelly_teas = {
    jelly = Recipe("jellytea", Ingredient("cloud_jelly") + Ingredient("tea_leaves"), 0),
    redjelly = Recipe("redjellytea", Ingredient("jellycap_red") + Ingredient("tea_leaves"), 0),
    bluejelly = Recipe("bluejellytea", Ingredient("jellycap_blue") + Ingredient("tea_leaves"), 0),
    greenjelly = Recipe("greenjellytea", Ingredient("jellycap_green") + Ingredient("tea_leaves"), 0),
}

local sweet_teas = {
    green = Recipe("sweet_greentea", teas.green:GetCondition() + Ingredient("honey"), 1),
    white = Recipe("sweet_whitetea", teas.white:GetCondition() + Ingredient("honey"), 1),
}

return RecipeBook {
    teas,
    black_teas,
    sweet_teas,
    flower_teas,
    veggie_teas,
    mushroom_teas,
    jelly_teas,

    Recipe(basic_cfg:GetConfig("SPOILED_PREFAB"), Lambda.True, -math.huge),
}
