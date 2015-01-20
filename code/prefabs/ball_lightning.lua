BindGlobal()

local CFG = TheMod:GetConfig()

local prefabs = CFG.BALL_LIGHTNING.PREFABS

local assets =
{
    Asset("ANIM", "anim/ball_lightning.zip"),
}

local fx_prefabs = CFG.BALL_LIGHTNING.FX_PREFABS

local fx_assets = {

}

SetSharedLootTable("ball_lightning", CFG.BALL_LIGHTNING.LOOT)

local function charge(inst)
    inst:AddTag("ball_lightning_charged")
    inst.components.staticconductor:StartSpreading()
end

local function uncharge(inst)
    inst:RemoveTag("ball_lightning_charged")
    inst.components.staticconductor:StopSpreading()
end

local function IsAttractingPlayer(player)
    local inv = player.components.inventory
    local held_item = inv and inv:GetEquippedItem(EQUIPSLOTS.HANDS)
    return held_item and held_item:HasTag("active_magnet")
end

local ATTRACTION_RADIUS = CFG.MAGNET.ATTRACTION_RADIUS

local function FindMagnet(inst)
    local player = Game.FindClosestPlayerInRange(inst, ATTRACTION_RADIUS, IsAttractingPlayer)
    if player then
        inst.components.follower:SetLeader(player)
    else 
        inst.components.follower:SetLeader() 
    end	
end	

local function GraphicalUpdateTick(inst)
    local roll = math.random(1,3)
    if roll == 1 then
        inst.AnimState:SetMultColour(250,250,0,0)
    elseif roll == 2 then	
        inst.AnimState:SetMultColour(150,150,0,0)
    else
        inst.AnimState:SetMultColour(60,60,0,0)
    end	
end

local function UpdateTick(inst)
    local lightning = SpawnPrefab(CFG.BALL_LIGHTNING.CHILD)
    lightning.Transform:SetPosition(inst.Transform:GetWorldPosition())
    
    if not IsDedicated() then
        GraphicalUpdateTick(inst)
    end

    if IsHost() then
        FindMagnet(inst)
    end
end

local function StopUpdating(inst)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end
end

local function StartUpdating(inst)
    StopUpdating(inst)
    inst.updatetask = inst:DoPeriodicTask(0.5, IsHost() and UpdateTick or GraphicalUpdateTick)
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    local sound = inst.entity:AddSoundEmitter()	
    inst.soundtype = ""	

    inst:AddTag("ball_lightning")

    inst.AnimState:SetBank("ball_lightning")
    inst.AnimState:SetBuild("ball_lightning")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:PlayAnimation("idle", true) 

    inst.Transform:SetScale(CFG.BALL_LIGHTNING.SCALE, CFG.BALL_LIGHTNING.SCALE, CFG.BALL_LIGHTNING.SCALE)

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    StartUpdating(inst)

    inst:ListenForEvent("entitysleep", StopUpdating)
    inst:ListenForEvent("entitywake", StartUpdating)

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor:SetSlowMultiplier(CFG.BALL_LIGHTNING.SLOW_MODIFIER)
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = false }
    inst.components.locomotor.walkspeed = CFG.BALL_LIGHTNING.WALKSPEED
    inst.components.locomotor.directdrive = CFG.BALL_LIGHTNING.RUNSPEED

    local brain = require "brains/lightningballbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGlightningball")

    inst:AddComponent("staticchargeable")
    inst.components.staticchargeable:SetOnChargeFn(charge)
    inst.components.staticchargeable:SetOnUnchargeFn(uncharge)
    inst.components.staticchargeable:SetOnChargeDelay(CFG.BALL_LIGHTNING.CHARGE_DELAY)
    inst.components.staticchargeable:SetOnUnchargeDelay(CFG.BALL_LIGHTNING.UNCHARGE_DELAY)

    inst:AddComponent("follower")
    inst:AddComponent("knownlocations")

    inst:AddComponent("temperature")
    inst.components.temperature.maxtemp = CFG.BALL_LIGHTNING.MAXTEMP
    inst.components.temperature.mintemp = CFG.BALL_LIGHTNING.MINTEMP
    inst.components.temperature.current = CFG.BALL_LIGHTNING.CURRENT_TEMP
    inst.components.temperature.inherentinsulation = CFG.BALL_LIGHTNING.INSULATION

    inst:AddComponent("staticconductor")
    inst.components.staticconductor:SetRange(3)
    inst.components.staticconductor:SetDamage(4)

    inst:AddComponent("heater")	  
    inst.components.heater.heat = CFG.BALL_LIGHTNING.HEAT

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable("ball_lightning") 

    StartUpdating(inst)

    return inst
end

local function fx_fn()
    local inst = SpawnPrefab(CFG.BALL_LIGHTNING.FX)

    inst.Transform:SetScale(.8,.3,.3)
    inst.AnimState:SetMultColour(150,150,0,.1)
    inst:DoTaskInTime(0.2, function(inst)
        inst:Remove()
    end)

    return inst
end

return {
    Prefab("common/inventory/ball_lightning", fn, assets, prefabs),
    Prefab("common/ball_lightning_fx", fx_fn, fx_assets, fx_prefabs),
}
