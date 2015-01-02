BindGlobal()

local basic_assets = {

    --Asset("ANIM", "anim/alchemy_potion.zip"),

    --Asset( "ATLAS", "images/inventoryimages/potion_default.xml" ),
    --Asset( "IMAGE", "images/inventoryimages/potion_default.tex" ),
}

local basic_prefabs = {
    "potion_tunnel_mound",
}

local function make_potion(data)
    local assets = _G.JoinArrays(basic_assets, data.assets or {})
    local prefabs = _G.JoinArrays(basic_prefabs, data.prefabs or {})

    local postinit = data.postinit or data.custom_fn

    local function fn()
        local inst = CreateEntity()
        inst.entity:AddTransform()

        local anim = inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        MakeInventoryPhysics(inst)
        
        anim:SetBank(data.bank or "potion_default")
        anim:SetBuild(data.build or "potion_default")
        anim:PlayAnimation(data.anim)


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------


        inst:AddComponent("inspectable")

        inst:AddComponent("edible")
        
        inst:AddComponent("inventoryitem")
        --inst.components.inventoryitem.atlasname = "images/inventoryimages/potion_"..data.name..".xml"

        inst:AddComponent("named")
        inst.components.named.possiblenames = STRINGS.POTION_NAMES
           inst.components.named:PickNewName()
        inst.components.named:SetName(inst.components.named.name.." Potion")

        if postinit then
            postinit(inst)
        end
        
        return inst
    end

    return Prefab( "common/inventory/potion_"..data.name, fn, assets, prefabs)
end

local function make_default()

    return make_potion {
    
        name = "default",
        anim = "default",

        postinit = function(inst)

            print("This is a default potion.")

        end,

    }
end

local function make_triples()

    local function oneatenfn(inst, eater)

        local health_percent = eater.components.health:GetPercent() - .05
        local sanity_percent = eater.components.sanity:GetPercent() - .05
        local hunger_percent = eater.components.hunger:GetPercent() - .05

        print(health_percent)
        print(sanity_percent)
        print(hunger_percent)

        eater.components.health:SetPercent(sanity_percent)
        eater.components.sanity:SetPercent(hunger_percent)
        eater.components.hunger:SetPercent(health_percent)

    end

    return make_potion {

        name = "triples",
        anim = "triples",

        postinit = function(inst)

            print("This is the triples potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

local function make_bearded()

    local function oneatenfn(inst, eater)
        local beardable = eater.components.ua_beardable
        if beardable then
            beardable:Cycle()
        end
    end

    return make_potion {

        name = "bearded",
        anim = "bearded",

        postinit = function(inst)

            print("This is the bearded potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

local function make_tunnel()

    local function oneatenfn(inst, eater)

        if not eater:HasTag("underground") then

            local dirtmound = SpawnPrefab("potion_tunnel_mound")
            dirtmound.persists = false
            local follower = dirtmound.entity:AddFollower()
            follower:FollowSymbol(eater.GUID, "swap_body", -60, 50, 0)
            eater:AddTag("notarget")
            eater.AnimState:SetMultColour(0,0,0,0)
            eater:AddTag("underground")

            eater:DoTaskInTime(math.random(7,15), function()
                eater:RemoveTag("notarget")
                dirtmound:Remove()
                eater:RemoveTag("underground")
                eater.AnimState:SetMultColour(255,255,255,1)
            end)
        end
    end

    return make_potion {

        name = "tunnel",
        anim = "tunnel",

        postinit = function(inst)

            print("This is the tunnel potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

local function make_dragon()

    local function oneatenfn(inst, eater)

        if not eater:HasTag("dragon") then

            eater:AddComponent("propagator")
            eater:AddTag("dragon")
            eater.components.propagator.propagaterange = 6
            eater.components.propagator:StartSpreading()

            eater.burntask = eater:DoPeriodicTask(1, function()

                if eater.components.freezable and eater.components.freezable:IsFrozen() then           
                    eater.components.freezable:Unfreeze()   
                    eater.components.health:DoFireDamage(10)   		                  
                else            
                    eater.components.health:DoFireDamage(10)
                end   

                if eater.components.sanity then
                    eater.components.sanity:DoDelta(-2)
                end

            end)

            eater:DoTaskInTime(math.random(8,12), function()
                if eater.burntask then
                    eater.burntask:Cancel()
                end
                eater.components.propagator:StopSpreading()
                eater:RemoveTag("dragon")
            end)

        end

    end

    return make_potion {

        name = "dragon",
        anim = "dragon",

        postinit = function(inst)

            print("This is the dragon potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

local function make_doubles()

    local function oneatenfn(inst, eater)

        local sanity_percent = eater.components.sanity:GetPercent() - .05
        local hunger_percent = eater.components.hunger:GetPercent() - .05

        print(sanity_percent)
        print(hunger_percent)

        eater.components.sanity:SetPercent(hunger_percent)
        eater.components.hunger:SetPercent(sanity_percent)

    end

    return make_potion {

        name = "doubles",
        anim = "doubles",

        postinit = function(inst)

            print("This is the doubles potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

local function make_haste()

    local function oneatenfn(inst, eater)
        local locomotor = eater.components.locomotor
        locomotor.bonusspeed = (locomotor.runspeed / 5) 
        locomotor:UpdateGroundSpeedMultiplier()
        eater:DoTaskInTime(math.random(4,10), function() 
            locomotor.bonusspeed = 0
            locomotor:UpdateGroundSpeedMultiplier()
        end)

    end

    return make_potion {
        name = "haste",
        anim = "haste",

        postinit = function(inst)
            print("This is the haste potion.")

            inst.components.edible:SetOnEatenFn(oneatenfn)

        end,
    }
end

return {
    make_default(),
    make_triples(),
    make_bearded(),
    --make_tunnel(),
    make_dragon(),
    make_doubles(),
    make_haste(),
}
