BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/crystal_lamp.zip"),
}

local game = wickerrequire "utils.game"

local function onLight(inst)
    if inst.components.fueled.currentfuel >= 1 then
        local partner = game.FindClosestEntity(inst, 12, function(e)
            return e ~= inst and e.components.machine and not e.components.machine:IsOn()
        end, {"crystal_lamp"})

        inst.Light:Enable(true)
        inst.components.fueled:StartConsuming()

        if partner and not partner.components.machine.ison then
            partner.components.machine.turnonfn = onLight
            partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOn() end)    

            TheMod:DebugSay("Partner lamp [", partner, "] lit.")
        end  
    end      
end

--[[
local function onLight(inst)
    local partner = GLOBAL.GetClosestInstWithTag("crystal_lamp", inst, 100)

    inst.Light:Enable(true)

    if partner and not partner.components.machine.ison then
        partner.components.machine.turnonfn = onLight
        partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOn() end)	

        print "Partner lamp lit."
    end	

end
--]]

local function onDim(inst)
    local partner = game.FindClosestEntity(inst, 12, function(e)
        return e ~= inst and e.components.machine and e.components.machine:IsOn()
    end, {"crystal_lamp"})

    inst.Light:Enable(false)
    inst.components.fueled.consuming = false

    if partner and partner.components.machine.ison then
        partner.components.machine.turnofffn = onDim
        partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOff() end)    

        TheMod:DebugSay("Partner lamp [", partner, "] dimmed.")
    end    
end

--[[
local function onDim(inst)
    local partner = GLOBAL.GetClosestInstWithTag("crystal_lamp", inst, 100)
    
    inst.Light:Enable(false)

    if partner and partner.components.machine.ison then
        partner.components.machine.turnonfn = onDim
        partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOff() end)

        furtherpartner = GLOBAL.GetClosestInstWithTag("crystal_lamp", partner, 100)

        print "Partner lamp dimmed."
    end	
end
]] 

local function onEmpty(inst)
    inst.components.machine:TurnOff()  
    inst.components.machine.caninteractfn = function(inst) return false end
end  

local function onFill(inst)
    inst.components.machine:TurnOn()
    inst.components.machine.caninteractfn = function(inst) return true end
end  

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function fn(Sim)

    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 1)

    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(2.5, 1.5)

    inst.AnimState:SetBank("crystal_lamp")
    inst.AnimState:SetBuild("crystal_lamp")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.7,1.7,1.7)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddTag("crystal_lamp")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("crystal_lamp.tex")	

    inst:AddComponent("machine")
    inst.components.machine.turnonfn = onLight
    inst.components.machine.turnofffn = onDim	

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(CFG.CRYSTAL_LAMP.WORK_TIME)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("fueled")
    inst.components.fueled.maxfuel = CFG.CRYSTAL_LAMP.FUEL
    inst.components.fueled.fueltype = CFG.CRYSTAL_LAMP.FUEL_TYPE
    inst.components.fueled:SetDepletedFn(onEmpty)  
    inst.components.fueled.ontakefuelfn = onFill
    inst.components.fueled.accepting = true
    inst.components.fueled:InitializeFuelLevel(CFG.CRYSTAL_LAMP.START_FUEL)
    inst.components.fueled.rate = CFG.CRYSTAL_LAMP.FUEL_RATE

    local light = inst.entity:AddLight()
    inst:DoPeriodicTask(CFG.CRYSTAL_LAMP.FUEL_RATE, function(inst)
        if inst.components.fueled.currentfuel and inst.components.fueled.currentfuel >= 0 then
            inst.Light:SetRadius(inst.components.fueled.currentfuel / CFG.CRYSTAL_LAMP.RADIUS_MODIFIER)
        else
            if inst.components.fueled.currentfuel <= CFG.CRYSTAL_LAMP.EMPTY_VALUE then
                onEmpty(inst)
                inst.Light:SetRadius(0) 
            end
        end    
    end)
    inst.Light:Enable(false)
    inst.Light:SetFalloff(5)
    inst.Light:SetIntensity(.7)
    inst.Light:SetColour(135/255,221/255,12/255)

    return inst
end

return {
    Prefab ("common/inventory/crystal_lamp", fn, assets),
    MakePlacer ("common/crystal_lamp_placer", "crystal_lamp", "crystal_lamp", "idle", false, false, false, 1.7), 
}
