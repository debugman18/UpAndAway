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

    Asset( "ANIM", "anim/winston.zip" ),
    --Asset( "ANIM", "anim/ghost_winnie_build.zip" ),
}

local prefabs = CFG.WINNIE.PREFABS

--local starting_inventory = CFG.WINSTON.STARTING_INV

-- Winston becomes a human.
local function onbecamehuman(inst)
    inst.components.locomotor:SetExternalSpeedMultiplier(inst, "winnie_speed_mod", 1)
end

-- Winston becomes a ghost.
local function onbecameghost(inst)
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "winnie_speed_mod")
end

-- Winnie only gets one sheep companion.
local function onload(inst, data)
    if data and data.form then
        inst.form = data.form
    end

    -- Ghosty stuff.
    if IsDST() then
        inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
        inst:ListenForEvent("ms_becameghost", onbecameghost)

        if inst:HasTag("playerghost") then
            onbecameghost(inst)
        else
            onbecamehuman(inst)
        end
    end
end

local function onsave(inst, data)
    if inst then
        data.form = inst.form
    end
end

-- Winnie gets special gains/losses for eating.
local function penalty(inst, food)

    local eater = inst.components.eater
    local food = food.components.edible.foodtype
    local prefab = food.prefab

end
   

local function compat_fn(inst)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("winnie.tex")

    inst.OnSave = onsave
    inst.OnLoad = onload

    -- DST only, isn't it?
    if IsDST() then
        inst.OnNewSpawn = onload
    end

end

local function post_compat_fn(inst)

    TheMod:DebugSay("Applying character stats.")

    inst.soundsname = "winnie"

    inst.components.eater:SetOnEatFn(oneatfn)

    inst.components.health:SetMaxHealth(CFG.WINNIE.HEALTH)

    inst.components.hunger:SetMax(CFG.WINNIE.HUNGER)

    inst.components.sanity:SetMax(CFG.WINNIE.SANITY)

    inst.components.combat.damagemultiplier = CFG.WINNIE.DAMAGE_MULTIPLIER

    inst.components.locomotor.walkspeed = CFG.WINNIE.WALK_SPEED
    inst.components.locomotor.runspeed = CFG.WINNIE.RUN_SPEED

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
    return MakePlayerCharacter("winston", prefabs, assets, common_postinit, master_postinit, starting_inventory)
else 
    return MakePlayerCharacter("winston", prefabs, assets, character_fn, starting_inventory)
end