--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

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
                inst.components.sanity:DoDelta(-50)
                inst.components.health:DoDelta(-5)
                inst.components.hunger:DoDelta(-3)
        end
end

--The penalty for attacking innocent creatures.
local function penalty_combat(inst, target)
        local target = inst.components.combat.target
        if target and not target:HasTag("monster") then
                inst.components.sanity:DoDelta(-3)
                print "Attacking innocent."        
        end
        print "Attacking monster."
end        

local fn = function(inst)
	
	inst.soundsname = "winnie"

	inst.MiniMapEntity:SetIcon( "winnie.png" )

        inst.components.eater:SetOnEatFn(penalty_meat)

        inst:ListenForEvent("onattackother", penalty_combat)   

        inst.components.inventory:GuaranteeItems({"winnie_staff"})

        GLOBAL.TUNING.MIN_CROP_GROW_TEMP = 0
	
end

return MakePlayerCharacter("winnie", prefabs, assets, fn, starting_inventory)

