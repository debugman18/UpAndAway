BindGlobal()

local assets =
{
    Asset("ANIM", "anim/void_placeholder.zip"),
}

local function onequip(inst, owner) 
    --owner.components.combat.damage = TUNING.PICK_DAMAGE 
    owner.AnimState:OverrideSymbol("swap_object", "swap_torch", "swap_torch")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
    
    inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")
    inst.SoundEmitter:SetParameter( "torch", "intensity", 1 )

    local follower = inst.fire.entity:AddFollower()
    follower:FollowSymbol( owner.GUID, "swap_object", 0, -110, 1 )
end

local function onunequip(inst,owner) 
    owner.components.combat.damage = owner.components.combat.defaultdamage 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    inst.SoundEmitter:KillSound("torch")
    inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")        
end


local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    anim:SetBank("torch")
    anim:SetBuild("torch")
    anim:PlayAnimation("idle")
    MakeInventoryPhysics(inst)


    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.TORCH_DAMAGE)
    inst.components.weapon:SetAttackCallback(
        function(attacker, target)
            if target.components.burnable then
                if math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT*target.components.burnable.flammability then
                    target.components.burnable:Ignite()
                end
            end
        end
    )
    
    -----------------------------------
    --This will be changed to 'tuner' which will effect the crystals.
    inst:AddComponent("lighter")
    -----------------------------------
    
    inst:AddComponent("inventoryitem")
    -----------------------------------
    
    inst:AddComponent("equippable")

    inst.components.equippable:SetOnPocket( function(owner) inst.components.burnable:Extinguish()  end)
    
    inst.components.equippable:SetOnEquip( onequip )
     
    inst.components.equippable:SetOnUnequip( onunequip )
    

    -----------------------------------
    
    inst:AddComponent("inspectable")
    
    return inst
end

return Prefab ("common/inventory/quartz_torch", fn, assets) 
