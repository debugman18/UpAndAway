BindGlobal()

local assets=
{
	Asset("ANIM", "anim/cane.zip"),
	Asset("ANIM", "anim/swap_cane.zip"),
    
}

local prefabs = {}

local herddt = 1
local SEARCH_RADIUS = 20
local HERD_TAG = "herded"
local MIN_FOLLOW_LEADER = 1
local MAX_FOLLOW_LEADER = 12
local TARGET_FOLLOW_LEADER = 2

local function herd_disable(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end

    local x,y,z = GetPlayer().Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 20, {"sheep"})

    for k,v in pairs(ents) do
        v:RemoveTag(HERD_TAG)
        v.components.follower.leader = nil
    end
end

-- Returns the current leader.
local function GetLeader(inst)
    return inst.components.follower and inst.components.follower.leader
end

local function IsValidFollower(entity)
    -- Only consider things which can move around and have a brain.  We don't want trees to try and follow us.
    return entity.components and entity.components.locomotor and entity.brain and entity.brain.bt and entity.brain.bt.root and entity.prefab == "sheep" and entity ~= GLOBAL.GetPlayer()
end

local function CanBeAttacked(attacker)
    -- Don't let followers attack us.
    return not attacker:HasTag(HERD_TAG)
end

local function herd_update(inst)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner

    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x,y,z, 20, {"beefalo"})

        for k,v in pairs(ents) do
            if v.components.follower and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 3 then
                owner.components.leader:AddFollower(v)
            end
        end

        for k,v in pairs(owner.components.leader.followers) do
            if k:HasTag("beefalo") and k.prefab == "beefalo" and k.components.follower then
                k.components.follower:AddLoyaltyTime(2)
            end
        end
    end    


    -- Only update if player has spawned.
    local player = GLOBAL.GetPlayer()
    if not player then
        return
    end

    -- Make sure our followers can't attack us.
    if player.components.combat and not player.components.combat.canbeattackedfn then
        player.components.combat.canbeattackedfn = CanBeAttacked
    end

    -- Get all entities around the player which haven't already been tagged.
    local x,y,z = player.Transform:GetWorldPosition()
    local ignore_tags = {HERD_TAG}
    local entities = TheSim:FindEntities(x,y,z, SEARCH_RADIUS, {}, ignore_tags)

    -- Convert the entities to followers.
    for k,v in pairs(entities) do
        if IsValidFollower(v) then

            -- Insert a new behaviour into the brain
            local behaviours = v.brain.bt.root.children
            table.insert(behaviours, math.min(3, #behaviours), GLOBAL.Follow(v, GetLeader, MIN_FOLLOW_LEADER, TARGET_FOLLOW_LEADER, MAX_FOLLOW_LEADER, true))
    
            -- Add follower component if it doesn't already have one.
            if not v.components.follower then
                v:AddComponent("follower")
            end         

            -- Tell entity to stop combat just in case it was trying to fight us.
            if v.components.combat then
                v.components.combat:GiveUp()
            end
    
            -- Tell the entity to follow us.
            if v.components.follower.leader ~= player then
                player.components.leader:AddFollower(v)
            end

            -- Tag this entity so we don't try and convert it again.
            v:AddTag(HERD_TAG)

            --Make the sheep walk faster to catch up.
            v.components.locomotor.walkspeed = 5
        end
    end   
         
end

local function herd_enable(inst)
    inst.updatetask = inst:DoPeriodicTask(herddt, herd_update, 1)
end    

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
    inst.components.inventoryitem.atlasname = "images/inventoryimages/winnie_staff.xml"
    
    inst:AddComponent("equippable")
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)  
    
    return inst
end

return Prefab( "common/inventory/winnie_staff", fn, assets) 

