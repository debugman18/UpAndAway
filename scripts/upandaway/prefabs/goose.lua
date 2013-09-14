--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/goose.zip"),

	Asset("ANIM", "anim/perd_basic.zip"),
	Asset("SOUND", "sound/perd.fsb"),
}

local prefabs =
{
    "drumstick",
}

local loot = 
{
    "drumstick",
    "smallmeat",
	"smallmeat",
}
 
local function set_eggdrop(inst)
	local lastegglaid = GLOBAL.GetTime() - 120
	local now = GLOBAL.GetTime()
	local isstatic = true
	if lastegglaid <= now - 120 then		
		inst:DoTaskInTime(30, function()
			inst:ListenForEvent("upandaway_uncharge", function(inst)
				isstatic = false
			end)	
			if isstatic == true then
				egg = SpawnPrefab("golden_egg")
				inst.AnimState:PlayAnimation("lay_egg")
				egg.Transform:SetPosition(inst.Transform:GetWorldPosition())
				lastegglaid = now
				print "An egg was laid!"
			end				
		end)		
	end
end 

 
local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()
	inst.Transform:SetScale(1.3, 1.4, 1.1)
	
    MakeCharacterPhysics(inst, 50, .5)    
     
    anim:SetBank("perd")
    anim:SetBuild("goose")
    
    inst:AddComponent("locomotor")
    inst.components.locomotor.runspeed = 10
    inst.components.locomotor.walkspeed = 8
    
	--inst:SetStateGraph(SGgoose")
    inst:SetStateGraph("SGperd")
    --anim:Hide("hat")

    inst:AddTag("character")

    inst:AddComponent("homeseeker")
    --local brain = require "brains/goosebrain"
	local brain = require "brains/perdbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("eater")
    inst.components.eater:SetVegetarian()
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetWakeTest( function() return true end)    --always wake up if we're asleep

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
	
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(40)
    inst.components.combat:SetDefaultDamage(TUNING.PERD_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PERD_ATTACK_PERIOD)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
    inst:AddComponent("inventory")
    
    inst:AddComponent("inspectable")
    
    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")
	
 	inst:AddComponent("staticchargeable")
 	inst.components.staticchargeable:SetOnChargeFn(set_eggdrop)

    return inst
end

return Prefab("forest/animals/goose", fn, assets, prefabs) 
