--[[
__TODO__
Winnie should be able to craft lureplant bulbs fairly inexpensively.
Likely will use seeds, nightmare fuel, and health.

Winnie gameplay is based around soft vegetarianism, naughtiness, and lureplants. Combat and sanity are the main mechanics.
--]]

BindGlobal()

local CFG = TheMod:GetConfig()

local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset( "ANIM", "anim/player_basic.zip" ),
    Asset( "ANIM", "anim/player_idles_shiver.zip" ),
    Asset( "ANIM", "anim/player_actions.zip" ),
    Asset( "ANIM", "anim/player_actions_axe.zip" ),
    Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
    Asset( "ANIM", "anim/player_actions_shovel.zip" ),
    Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
    Asset( "ANIM", "anim/player_actions_eat.zip" ),
    Asset( "ANIM", "anim/player_actions_item.zip" ),
    Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
    Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
    Asset( "ANIM", "anim/player_actions_fishing.zip" ),
    Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
    Asset( "ANIM", "anim/player_bush_hat.zip" ),
    Asset( "ANIM", "anim/player_attacks.zip" ),
    Asset( "ANIM", "anim/player_idles.zip" ),
    Asset( "ANIM", "anim/player_rebirth.zip" ),
    Asset( "ANIM", "anim/player_jump.zip" ),
    Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
    Asset( "ANIM", "anim/player_teleport.zip" ),
    Asset( "ANIM", "anim/wilson_fx.zip" ),
    Asset( "ANIM", "anim/player_one_man_band.zip" ),
    Asset( "ANIM", "anim/shadow_hands.zip" ),
    Asset( "SOUND", "sound/sfx.fsb" ),
    Asset( "SOUND", "sound/wilson.fsb" ),
    Asset( "ANIM", "anim/beard.zip" ),

    Asset( "ANIM", "anim/winnie.zip" ),
    --Asset( "ANIM", "anim/ghost_winnie_build.zip" ),
}

local prefabs = CFG.WINNIE.PREFABS

