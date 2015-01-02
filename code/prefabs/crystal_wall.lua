BindGlobal()

require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/crystal_wall.zip"),

    Asset( "ATLAS", inventoryimage_atlas("crystal_wall_item") ),
    Asset( "IMAGE", inventoryimage_texture("crystal_wall_item") ),
}

local prefabs =
{
    "crystal_wall_item",
    "crystal_fragment_light",
    "crystal_fragment_water",
    "crystal_fragment_spire",
}

SetSharedLootTable( "crystalwallloot",
{
    {"crystal_fragment_light", .6},
    {"crystal_fragment_water", .6},
    {"crystal_fragment_spire", .6},
})

--local loot = "beanstalk_chunk"
local maxloots = 4
local maxhealth = 60

local function ondeploywall(inst, pt, deployer)
    local wall = SpawnPrefab("crystal_wall") 
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

local function makeobstacle(inst)
        
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)	
    inst.Physics:ClearCollisionMask()
    --inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:SetMass(0)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:SetActive(true)
    local ground = GetWorld()
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        --print("    at: ", pt)
        ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
    end
end

local function clearobstacle(inst)
    -- Alia: 
    -- Since we are removing the wall anytway we may as well not bother setting the physics    
       -- We had better wait for the callback to complete before trying to remove ourselves
    inst:DoTaskInTime(2*FRAMES, function() inst.Physics:SetActive(false) end)

    local ground = GetWorld()
    if ground then
        local pt = Point(inst.Transform:GetWorldPosition())
        ground.Pathfinder:RemoveWall(pt.x, pt.y, pt.z)
    end
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
        --inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
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
        
    inst.AnimState:SetBank("crystal_wall")
    inst.AnimState:SetBuild("crystal_wall")
    inst.AnimState:PlayAnimation("1_4")
    inst.Transform:SetScale(.8,.8,.8)

    -----------------------------------------------------------------------
    SetupNetwork(inst)
    -----------------------------------------------------------------------

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("crystal_wall_item")
        
    inst:AddComponent("repairer")
    inst.components.repairer.repairmaterial = "crystal"
    inst.components.repairer.healthrepairvalue = maxhealth / 6
    inst.components.repairer.workrepairvalue = TUNING.REPAIR_THULECITE_WORK
        
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploywall
    inst.components.deployable.test = test_wall
    inst.components.deployable.min_spacing = 0
    inst.components.deployable.placer = "crystal_wall_placer"
        
    return inst
end

local function onhit(inst)
    --if data.destroysound then
        --inst.SoundEmitter:PlaySound(data.destroysound)		
    --end

    local healthpercent = inst.components.health:GetPercent()
    local anim_to_play = resolveanimtoplay(healthpercent)
    if healthpercent > 0 then
        --inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
        inst.AnimState:PushAnimation(anim_to_play, false)	
    else inst.components.lootdropper:DropLoot() end	

end

local function onrepaired(inst)
    --if data.buildsound then
        --inst.SoundEmitter:PlaySound(data.buildsound)		
    --end
    makeobstacle(inst)
end
        
local function onload(inst, data)
    --print("walls - onload")
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
    anim:SetBank("crystal_wall")
    anim:SetBuild("crystal_wall")
    anim:PlayAnimation("1_2", false)
    --inst.Transform:SetScale(3,3,3)

    if not GetPseudoClock():IsDay() then
        anim:SetBloomEffectHandle("shaders/anim.ksh")
    end

    -----------------------------------------------------------------------
    SetupNetwork(inst)
    -----------------------------------------------------------------------

    inst:ListenForEvent("dusktime", function(inst) anim:SetBloomEffectHandle("shaders/anim.ksh") end, GetWorld())

    inst:ListenForEvent("daytime", function(inst) anim:SetBloomEffectHandle("") end, GetWorld())
        
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("crystalwallloot")
                
    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = "crystal"
    inst.components.repairable.announcecanfix = true

    inst.components.repairable.onrepaired = onrepaired
        
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
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onmined)
    inst.components.workable:SetOnWorkCallback(onhit) 
                        
    inst.OnLoad = onload
    inst.OnRemoveEntity = onremoveentity
        
    return inst
end

return {
    Prefab ("common/inventory/crystal_wall", fn, assets, prefabs),
    Prefab ("common/inventoryitem/crystal_wall_item", itemfn, assets, prefabs),
    MakePlacer("common/crystal_wall_placer", "crystal_wall", "crystal_wall", "1_2", false, false, true),
}
