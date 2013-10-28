--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/Beanlet.zip"),  -- same name as the .scml
}

local prefabs =
{
   "greenbean",
}

local loot = 
{
    "greenbean",
}

local function OnAttacked(inst, data)
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    inst.AnimState:SetBank("Beanlet") -- name of the animation root
    inst.AnimState:SetBuild("Beanlet")  -- name of the file
    inst.AnimState:PlayAnimation("idle", true) -- name of the animation


    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(50)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)   

    inst:AddComponent("inspectable")

    inst:ListenForEvent("attacked", OnAttacked)          
	
    return inst
end

return Prefab ("common/inventory/beanlet_zealot", fn, assets, prefabs) 
