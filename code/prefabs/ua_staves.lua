BindGlobal()


local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local Configurable = wickerrequire "adjectives.configurable"
local cfg = Configurable "STAFF"


local basic_assets =
{
    Asset("ANIM", "anim/ua_staves.zip"),
    Asset("ANIM", "anim/swap_ua_staves.zip"), 
    Asset("IMAGE", "minimap/minimap_atlas.tex"),
    Asset("ATLAS", "minimap/minimap_data.xml"),

    Asset( "ATLAS", inventoryimage_atlas("blackstaff") ),
    Asset( "IMAGE", inventoryimage_texture("blackstaff") ),

    Asset( "ATLAS", inventoryimage_atlas("whitestaff") ),
    Asset( "IMAGE", inventoryimage_texture("whitestaff") ),
}

local basic_prefabs = 
{
    "staffcastfx",
    "stafflight",
}

local function make_staff(data)
    local assets = _G.JoinArrays(basic_assets, data.assets or {})
    local prefabs = _G.JoinArrays(basic_prefabs, data.prefabs or {})

    local function onfinished(inst)
        inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
        inst:Remove()
    end

    local onequip = function(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", data.swap_build or "swap_ua_staves", data.swap_symbol)
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local onunequip = function(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local postinit = data.postinit or data.custom_fn

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        MakeInventoryPhysics(inst)
        
        anim:SetBank(data.bank or "staffs")
        anim:SetBuild(data.build or "ua_staves")
        anim:PlayAnimation(data.anim)


        inst:AddTag("nopunch")


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------



        inst:AddComponent("inspectable")
        
        inst:AddComponent("inventoryitem")
        
        inst:AddComponent("equippable")
        do
            local equippable = inst.components.equippable

            equippable:SetOnEquip(onequip)
            equippable:SetOnUnequip(onunequip)
        end
        
        inst:AddComponent("finiteuses")
        do
            local finiteuses = inst.components.finiteuses

            finiteuses:SetOnFinished(onfinished)
        end


        if postinit then
            postinit(inst)
        end

        
        return inst
    end

    return Prefab( "common/inventory/"..data.name, fn, assets, prefabs)
end


local function make_black_staff()
    local function cancharge(staff, caster, target, pos)
        return target and target.components.staticchargeable
    end

    local effect_duration = cfg:GetConfig("BLACK", "EFFECT_DURATION")
    local function black_activate(staff, target, pos)
        if target and target.components.staticchargeable then
            target.components.staticchargeable:Charge()
            target.components.staticchargeable:HoldState(effect_duration)
            staff.components.finiteuses:Use(1)

            local doer = staff.components.inventoryitem and staff.components.inventoryitem.owner
            if doer and doer.SoundEmitter then
                --doer.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")  
                doer.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")
            end
        end    
    end

    return make_staff {
        name = "blackstaff",

        anim = "yellowstaff",
        swap_symbol = "yellowstaff",

        postinit = function(inst)
            do
                local finiteuses = inst.components.finiteuses

                local uses = cfg:GetConfig("BLACK", "USES")

                finiteuses:SetMaxUses(uses)
                finiteuses:SetUses(uses)

                inst.components.inventoryitem.atlasname = inventoryimage_atlas("blackstaff")
            end

            inst:AddComponent("spellcaster")
            do
                local spellcaster = inst.components.spellcaster

                spellcaster.canuseontargets = true
                spellcaster.canusefrominventory = false
                spellcaster:SetSpellTestFn(cancharge)
                spellcaster:SetSpellFn(black_activate)
            end

            --[[
            inst:AddComponent("weapon")
            do
                local weapon = inst.components.weapon

                weapon:SetDamage(0)
                weapon:SetRange(8, 10)
                weapon:SetOnAttack(black_activate)
            end
            ]]--
        end,
    }
end

local function make_white_staff()
    require "components/packer"

    local function canshrink(target)
        if target then
            return not target.components.combat or target.components.combat.defaultdamage == 0
        end
    end

    local function cancastspell(staff, caster, target, pos)
        return canshrink(target) and Pred.IsPackable(target)
    end

    local function white_activate(staff, target, pos)
        if target and target:IsValid() then
            local targetpos = target:GetPosition()
            local package = SpawnPrefab("package")
            if package then
                package.components.packer:SetCanPackFn(canshrink)
                if package.components.packer:Pack(target) then
                    package.Transform:SetPosition( targetpos:Get() )
                    staff.components.finiteuses:Use(1)
                    local doer = staff.components.inventoryitem and staff.components.inventoryitem.owner
                    if doer and doer.SoundEmitter then
                        doer.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")
                    end
                else
                    package:Remove()
                end
            end
        end    
    end

    return make_staff {
        name = "whitestaff",

        anim = "redstaff",
        swap_symbol = "greenstaff",

        postinit = function(inst)
            do
                local finiteuses = inst.components.finiteuses

                local uses = cfg:GetConfig("WHITE", "USES")

                finiteuses:SetMaxUses(uses)
                finiteuses:SetUses(uses)
                inst.components.inventoryitem.atlasname = inventoryimage_atlas("whitestaff")
            end

            inst:AddComponent("spellcaster")
            do
                local spellcaster = inst.components.spellcaster

                spellcaster.canuseontargets = true
                spellcaster.canusefrominventory = false
                spellcaster:SetSpellTestFn(cancastspell)
                spellcaster:SetSpellFn(white_activate)
            end

        end,
    }
end

return {
    make_black_staff(),
    make_white_staff(),
}
