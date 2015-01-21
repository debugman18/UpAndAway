BindGlobal()

local CFG = TheMod:GetConfig()

local assets=
{
	Asset("ANIM", "anim/umbrella.zip"),
	Asset("ANIM", "anim/swap_shopkeep_umbrella.zip"),
}
  
local function UpdateSound(inst)
    local soundShouldPlay = GetPseudoSeasonManager():IsRaining() and inst.components.equippable:IsEquipped()
    if soundShouldPlay ~= inst.SoundEmitter:PlayingSound("umbrellarainsound") then
        if soundShouldPlay then
		    inst.SoundEmitter:PlaySound("dontstarve/rain/rain_on_umbrella", "umbrellarainsound") 
        else
		    inst.SoundEmitter:KillSound("umbrellarainsound")
		end
    end
end  

local function onfinished(inst)
    inst:Remove()
end
    
local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_shopkeep_umbrella", "wand")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    UpdateSound(inst)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
    UpdateSound(inst)
end

local function climb_fn(inst)
    inst.components.climbable:Climb()
end   

local function direction_fn(inst)
    if TheWorld and TheWorld:HasTag("cloudrealm") then
        return "DOWN"
    else
        return "UP"
    end
end

local function get_cavenum(inst)
    local pos = Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 9001)
    for k,v in pairs(ents) do
        if v and v:HasTag("beanstalk_climbable") then
            print(v.prefab)
            local cavenum = v.components.climbable.cavenum or 1
            inst.components.climbable.cavenum = cavenum
        end
    end
end

local function canuse_fn(inst)
    if inst.components.equippable:IsEquipped() then
        if TheWorld and TheWorld:HasTag("cloudrealm") then
            get_cavenum(inst)
            inst.components.climbable:SetDirection(-1)
        else
            get_cavenum(inst)
            inst.components.climbable:SetDirection(1)
        end
    end
    return inst.components.equippable:IsEquipped()
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()    
    MakeInventoryPhysics(inst)
    
    anim:SetBank("umbrella")
    anim:SetBuild("umbrella")
    anim:PlayAnimation("idle")
    
    inst:AddTag("sharp")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("dapperness")
    inst.components.dapperness.mitigates_rain = true

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(TUNING.UMBRELLA_DAMAGE)
    
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("useableitem")
    inst.components.useableitem:SetCanInteractFn(canuse_fn)
    inst.components.useableitem:SetOnUseFn(climb_fn)

    inst:AddComponent("climbable")
    inst.components.climbable:SetDirection(direction_fn())
    get_cavenum(inst)

    inst:ListenForEvent("rainstop", function() UpdateSound(inst) end, GetWorld()) 
	inst:ListenForEvent("rainstart", function() UpdateSound(inst) end, GetWorld()) 
    
    return inst
end

return Prefab( "common/inventory/shopkeeper_umbrella", fn, assets) 

