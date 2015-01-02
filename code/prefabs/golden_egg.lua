--TODO: implement egg corruption in MP once Klei sets a standard for how (i.e., when they add beardlings)

BindGlobal()

local assets =
{
    Asset("ANIM", "anim/tallbird_egg.zip"),
    Asset("ANIM", "anim/golden_egg.zip"),
}

local prefabs = 
{
    "goldnugget",
    "duckraptor",
}

local cfg = wickerrequire("adjectives.configurable")("GOLDEN_EGG")
local PatchedComponents = modrequire "patched_components"
local Effects = wickerrequire "game.effects"

local function HeatFn(inst, observer)
    return inst.components.temperature:GetCurrent()	
end

local get_perish_rate = (function()
    -- Temperature for which the rate is 1.
    local base_temp = 30

    assert( base_temp > 0 )
    
    return function(inst)
        local temp = inst.components.temperature
        if not temp then return 0 end

        return math.max(
            0,
            temp:GetCurrent()/base_temp
        )
    end
end)()

local function force_drop(inst)
    local inventoryitem = inst.components.inventoryitem
    if inventoryitem then
        Effects.ThrowItemFromContainer(inst)
        inventoryitem.canbepickedup = false
    end
end

--[[
-- Changes graphical attributes based on the current temperature and charge
-- state.
--]]
local function recalculate_graphics(inst)
    if not inst:IsValid() then return end

    local temperature = inst.components.temperature
    local chargeable = inst.components.staticchargeable
    local inventoryitem = inst.components.inventoryitem

    inst.SoundEmitter:KillSound("uncomfy")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.AnimState:Resume()
    inst.AnimState:PlayAnimation("egg", true)
    if inventoryitem then
        inventoryitem:ChangeImageName("golden_egg")
    end


    if inst.corrupting then return end

    if temperature then
        if temperature:IsFreezing() then
            inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_cold_freeze", "uncomfy")
            inst.AnimState:PlayAnimation("toocold")
            inst.AnimState:SetPercent("toocold", 0.3)
            inst.AnimState:Pause()
            inst.AnimState:ClearBloomEffectHandle()
            if inventoryitem then
                inventoryitem:ChangeImageName("golden_egg_frozen")
            end
        else
            if chargeable and chargeable:IsCharged() then
                inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_steam_LP", "uncomfy")
                inst.AnimState:PlayAnimation("idle_hot", true)
            end
        end
    end
end

local function on_freeze(inst)
    recalculate_graphics(inst)
end

local function on_thaw(inst)
    recalculate_graphics(inst)
end

local function corruptegg(inst)
    inst.corrupting = true

    recalculate_graphics(inst)

    force_drop(inst)

    --inst.AnimState:SetColour(60/255,60/255,60/255)
    inst.Light:SetColour(60/255,60/255,60/255)

    local chargeable = inst.components.staticchargeable
    if chargeable and chargeable:IsCharged() then
        chargeable:HoldState(30*_G.FRAMES)
    end

    inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_jump")
    inst.AnimState:PlayAnimation("toohot")

    inst:DoTaskInTime(20*_G.FRAMES, function(inst)
        inst.corrupting = false

        inst.SoundEmitter:PlaySound("dontstarve/creatures/egg/egg_hot_explo")

        if math.random(0,100) <= 60 then
            local corruption = SpawnPrefab("duckraptor")
            corruption.Transform:SetPosition(inst.Transform:GetWorldPosition())	
        end

        local ashes = SpawnPrefab("ash")
        ashes.Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst:Remove()
    end)
end

local function on_charged(inst)
    if inst.components.inventoryitem then
        force_drop(inst)
    end

    recalculate_graphics(inst)
    
    inst:StartThread(function()
        local charge_rate = 100/cfg:GetConfig("BASE_CHARGE_TIME")
        
        local chargeable = inst.components.staticchargeable

        while true do
            if not IsDST() then
                local player = GetLocalPlayer()
                if player and player.components.sanity and player.components.sanity:IsCrazy() then
                    corruptegg(inst)
                    break
                end
            end

            local dt = 1 + math.random()
            _G.Sleep(dt)

            if not (inst:IsValid() and chargeable:IsCharged()) then
                break
            end

            local temp = inst.components.temperature
            if temp then
                temp:SetTemp( temp:GetCurrent() + dt*charge_rate )
            end
        end

        if not inst:IsValid() then return end

        if inst.components.temperature then
            inst.components.temperature:SetTemp(nil)
        end
    end)
end

local function on_uncharged(inst)
    if inst.components.inventoryitem then
        inst.components.inventoryitem.canbepickedup = true
    end

    recalculate_graphics(inst)
end

local function OnSave(inst)
    if inst.corrupting then
        return {corrupting = true}
    end
end

local function OnLoad(inst, data)
    if data and data.corrupting then
        corruptegg(inst)
    end
end

local function fn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("egg")
    inst.AnimState:SetBuild("golden_egg")
    inst.AnimState:PlayAnimation("egg")

    inst.Transform:SetScale(1.2, 1.2, 1.2)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    --[[
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    ]]--

    inst:AddComponent("inspectable")

    inst:AddComponent("staticchargeable")
    do
        local chargeable = inst.components.staticchargeable

        chargeable:SetOnChargedFn(on_charged)
        chargeable:SetOnUnchargedFn(on_uncharged)

        chargeable:SetOnChargedDelay(math.random())
        chargeable:SetOnUnchargedDelay(0.5*math.random())
    end

    inst:AddComponent("inventoryitem")
    do
        local inventoryitem = inst.components.inventoryitem

        inventoryitem.atlasname = inventoryimage_atlas("golden_egg")

        
    end

    inst:AddComponent("temperature")
    do
        local temperature = inst.components.temperature

        temperature.maxtemp = cfg:GetConfig "MAX_TEMP"
        temperature.mintemp = cfg:GetConfig "MIN_TEMP"
        temperature.current = cfg:GetConfig "INITIAL_TEMP"
        temperature.inherentinsulation = TUNING.INSULATION_MED

        inst:AddTag("show_temperature")

        inst:ListenForEvent("startfreezing", function(inst)
            on_freeze(inst)
        end)

        inst:ListenForEvent("stopfreezing", function(inst)
            on_thaw(inst)
        end)
    end

    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn

    PatchedComponents.Add(inst, "flexible_perishable")
    do
        local perishable = inst.components.perishable

        perishable.onperishreplacement = "goldnugget"
        perishable:SetPerishTime(cfg:GetConfig("BASE_PERISH_TIME"))
        perishable:SetRate(get_perish_rate)
        perishable:StartPerishing()
    end
    inst:AddTag("show_spoilage")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
    
    inst.entity:AddLight()
    inst.Light:SetRadius(.4)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,165/255,12/255)
    inst.Light:Enable(true)
    inst.Light:SetDisableOnSceneRemoval(false)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    inst:ListenForEvent("entitywake", recalculate_graphics)

    recalculate_graphics(inst)

    return inst
end

return Prefab ("common/inventory/golden_egg", fn, assets, prefabs) 
