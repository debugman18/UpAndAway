BindGlobal()

local CFG = TheMod:GetConfig()

require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/cloud_wall.zip"),

    Asset( "ATLAS", inventoryimage_atlas("cloud_wall_item") ),
    Asset( "IMAGE", inventoryimage_texture("cloud_wall_item") ),
}

local prefabs = CFG.CLOUD_WALL.PREFABS

SetSharedLootTable( "cloudwallloot", CFG.CLOUD_WALL.LOOT)

local maxloots = CFG.CLOUD_WALL.NUMRANDOMLOOT
local maxhealth = CFG.CLOUD_WALL.HEALTH

local function makeobstacle(inst)      
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES) 
    inst.Physics:ClearCollisionMask()
    inst.Physics:SetMass(0)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetActive(true)
    local ground = GetWorld()
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
    end
end

local function clearobstacle(inst)
    inst:DoTaskInTime(2*FRAMES, function() inst.Physics:SetActive(false) end)

    local ground = GetWorld()
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:RemoveWall(pt.x, pt.y, pt.z)
    end
end

local function denyentry(inst)
    TheMod:DebugSay("Denying entry.")
    inst.AnimState:SetMultColour(1,1,1,1)
    makeobstacle(inst)
end

local function allowentry(inst)
    TheMod:DebugSay("Allowing entry.")
    inst.AnimState:SetMultColour(1,1,1,CFG.CLOUD_WALL.ALPHA)
    clearobstacle(inst)
end

local function ondeploywall(inst, pt, deployer)
    local wall = SpawnPrefab("cloud_wall") 
    if wall then 
        pt = Vector3(math.floor(pt.x)+.5, 0, math.floor(pt.z)+.5)
        wall.Physics:SetCollides(false)
        wall.Physics:Teleport(pt.x, pt.y, pt.z) 
        wall.Physics:SetCollides(true)
        inst.components.stackable:Get():Remove()

        local ground = GetWorld()
        if ground then
            ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
        end
    end 		
end

local function onmined(inst, worker)
    if maxloots and loot then
        local num_loots = math.max(1, math.floor(maxloots*inst.components.health:GetPercent()))
        for k = 1, num_loots do
            inst.components.lootdropper:SpawnLootPrefab(loot)
        end
    end		
        
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")		
        
    inst:Remove()
end

local function test_wall(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.IMPASSABLE 
        
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 2, nil, {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR"}) -- or we could include a flag to the search?

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                local dsq = distsq( Vector3(v.Transform:GetWorldPosition()), pt)
                if v:HasTag("wall") then
                    if dsq < .1 then return false end
                else
                    if  dsq< 1 then return false end
                end
            end
        end
            
        return true

    end
    return false
        
end

local function resolveanimtoplay(percent)
    local anim_to_play = nil
    if percent <= 0 then
        anim_to_play = "0"
    elseif percent <= .4 then
        anim_to_play = "1_4"
    elseif percent <= .5 then
        anim_to_play = "1_2"
    elseif percent < 1 then
        anim_to_play = "3_4"
    else
        anim_to_play = "1"
    end
    return anim_to_play
end

local function onhealthchange(inst, old_percent, new_percent)
        
    if old_percent <= 0 and new_percent > 0 then makeobstacle(inst) end
    if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end

    local anim_to_play = resolveanimtoplay(new_percent)
    if new_percent > 0 then	
        inst.AnimState:PushAnimation(anim_to_play, false)		
    else
        inst.AnimState:PlayAnimation(anim_to_play)		
    end
end
    
local function itemfn(inst)

    local inst = CreateEntity()
    inst:AddTag("wallbuilder")
        
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
        
    inst.AnimState:SetBank("cloud_wall")
    inst.AnimState:SetBuild("cloud_wall")
    inst.AnimState:PlayAnimation("1_4")
    inst.Transform:SetScale(CFG.CLOUD_WALL.SCALE * 0.6, CFG.CLOUD_WALL.SCALE * 0.6, CFG.CLOUD_WALL.SCALE * 0.6)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.CLOUD_WALL.STACK_SIZE

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("cloud_wall_item")
        
    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = CFG.CLOUD_WALL.REPAIR_MATERIAL
    inst.components.repairer.healthrepairvalue = CFG.CLOUD_WALL.REPAIR_VALUE
    inst.components.repairer.workrepairvalue = CFG.CLOUD_WALL.WORK_REPAIR
        
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall
    inst.components.deployable.test = test_wall
    inst.components.deployable.min_spacing = 0
    inst.components.deployable.placer = "cloud_wall_placer"
        
    return inst
end

local function onhit(inst)
    local healthpercent = inst.components.health:GetPercent()
    local anim_to_play = resolveanimtoplay(healthpercent)
    if healthpercent > 0 then		
        inst.AnimState:PushAnimation(anim_to_play, false)	
    else inst.components.lootdropper:DropLoot() end	

end

local function onrepaired(inst)
    makeobstacle(inst)
end
        
local function onload(inst, data)
    makeobstacle(inst)
    if inst.components.health:GetPercent() <= 0 then
        clearobstacle(inst)
    end
end

local function onremoveentity(inst)
    clearobstacle(inst)
end

local function fn(inst)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst:AddTag("wall")
    MakeObstaclePhysics(inst, .5)    
    inst.entity:SetCanSleep(false)
    anim:SetBank("cloud_wall")
    anim:SetBuild("cloud_wall")
    anim:PlayAnimation("1_2", false)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

        
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("cloudwallloot")
                
    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = "cloud_cotton"
    inst.components.repairable.announcecanfix = true

    inst.components.repairable.onrepaired = onrepaired
        
    inst.Transform:SetScale(CFG.CLOUD_WALL.SCALE, CFG.CLOUD_WALL.SCALE, CFG.CLOUD_WALL.SCALE)

    inst:AddComponent("combat")
    inst.components.combat.onhitfn = onhit
        
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(maxhealth)
    inst.components.health.currenthealth = maxhealth / 2
    inst.components.health.ondelta = onhealthchange
    inst.components.health.nofadeout = true
    inst.components.health.canheal = false
    inst.components.health.fire_damage_scale = 0
    inst:AddTag("noauradamage")

    inst.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")		
        
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(CFG.CLOUD_WALL.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onmined)
    inst.components.workable:SetOnWorkCallback(onhit) 

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(CFG.CLOUD_WALL.PROX_NEAR, CFG.CLOUD_WALL.PROX_FAR)
    inst.components.playerprox:SetOnPlayerNear(allowentry)
    inst.components.playerprox:SetOnPlayerFar(denyentry)
                        
    inst.OnLoad = onload
    inst.OnRemoveEntity = onremoveentity

    return inst
end

return {
    Prefab ("common/inventory/cloud_wall", fn, assets, prefabs),
    Prefab ("common/inventoryitem/cloud_wall_item", itemfn, assets, prefabs),
    MakePlacer("common/cloud_wall_placer", "cloud_wall", "cloud_wall", "1_2", false, false, true, CFG.CLOUD_WALL.SCALE),
}
