wickerrequire "plugins.addtechbranch"

TheMod:AddTechBranch("FABLE", 3)
TheMod:AddPrototyperTree("RESEARCH_LECTERN", {FABLE = 2}, STRINGS.UPUI.CRAFTING.NEEDRESEARCHLECTERN)

---

local NewRecipeAdder = wickerrequire "plugins.recipeadder"

local TABS = _G.RECIPETABS
local TECH = _G.TECH

-- This handles the recipe adding.
local RecipeAdder = NewRecipeAdder()

-- This is for debugging.
RecipeAdder:TrackRecipes(TheMod:Debug())

--[[
-- This defines the default prefab for recipes.
-- 'prefab' is the prefab of the recipe's result (or of the igredient,
-- see ModIngredient below).
--]]
RecipeAdder:SetDefaultAtlasFn(inventoryimage_atlas)

--[[
-- This works and is used exactly the same as Ingredient.
-- The only difference is that ingredients declared as ModIngredients
-- will have their atlas set by the default atlas fn defined above
-- (provided they don't explicitly set an atlas).
--]]
local ModIngredient = RecipeAdder.ModIngredient

--[[
-- This is to reduce typing.
--]]
local Ing = Ingredient
local ModIng = ModIngredient

---

--[[
-- These handle recipe addition under a specific crafting tab.
--]]
local Dress = RecipeAdder[TABS.DRESS]
local Light = RecipeAdder[TABS.LIGHT]
local Magic = RecipeAdder[TABS.MAGIC]
local Refine = RecipeAdder[TABS.REFINE]
local Science = RecipeAdder[TABS.SCIENCE]
local Tools = RecipeAdder[TABS.TOOLS]
local Town = RecipeAdder[TABS.TOWN]
local War = RecipeAdder[TABS.WAR]

---

--[[
-- These are tech selectors nested under a crafting tab.
--
-- The table passed specifies the tech possibilities for each.
-- Calling them as a function, passing the position of the intended
-- selection, returns a recipe adder for a specific crafting tab and
-- a specific tech level.
--
-- See usage below for further explanation.
--]]
local DressFable = Dress {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local LightFable = Light {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local MagicFable = Magic {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local RefineFable = Refine {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local ScienceFable = Science {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local ToolsFable = Tools {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local TownFable = Town {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}
local WarFable = War {TECH.FABLE_1, TECH.FABLE_2, TECH.FABLE_3}

---

--[[
-- This adds a recipe for cotton_hat under the DRESS tab, tech level
-- TECH.FABLE_1 (since that's the tech level at position 1 in the
-- definition of DressFable).
--
-- The table passed after the result's name (note the lack of '=', this
-- is in fact a function call) lists the ingredients.
--
-- The lines after the first customize arbitrary fields from the resulting
-- Recipe object. Note the leading '.' and also the lack of '='
-- (these are also function calls).
--]]
DressFable(1).cotton_hat { Ing("silk", 2), ModIng("cloud_cotton", 6) }
    .sortkey (Recipes.bushhat.sortkey)

DressFable(1).cotton_vest { Ing("silk", 4), ModIng("cloud_cotton", 4) }
    .sortkey (Recipes.trunkvest_winter.sortkey)

DressFable(1).mushroom_hat { Ing("red_cap", 3), Ing("blue_cap", 3), Ing("green_cap", 3) }
    .sortkey (Recipes.flowerhat.sortkey)

---

LightFable(1).crystal_lamp { ModIng("beanlet_shell", 1), ModIng("crystal_fragment_light", 4), Ing("rope", 3) }
    .placer "crystal_lamp_placer"
    .sortkey (Recipes.lantern.sortkey)

---

MagicFable(1).blackstaff { Ing("spear", 1), ModIng("refined_black_crystal", 1), Ing("nightmarefuel", 6) }
    .sortkey (Recipes.icestaff.sortkey)

MagicFable(1).whitestaff { Ing("spear", 1), ModIng("refined_white_crystal", 1), Ing("nightmarefuel", 6) }
    .sortkey (Recipes.icestaff.sortkey)

MagicFable(1).wind_axe { ModIng("crystal_fragment_water", 2), ModIng("cumulostone", 3), Ing("rope", 2) }
    .sortkey (Recipes.batbat.sortkey)

---

RefineFable(1).refined_black_crystal { ModIng("crystal_fragment_black", 6) }
    .sortkey (Recipes.purplegem.sortkey)

RefineFable(1).refined_white_crystal { ModIng("crystal_fragment_white", 6) }
    .sortkey (Recipes.purplegem.sortkey)

RefineFable(1).refiner { Ing("hammer", 1), Ing("gears", 3), ModIng("thunderboards", 3) }
    .placer "refiner_placer"
    .atlas "images/ua_minimap.xml"
    .sortkey (1)

RefineFable(1).thunderboards { ModIng("thunder_log", 4) }
    .sortkey (Recipes.boards.sortkey)

---

ScienceFable(1).weather_machine { ModIng("cumulostone", 3), ModIng("crystal_fragment_black", 3) , Ing("bluegem", 4)}
    .placer "weather_machine_placer"
    .sortkey (Recipes.rainometer.sortkey)

ScienceFable(2).research_lectern { Ing("goldnugget", 4), ModIng("crystal_fragment_light", 2), ModIng("thunder_log", 6) }
    .placer "research_lectern_placer"
    .atlas "images/ua_minimap.xml"
    .sortkey (Recipes.researchlab2.sortkey)

---

--[[
ToolsFable(1).grabber { ModIng("magnet", 2), Ing("twigs", 8), ModIng("rubber", 4) }
    .sortkey (Recipes.prefab.sortkey)
]]--

ToolsFable(1).magnet { Ing("gears", 2), ModIng("crystal_fragment_quartz", 3), Ing("rope", 4) }
    .sortkey (Recipes.razor.sortkey)

---

TownFable(1).beanstalk_wall_item { ModIng("beanstalk_chunk", 4), Ing("twigs", 1) }
    .numtogive (6)
    .sortkey (Recipes.wall_stone_item.sortkey)

TownFable(1).cloud_wall_item { ModIng("cloud_cotton", 4), Ing("silk", 1) }
    .numtogive (6)
    .sortkey (Recipes.wall_stone_item.sortkey)    

TownFable(1).crystal_wall_item { ModIng("crystal_fragment_light", 2), ModIng("crystal_fragment_water", 2), ModIng("crystal_fragment_spire", 2) }
    .numtogive (6)
    .sortkey (Recipes.wall_stone_item.sortkey)

---

WarFable(1).beanlet_armor { ModIng("beanlet_shell", 1), ModIng("greenbean", 1), Ing("rope", 2) }
    .sortkey (Recipes.armormarble.sortkey)

WarFable(1).cotton_candy { ModIng("cloud_cotton", 6), ModIng("candy_fruit", 6) }
    .sortkey (Recipes.hambat.sortkey)

---

if RecipeAdder:IsTrackingRecipes() then
    local ValidateRecipes = modrequire "debugtools.validate_recipes"
    ValidateRecipes( RecipeAdder:GetTrackedRecipes() )
end
