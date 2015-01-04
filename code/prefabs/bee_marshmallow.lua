BindGlobal()

local CFG = TheMod:GetConfig()

local beecommon = require "brains/beecommon"

local workersounds = 
{
    takeoff = "dontstarve/bee/bee_takeoff",
    attack = "dontstarve/bee/bee_attack",
    buzz = "dontstarve/bee/bee_fly_LP",
    hit = "dontstarve/bee/bee_hurt",
    death = "dontstarve/bee/bee_death",
}

local killersounds = 
{
    takeoff = "dontstarve/bee/killerbee_takeoff",
    attack = "dontstarve/bee/killerbee_attack",
    buzz = "dontstarve/bee/killerbee_fly_LP",
    hit = "dontstarve/bee/killerbee_hurt",
    death = "dontstarve/bee/killerbee_death",
}

local assets=
{
    Asset("ANIM", "anim/bee_marshmallow.zip"),
    Asset("ANIM", "anim/bee_angry_build.zip"),
    Asset("ANIM", "anim/bee_build.zip"),
    Asset("ANIM", "anim/bee.zip"),
    Asset("SOUND", "sound/bee.fsb"),

    Asset( "ATLAS", inventoryimage_atlas("bee_marshmallow") ),
    Asset( "IMAGE", inventoryimage_texture("bee_marshmallow") ), 
}
    
local prefabs = CFG.BEE_MARSHMALLOW.PREFABS

SetSharedLootTable( "bee_marshmallow", CFG.BEE_MARSHMALLOW.LOOT)

local workerbrain = require("brains/beebrain")
local killerbrain = require("brains/killerbeebrain")


local function KillerRetarget(inst)
    return FindEntity(inst, 8, function(guy)
        return (guy:HasTag("character") or guy:HasTag("animal") or guy:HasTag("monster") )
            and not guy:HasTag("insect")
            and inst.components.combat:CanTarget(guy)
    end)
end

local function onunchargefn(inst)
  
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(CFG.BEE_MARSHMALLOW.UNCHARGED_SCALE, CFG.BEE_MARSHMALLOW.UNCHARGED_SCALE, CFG.BEE_MARSHMALLOW.UNCHARGED_SCALE)
    inst:RemoveTag("scarytoprey")
    inst.components.health:SetMaxHealth(CFG.BEE_MARSHMALLOW.UNCHARGED_HEALTH)
    inst.components.combat:SetDefaultDamage(CFG.BEE_MARSHMALLOW.UNCHARGED_DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.BEE_MARSHMALLOW.UNCHARGED_ATTACK_PERIOD)
    if not inst.components.pollinator then
        inst:AddComponent("pollinator")   
    end
    inst:SetBrain(workerbrain)
    inst.sounds = workersounds

    return inst
end

local function onchargefn(inst) 
 
    inst:AddTag("scarytoprey")
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(CFG.BEE_MARSHMALLOW.CHARGED_SCALE, CFG.BEE_MARSHMALLOW.CHARGED_SCALE, CFG.BEE_MARSHMALLOW.CHARGED_SCALE)
    inst.components.health:SetMaxHealth(CFG.BEE_MARSHMALLOW.CHARGED_HEALTH)
    inst.components.combat:SetDefaultDamage(CFG.BEE_MARSHMALLOW.CHARGED_DAMAGE)
    inst.components.combat:SetAttackPeriod(CFG.BEE_MARSHMALLOW.CHARGED_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(2, KillerRetarget)
    if inst.components.pollinator then
        inst:RemoveComponent("pollinator")
    end
    inst:SetBrain(killerbrain)
    inst.sounds = killersounds    
    
    return inst
end

local function OnAttacked(inst)
    --
end    

local function OnWorked(inst, worker)
    local owner = inst.components.homeseeker and inst.components.homeseeker.home
    if owner and owner.components.childspawner then
        owner.components.childspawner:OnChildKilled(inst)
    end
    if worker.components.inventory then
        FightStat_Caught(inst)
        worker.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
    end
end

local function OnDropped(inst)
    inst.sg:GoToState("catchbreath")
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
    end
    if inst.brain then
        inst.brain:Start()
    end
    if inst.sg then
        inst.sg:Start()
    end
    if inst.components.stackable then
        while inst.components.stackable:StackSize() > 1 do
            local item = inst.components.stackable:Get()
            if item then
                if item.components.inventoryitem then
                    item.components.inventoryitem:OnDropped()
                end
                item.Physics:Teleport(inst.Transform:GetWorldPosition() )
            end
        end
    end
end

local function OnPickedUp(inst)
    inst.sg:GoToState("idle")
end

local function commonfn()
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLightWatcher()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( .8, .5 )
    inst.Transform:SetFourFaced()
 
    inst.AnimState:SetBank("bee")
    inst.AnimState:SetBuild("bee_marshmallow")    
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true);

    ----------
    
    inst:AddTag("bee")
    inst:AddTag("insect")
    inst:AddTag("hit_panic")
    inst:AddTag("smallcreature") 
   
    MakeCharacterPhysics(inst, 1, .5)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.FLYERS)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor:SetTriggersCreep(false)
    inst:SetStateGraph("SGbee")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("bee_marshmallow")

    inst:AddComponent("stackable")
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPickedUp)
    inst.components.inventoryitem.canbepickedup = false

    ---------------------
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("bee_marshmallow")
    inst.components.lootdropper.numrandomloot = CFG.BEE_MARSHMALLOW.NUMRANDOMLOOT
    
     ------------------
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(OnWorked)
   
    MakeSmallBurnableCharacter(inst, "body", Vector3(0, -1, 0))
    MakeTinyFreezableCharacter(inst, "body", Vector3(0, -1, 0))
    
    ------------------
    inst:AddComponent("health")

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"

    ------------------
    
    inst:AddComponent("sleeper")
    ------------------
    
    inst:AddComponent("knownlocations")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = CFG.BEE_MARSHMALLOW.FOODTYPE
    inst.components.edible.healthvalue = CFG.BEE_MARSHMALLOW.HEALTHVALUE
    inst.components.edible.hungervalue = CFG.BEE_MARSHMALLOW.HUNGERVALUE
    inst.components.edible.sanityvalue = CFG.BEE_MARSHMALLOW.SANITYVALUE
    
    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(onchargefn)
    inst.components.staticchargeable:SetOnUnchargeFn(onunchargefn)
    
    onunchargefn(inst)

    return inst
end

return Prefab( "forest/monsters/bee_marshmallow", commonfn, assets, prefabs)