local seeds = CFG.WINNIE.POTENTIAL_SEEDS
local seed = seeds[math.random(#seeds)]

local starting_inventory = CFG.WINNIE.STARTING_INV

local kramped = nil

local kramped_actions = nil or 0

-- Rounding function.
local function Round(num)
    if num >= 0 then 
        return math.floor(num + 0.5) 
    else 
        return math.ceil(num - 0.5) 
    end
end

-- String magic.
local function calc_naughtyactions(inst)
    local debugstring = kramped:GetDebugString()
    TheMod:DebugSay("DebugString for Kramped is:")
    TheMod:DebugSay(debugstring)

    local action_count = string.match(debugstring, "Actions: %d.") or "Actions: 0"
    for word in action_count:gmatch("%w+") do 
        local number = string.match(word, "%d+")
        if number then
            kramped_actions = number
        end
    end
end

-- Set kramped to appropriate value.
local function getKramped(inst)
    if IsDST() then

        kramped = TheWorld.components.kramped
        calc_naughtyactions(inst)
        
    else 

        kramped = inst.components.kramped
        kramped_actions = kramped.actions

    end

    if kramped_actions then
        TheMod:DebugSay("Kramped actions are at " .. kramped_actions .. ".")
    end
end

-- Spawn and kill a dummy entity for naughtiness.
local function spawndummy(inst)
    local dummy = SpawnPrefab("crow")
    local health = dummy.components.health.currenthealth
    dummy.components.lootdropper.loot = nil
    dummy.components.combat:GetAttacked(inst, health)
end

-- A DST friendly way to incite naughtiness.
local function DoNaughty(inst, naughty_value)
    calc_naughtyactions(inst)
    for k = 1, naughty_value do
        spawndummy(inst)
    end
end

-- Gives winnie a random seed nicely.
table.insert(starting_inventory, seed)

-- Spawns Winnie with a special named sheep.
local function spawn_sheep(inst)
    if not inst.hadsheep then
        TheMod:DebugSay("Attemping to spawn sheep.")

        local sheep = SpawnPrefab("winnie_sheep")

        sheep:AddTag("winnie_sheep")

        sheep.Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst.components.leader:AddFollower(sheep)

        inst.hadsheep = true
    end
end

-- Winnie only gets one sheep companion.
local function onload(inst, data)
    if data.hadsheep then
        TheMod:DebugSay("A sheep may already have existed.")
        inst.hadsheep = data.hadsheep
    else
        spawn_sheep(inst)
    end
end

local function onsave(inst, data)
    if inst then
        data.hadsheep = inst.hadsheep
    end
end

-- Calculate how much health Winnie regains.
local function calcresist(inst, attacker)
    local attacker_damage = attacker.components.combat.defaultdamage or 0
    local veggie_resist = CFG.WINNIE.VEGGIE_RESIST

    local resist_amount = (attacker_damage * veggie_resist)

    return Round(resist_amount)
end

-- Winnie gets a damage resistance to lureplants.
local function onattacked(inst, data)
    local attacker = data.attacker

    if attacker and attacker:HasTag("veggie") then
        inst.components.health:DoDelta(calcresist(inst, attacker))
    end    
end

-- Winnie gets special gains/losses for eating.
local function penalty(inst, food)
    getKramped(inst)

    local eater = inst.components.eater
    local food = food.components.edible.foodtype
    local prefab = food.prefab

    if eater and food == "MEAT" and not (prefab == "plantmeat" or prefab == "plantmeat_cooked") then
        inst.components.sanity:DoDelta(Round(CFG.WINNIE.MEAT_PENALTY_SANITY))
        inst.components.health:DoDelta(Round(CFG.WINNIE.MEAT_PENALTY_HEALTH))
        inst.components.talker:Say("Blech.")

        if IsDST() then
            DoNaughty(inst, CFG.WINNIE.MEAT_PENALTY_NAUGHTY)
        else
            kramped:OnNaughtyAction(Round(CFG.WINNIE.MEAT_PENALTY_NAUGHTY))
        end

    elseif eater and food == "VEGGIE" then
        inst.components.sanity:DoDelta(Round(CFG.WINNIE.VEGGIE_BONUS_SANITY))
        inst.components.health:DoDelta(Round(CFG.WINNIE.VEGGIE_BONUS_HEALTH))
        inst.components.hunger:DoDelta(Round(CFG.WINNIE.VEGGIE_BONUS_HUNGER))
        if IsDST() then
            DoNaughty(inst, CFG.WINNIE.VEGGIE_BONUS_NAUGHTY)
        else
            kramped:OnNaughtyAction(Round(CFG.WINNIE.MEAT_PENALTY_NAUGHTY))
        end

    end
end

-- Makes sure the sanity bonus isn't overwhelming for creatures with a large amount of health.
local function bonus_fn(target)
    if target and target.components.health then
        local health_to_sanity = target.components.health.currenthealth / CFG.WINNIE.HEALTH_PERCENT
        if health_to_sanity <= CFG.WINNIE.SANITY_BONUS_CAP then
            return Round(health_to_sanity)
        else
            return Round(CFG.WINNIE.SANITY_BONUS_CAP)
        end
    end
end

local function calc_naughtydamage(inst)
    getKramped(inst)

    local base_damage = CFG.WINNIE.DAMAGE_MULTIPLIER 

    local naughtiness = kramped_actions or 0

    local bonus_damage = CFG.WINNIE.NAUGHTY_BONUS * naughtiness

    local new_damage = base_damage + bonus_damage

    return Round(new_damage)
end

-- Winnie will gain sanity and naughtiness when attacking.
local function on_combat(inst)
    getKramped(inst)

    TheMod:DebugSay("Attemping to calculate naughty bonuses.")

    if inst then
        inst.components.combat.damagemultiplier = calc_naughtydamage(inst)
    end

    local weapon = inst.components.combat:GetWeapon()
    local target = inst.components.combat.target

    if target then

        local old_naughty_amount = bonus_fn(target) * CFG.WINNIE.NAUGHTY_BONUS
        local naughty_amount = Round(old_naughty_amount)

        inst.components.sanity:DoDelta(bonus_fn(target))

        if IsDST() then
            DoNaughty(inst, naughty_amount)
        else
            kramped:OnNaughtyAction(naughty_amount, GetLocalPlayer())
        end

        TheMod:DebugSay("Applying a sanity bonus of " .. bonus_fn(target) .. ".")

    else

        local bonus = CFG.WINNIE.NAUGHTY_BONUS * CFG.WINNIE.SANITY_BONUS_CAP * CFG.WINNIE.PROJECTILE_MULT

        inst.components.sanity:DoDelta(bonus)

        if IsDST() then
            DoNaughty(inst, bonus)
        else
            kramped:OnNaughtyAction(bonus, GetLocalPlayer())
        end  

        TheMod:DebugSay("Applying a sanity bonus of " .. bonus .. ".")      
        
    end
end        

local function compat_fn(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("winnie.tex")

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddTag("winnie_builder")

end

local function post_compat_fn(inst)

    TheMod:DebugSay("Applying character stats.")

    getKramped(inst)

    inst.soundsname = "winnie"

    inst.components.eater:SetOnEatFn(penalty)

    inst:ListenForEvent("onattackother", on_combat)  
    inst:ListenForEvent("onareaattackother", on_combat)

    inst.components.health:SetMaxHealth(CFG.WINNIE.HEALTH)
    inst.components.hunger:SetMax(CFG.WINNIE.HUNGER)
    inst.components.sanity:SetMax(CFG.WINNIE.SANITY)

    inst.components.combat.damagemultiplier = CFG.WINNIE.DAMAGE_MULTIPLIER

    inst.components.locomotor.walkspeed = CFG.WINNIE.WALK_SPEED
    inst.components.locomotor.runspeed = CFG.WINNIE.RUN_SPEED

    inst:ListenForEvent("attacked", onattacked)

    -- Let's make sure the sheep becomes a follower if it exists.
    -- We also do not want to break it in the case of multiple Winnies.
    -- So let's make sure the sheep has no leader first.
    if inst.hadsheep then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, range, {"winnie_sheep"})
        for i,ent in ipairs(ents) do
            TheMod:DebugSay(ent.prefab .. " was found.")
            if not ent.components.follower.leader == inst then
                inst.components.leader:AddFollower(v)
            end
        end        
    end

end

-- Don't Starve Together
local common_postinit = function(inst) 
    TheMod:DebugSay("Playing on Don't Starve Together.")
    compat_fn(inst)
end

local master_postinit = function(inst)    
    post_compat_fn(inst)
end

-- Don't Starve
local character_fn = function(inst) 
    TheMod:DebugSay("Playing on Don't Starve.")
    compat_fn(inst) 
    post_compat_fn(inst) 
end

if IsDST() then
    return MakePlayerCharacter("winnie", prefabs, assets, common_postinit, master_postinit, starting_inventory)
else 
    return MakePlayerCharacter("winnie", prefabs, assets, character_fn, starting_inventory)
end
