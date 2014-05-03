BindGlobal()

local assets=
{
    Asset("ANIM", "anim/ua_staves.zip"),
    Asset("ANIM", "anim/swap_ua_staves.zip"),

    Asset( "ATLAS", "images/inventoryimages/winnie_staff.xml" ),
    Asset( "IMAGE", "images/inventoryimages/winnie_staff.tex" ),
}

local prefabs = {}

local function herd_enable(inst, owner)
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x,y,z, 20, {"beefalo"})

        for k,v in pairs(ents) do
            if v.components.follower and not v.components.follower.leader  and not owner.components.leader:IsFollower(v) and owner.components.leader.numfollowers < 5 then
                owner.components.leader:AddFollower(v)
                TheMod:DebugSay("Follower is ", v.prefab)
            end
        end

        for k,v in pairs(owner.components.leader.followers) do
            if k:HasTag("beefalo") and k.components.follower then
                k.components.follower:AddLoyaltyTime(1)
                if not k.components.sanityaura then
                    k:AddComponent("sanityaura")
                end
                k.components.sanityaura.aura = TUNING.SANITYAURA_LARGE
            end
        end
    end          
end 

local function herd_disable(inst, owner)
    if inst.updatetask then
        inst.updatetask:Cancel()
        inst.updatetask = nil
    end    
    local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner
    if owner and owner.components.leader then
        local x,y,z = owner.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(x,y,z, 20, {"beefalo"})

        for k,v in pairs(ents) do
            if v.components.follower and owner.components.leader:IsFollower(v) then
                GetPlayer().components.leader:RemoveFollower(v)
                v.components.follower:SetLeader(nil)
                v:RemoveComponent("sanityaura")
				if v.brain and v.brain.bt then
					v.brain.bt:Reset()
				end
                TheMod:DebugSay("Removing follower ",v.prefab)
            end
        end
    end 
    GetPlayer().components.leader:RemoveFollowersByTag("beefalo")    
end    

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_object", "swap_ua_staves", "purplestaff")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")
	if inst.updatetask then
		inst.updatetask:Cancel()
	end
    inst.updatetask = inst:DoPeriodicTask(1, herd_enable, 1)
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")
    herd_disable(inst, owner) 
end

local function fn(Sim)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
    
    anim:SetBank("staffs")
    anim:SetBuild("ua_staves")
    anim:PlayAnimation("orangestaff")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/winnie_staff.xml"
    
    inst:AddComponent("equippable")
    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)  
    
    return inst
end

return Prefab( "common/inventory/winnie_staff", fn, assets) 

