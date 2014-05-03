BindGlobal()

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
}

local starting_inventory = {"winnie_staff"}
local prefabs = {"winnie_staff"}

--The penalty for eating meat.
local function penalty_meat(inst, food)
        if inst.components.eater and food.components.edible.foodtype == "MEAT" then
                inst.components.sanity:DoDelta(-40)
                inst.components.health:DoDelta(-5)
                inst.components.hunger:DoDelta(-3)
                inst.components.talker:Say("What have I done?")
        elseif inst.components.eater and food.components.edible.foodtype == "VEGGIE" then
                inst.components.sanity:DoDelta(10)
                inst.components.health:DoDelta(5)
                inst.components.hunger:DoDelta(5)
        end
end

--The penalty for attacking innocent creatures.
local function penalty_combat(inst, target)
        local target = inst.components.combat.target
        if target and not (target.components.combat.target == inst) then
                inst.components.sanity:DoDelta(-3)
                TheMod:DebugSay("Attacking innocent.")        
        end
end        

local fn = function(inst)
	
	inst.soundsname = "winnie"

        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon("winnie.tex")

        inst.components.eater:SetOnEatFn(penalty_meat)

        inst:ListenForEvent("onattackother", penalty_combat)   

        inst.components.inventory:GuaranteeItems({"winnie_staff"})

        inst.components.health:SetMaxHealth(160)
        inst.components.hunger:SetMax(220)
        inst.components.sanity:SetMax(100)
        inst.components.combat.damagemultiplier = 0.90
        inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED* 1.085)
        inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED* 1.085)

        GLOBAL.TUNING.MIN_CROP_GROW_TEMP = 0
	
end

return MakePlayerCharacter("winnie", prefabs, assets, fn, starting_inventory)

