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

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_torch", "swap_torch")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    
	if inst.components.fueled and not inst.components.fueled:IsEmpty() then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_LP", "torch")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")
		--inst.SoundEmitter:SetParameter( "torch", "intensity", 1 )
		
		inst.components.fueled:StartConsuming()
		inst.Light:Enable(true)
	end
end

local function onunequip(inst,owner)
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")
	
	inst.components.fueled:StopConsuming()
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
	--inst.Light:SetDisableOnSceneRemoval(false)
    inst.Light:Enable(false)
    
	inst.AnimState:SetBank("torch")
    inst.AnimState:SetBuild("torch")
    inst.AnimState:PlayAnimation("idle")
	
    MakeInventoryPhysics(inst)
	
    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)
    -----------------------------------
	
    --This will be changed to 'tuner' which will affect the crystals.
    --inst:AddComponent("lighter")
    -----------------------------------
    
    inst:AddComponent("inventoryitem")
	--inst.components.inventoryitem.atlasname = inventoryimage_atlas("crystal_fragment_quartz")
	--InventoryItems automatically enable light when dropped, so counteract that
	inst:ListenForEvent("ondropped", function(inst) inst.Light:Enable(false) end)
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
	
    --inst:AddComponent("fuel")
	--inst.components.fuel.fueltype = CFG.CRYSTAL_LAMP.FUEL_TYPE
    -----------------------------------
	
	inst:AddComponent("staticchargeable")
	inst.components.staticchargeable:SetOnChargedFn(StartCharging)
	inst.components.staticchargeable:SetOnUnchargedFn(StopCharging)
    -----------------------------------
	
    inst:AddTag("crystal")
    inst:AddTag("quartz")
    
    return inst
end

return Prefab ("common/inventory/quartz_torch", fn, assets) 
