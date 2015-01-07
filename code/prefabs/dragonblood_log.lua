BindGlobal()

local CFG = TheMod:GetConfig()

local prefabs = CFG.DRAGONBLOOD.PREFABS

local assets =
{
    Asset("ANIM", "anim/dragonblood_log.zip"),

    Asset( "ATLAS", inventoryimage_atlas("dragonblood_log") ),
    Asset( "IMAGE", inventoryimage_texture("dragonblood_log") ),
}

local function FuelTaken(inst, taker)

    local function cooktest(inst, item)
        if item.components.cookable then
            return true
        end
    end

    local function oncook(inst, giver, item)
        local cooked = SpawnPrefab("ash")
        if giver and giver.components.inventory then
            giver.components.inventory:GiveItem(cooked, nil, Vector3(TheSim:GetScreenPos(taker.Transform:GetWorldPosition())))
        end
    end

    local function onrefuse(inst, item)
        TheMod:DebugSay("Item was not cookable.")
    end

    if taker.components.burnable then
        taker.components.burnable:Extinguish()
        if not (taker.prefab == ("campfire" or "coldfire")) then

            local blaze = SpawnPrefab("lavalight")
            local pt = Vector3(taker.Transform:GetWorldPosition()) + Vector3(0,.76,0)
            if blaze then

                if taker.prefab == "firepit" then
                    blaze.AnimState:SetMultColour(100,0,0,1)
                elseif taker.prefab == "coldfirepit" then
                    blaze.AnimState:SetMultColour(0,0,80,1)
                end	

                blaze.Transform:SetScale(.7,.6,.7)
                taker.components.inspectable.nameoverride = "dragonblood_firepit"

                if not taker:HasTag("dragonblood") then
                    taker:AddTag("dragonblood")
                end	

                blaze.Transform:SetPosition(pt:Get())

                taker:DoTaskInTime(0, function(taker)
                    if not taker.components.inventory then
                        print("Inventory component added.")
                        taker:AddComponent("inventory")
                    end	

                    if not taker.components.trader then
                        print("Trader component added.")
                        taker:AddComponent("trader")
                        taker.components.trader:SetAcceptTest(cooktest)
                        taker.components.trader.onaccept = oncook
                        taker.components.trader.onrefuse = onrefuse
                    end

                    taker.components.trader:Enable()
                end)

                if not blaze.components.heater then
                    blaze:AddComponent("heater")
                end	

                blaze:AddComponent("propagator")
                blaze.components.propagator.propagaterange = CFG.DRAGONBLOOD.SPREAD_RANGE
                blaze.components.propagator:StartSpreading()
                blaze.components.heater.heatfn = function() return CFG.DRAGONBLOOD.HEAT end

                taker:DoTaskInTime(5.6, function() 
                    if blaze then
                        blaze:Remove()
                    end	 	
                    if taker then
                        taker.components.inspectable.nameoverride = "firepit"
                        taker.components.trader:Disable()
                    end
                end)

            end
        end
    end
end

local function HeatFn(inst, observer)
    return inst.components.temperature:GetCurrent()	
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("log")
    inst.AnimState:SetBuild("dragonblood_log")
    inst.AnimState:PlayAnimation("idle")


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("temperature")
    inst.components.temperature.maxtemp = CFG.DRAGONBLOOD.TEMPERATURE
    inst.components.temperature.mintemp = CFG.DRAGONBLOOD.TEMPERATURE
    inst.components.temperature.current = CFG.DRAGONBLOOD.TEMPERATURE
    inst.components.temperature.inherentinsulation = CFG.DRAGONBLOOD.INSULATION

    inst:AddComponent("heater")
    inst.components.heater.heatfn = HeatFn
    inst.components.heater.carriedheatfn = HeatFn

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = CFG.DRAGONBLOOD.FUEL_VALUE
    inst.components.fuel:SetOnTakenFn(FuelTaken)

    inst:AddComponent("inspectable")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = CFG.DRAGONBLOOD.STACK_SIZE

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("dragonblood_log")

    return inst
end

return Prefab ("common/inventory/dragonblood_log", fn, assets, prefabs) 
