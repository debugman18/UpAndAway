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

-- Gives winnie a random seed nicely.
table.insert(starting_inventory, seed)

-- Spawns Winnie with a special named sheep.
local function spawn_sheep(inst)
    if not inst.hadsheep then
        TheMod:DebugSay("Attemping to spawn sheep.")

        local sheep = SpawnPrefab("winnie_sheep")

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

    return (attacker_damage * veggie_resist)
end

-- Winnie gets a damage resistance to lureplants.
local function onattacked(inst, data)
    local attacker = data.attacker

    if attacker:HasTag("veggie") then
        inst.components.health:DoDelta(calcresist(inst, attacker))
    end    
end

-- Winnie gets special gains/losses for eating.
local function penalty(inst, food)
    local eater = inst.components.eater
    local food = food.components.edible.foodtype
    local prefab = food.prefab

    if eater and food == "MEAT" and not (prefab == "plantmeat" or prefab == "plantmeat_cooked") then
        inst.components.sanity:DoDelta(CFG.WINNIE.MEAT_PENALTY_SANITY)
        inst.components.health:DoDelta(CFG.WINNIE.MEAT_PENALTY_HEALTH)
        inst.components.talker:Say("Blech.")
        kramped:OnNaughtyAction(CFG.WINNIE.MEAT_PENALTY_NAUGHTY)
    elseif eater and food == "VEGGIE" then
        inst.components.sanity:DoDelta(CFG.WINNIE.VEGGIE_BONUS_SANITY)
        inst.components.health:DoDelta(CFG.WINNIE.VEGGIE_BONUS_HEALTH)
        inst.components.hunger:DoDelta(CFG.WINNIE.VEGGIE_BONUS_HUNGER)
        kramped:OnNaughtyAction(CFG.WINNIE.VEGGIE_BONUS_NAUGHTY)
    end
end

-- Makes sure the sanity bonus isn't overwhelming for creatures with a large amount of health.
local function bonus_fn(target)
    if target and target.components.health then
        local health_to_sanity = target.components.health.currenthealth / CFG.WINNIE.HEALTH_PERCENT
        if health_to_sanity <= CFG.WINNIE.SANITY_BONUS_CAP then
            return health_to_sanity
        else
            return CFG.WINNIE.SANITY_BONUS_CAP
        end
    end
end

local function calc_naughtydamage(inst)
    local base_damage = CFG.WINNIE.DAMAGE_MULTIPLIER 

    local naughtiness = kramped.actions

    local bonus_damage = CFG.WINNIE.NAUGHTY_BONUS * naughtiness

    local new_damage = base_damage + bonus_damage

    return new_damage
end

-- Winnie will gain sanity and naughtiness when attacking.
local function on_combat(inst)
    TheMod:DebugSay("Attemping to calculate naughty bonuses.")

    if inst then
        inst.components.combat.damagemultiplier = calc_naughtydamage(inst)
    end

    local target = inst.components.combat.target
    if target then
        inst.components.sanity:DoDelta(bonus_fn(target))
        kramped:OnNaughtyAction(bonus_fn(target) * CFG.WINNIE.NAUGHTY_BONUS, GetLocalPlayer())
        TheMod:DebugSay("Applying a sanity bonus of " .. bonus_fn(target) .. ".")        
    end
end        

local function compat_fn(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("winnie.tex")

    inst.OnSave = onsave
    inst.OnLoad = onload

end

local function post_compat_fn(inst)

    TheMod:DebugSay("Applying character stats.")

    if IsDST() then
        kramped = TheWorld.components.kramped
    else 
        kramped = inst.components.kramped
    end

    inst.soundsname = "winnie"

    inst.components.eater:SetOnEatFn(penalty)

    inst:ListenForEvent("onattackother", on_combat)  

    inst.components.health:SetMaxHealth(CFG.WINNIE.HEALTH)
    inst.components.hunger:SetMax(CFG.WINNIE.HUNGER)
    inst.components.sanity:SetMax(CFG.WINNIE.SANITY)

    inst.components.combat.damagemultiplier = CFG.WINNIE.DAMAGE_MULTIPLIER

    inst.components.locomotor.walkspeed = CFG.WINNIE.WALK_SPEED
    inst.components.locomotor.runspeed = CFG.WINNIE.RUN_SPEED

    inst:ListenForEvent("attacked", onattacked)
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
