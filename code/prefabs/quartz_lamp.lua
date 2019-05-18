BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local function StartCharging(inst)
	inst.components.fueled.rate = -CFG.QUARTZ_TORCH.CHARGERATE
end

local function StopCharging(inst)
	inst.components.fueled.rate = CFG.QUARTZ_TORCH.FUELRATE
end

local function onEmpty(inst, owner)
    inst.SoundEmitter:KillSound("torch")
    inst.Light:Enable(false)
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	
    inst.entity:AddLight()
    inst.Light:SetRadius(CFG.QUARTZ_TORCH.RADIUS)
    inst.Light:SetFalloff(CFG.QUARTZ_TORCH.FALLOFF)
    inst.Light:SetIntensity(CFG.QUARTZ_TORCH.INTENSITY)
    inst.Light:SetColour(unpack(CFG.QUARTZ_TORCH.COLOUR))
    inst.Light:Enable(false)
    
	inst.AnimState:SetBank("torch")
    inst.AnimState:SetBuild("torch")
    inst.AnimState:PlayAnimation("idle")
	
    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)

    -----------------------------------

    --This will be changed to 'tuner' which will affect the crystals.
    --inst:AddComponent("lighter")

    -----------------------------------
    
    inst:AddComponent("inspectable")
    -----------------------------------
    
    inst:AddComponent("tradable")
    -----------------------------------
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    -----------------------------------
	
    inst:AddComponent("fueled")
	inst.components.fueled.fueltype = CFG.QUARTZ_TORCH.FUEL_TYPE
	inst.components.fueled:InitializeFuelLevel(CFG.QUARTZ_TORCH.MAX_FUEL)
    inst.components.fueled:SetDepletedFn(onEmpty)
    inst.components.fueled.accepting = false
    inst.components.fueled.rate = CFG.QUARTZ_TORCH.FUELRATE

    -----------------------------------
	
	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetOnChargedFn(StartCharging)
	inst.components.staticchargeable:SetOnUnchargedFn(StopCharging)
    -----------------------------------
	
    inst:AddTag("crystal")
    inst:AddTag("quartz")
    
    return inst
end

return Prefab ("common/inventory/quartz_lamp", fn, assets) 
