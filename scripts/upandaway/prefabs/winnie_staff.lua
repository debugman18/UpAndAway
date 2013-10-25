--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets=
{
	Asset("ANIM", "anim/cane.zip"),
	Asset("ANIM", "anim/swap_cane.zip"),
    
}

local prefabs = {}

local function herd_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
end

local herddt = 1

local function herd_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner

    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x,y,z, 15, {"beefalo"}, {"sheep"})

        for k,v in pairs(ents) do
            if v.components.follower and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 3 then
                owner.components.leader:AddFollower(v)
            end
        end

        for k,v in pairs(owner.components.leader.followers) do
            if k:HasTag("beefalo") or k.HasTag("sheep") and k.components.follower then
                k.components.follower:AddLoyaltyTime(1)
            end
        end
    end
end

local function herd_enable(inst)
    inst.updatetask = inst:DoPeriodicTask(herddt, herd_update, 1)
end    

--[[
local function TryAddFollower(leader, follower)
    if leader.components.leader
       and follower.components.follower
       and follower:HasTag("beefalo")
       and leader.components.leader:CountFollowers("beefalo") < 3 then
        leader.components.leader:AddFollower(follower)
        follower.components.follower:AddLoyaltyTime(10+math.random())
        if follower.components.combat and follower.components.combat.target and follower.components.combat.target == leader then
            follower.components.combat:SetTarget(nil)
        end
        follower:DoTaskInTime(math.random(), function() follower.sg:PushEvent("heardhorn", {musician = leader} )end)
    end
end

local function obey_staff(inst, musician, instrument)
    if musician.components.leader then
        local herd = nil
        if inst:HasTag("beefalo") and not inst:HasTag("baby") and inst.components.herdmember then
            if inst.components.combat and inst.components.combat.target then
                inst.components.combat:GiveUp()
            end
            TryAddFollower(musician, inst)
            herd = inst.components.herdmember:GetHerd()
        end
        if herd and herd.components.herd then
            for k,v in pairs(herd.components.herd.members) do
                TryAddFollower(musician, k)
            end
        end
    end
end
]]

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_cane", "swap_cane")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 

    herd_enable(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")

    herd_disable(inst)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
    
    anim:SetBank("cane")
    anim:SetBuild("cane")
    anim:PlayAnimation("idle")
    
    inst:AddTag("horn")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    --inst.components.inventoryitem.atlasname = "images/inventoryimages/winnie_staff.xml"
    
    inst:AddComponent("equippable")
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)  
    
    return inst
end

return Prefab( "common/inventory/winnie_staff", fn, assets) 

