BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    Asset("ANIM", "anim/armor_marble.zip"), --TODO
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_marble", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
	
	--Ideally, the flinger would check if any equipment has this tag. Oh well...
	if not owner.nofling_ents then --use a table for the case there are multiple items with this trait
		owner.nofling_ents = {inst = true}
		owner:AddTag("NOFLING") --makes wearer unaffected by whirlwind &c
	else
		owner.nofling_ents[inst] = true
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
	
	if owner.nofling_ents then --check out
		owner.nofling_ents[inst] = nil
		if GetTableSize(owner.nofling_ents) == 0 then --disable
			owner.nofling_ents = nil
		end
	end
	if not owner.nofling_ents then --remove if disabled or invalid
		owner:RemoveTag("NOFLING")
	end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_marble") --TODO
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("crystal")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
    inst.foleysound = "dontstarve/movement/foley/marblearmour" --For Together
    --inst.components.inventoryitem.atlasname = inventoryimage_atlas("beanlet_armor") --TODO
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(CFG.CRYSTAL_ARMOR.ARMOR_HEALTH, CFG.CRYSTAL_ARMOR.ARMOR_ABSORB)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
	
	inst:AddTag("NOFLING") --if it prevents the player from flinging, it shouldn't fling on its own
	
    return inst
end

return Prefab ("common/inventory/crystal_armor", fn, assets) 
