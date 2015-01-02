BindGlobal()

local Configurable = wickerrequire "adjectives.configurable"
local cfg = Configurable("JELLYSHROOM")

local prefabs = {
    "cloud_jelly",
}

local picked_assets =
{
    Asset("ANIM", "anim/jelly_caps.zip"),

    Asset( "ATLAS", inventoryimage_atlas("jellycap_blue") ),
    Asset( "IMAGE", inventoryimage_texture("jellycap_blue") ),

    Asset( "ATLAS", inventoryimage_atlas("jellycap_green") ),
    Asset( "IMAGE", inventoryimage_texture("jellycap_green") ),	

    Asset( "ATLAS", inventoryimage_atlas("jellycap_red") ),
    Asset( "IMAGE", inventoryimage_texture("jellycap_red") ),			
}

local unpicked_assets =
{
    Asset("ANIM", "anim/jelly_shrooms.zip"),

    -- The unpack must be at the bottom.
    unpack(picked_assets)
}


--[[
-- Returns a random colour (as a table with 3 elements).
--
-- Receives as argument either "red", "green" and "blue", indicating
-- which colour should be stronger.
--]]
local random_colour = (function()
    local index_map = {
        red = 1,
        green = 2,
        blue = 3,
    }

    return function(major_name)
        local major = 0.6 + 0.4*math.random()
        local minor = 0.3 + 0.2*math.random()

        local ret = {minor, minor, minor}
        ret[index_map[major_name] or 1] = major
        return ret
    end
end)()

local function onpickedfn(inst)
    inst.components.pickable.cycles_left = 0
    inst:RemoveComponent("pickable")
    inst.AnimState:PlayAnimation("idle_picked")
end	

local function unpicked_setscale(inst, scale)
    inst.Transform:SetScale(scale, scale, scale)
    inst.scale = scale
end

local function unpicked_setcolour(inst, colour)
    inst.AnimState:SetMultColour( colour[1], colour[2], colour[3], 1 )  
    inst.colour = colour
end

local function unpicked_common_onsave(inst, data)
    data.scale = inst.scale
    data.colour = inst.colour
end

local function unpicked_common_onload(inst, data)
    if data then
        if data.scale then unpicked_setscale(inst, data.scale) end
        if data.colour then unpicked_setcolour(inst, data.colour) end
    end
end

local function unpickedfn_common(bank, name)
    local inst = CreateEntity()

    inst.setc = unpicked_setcolour

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    inst.AnimState:SetBank(bank) 
    inst.AnimState:SetBuild("jelly_shrooms")
    inst.AnimState:PlayAnimation("idle_sway", true)	
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    unpicked_setcolour(inst, random_colour(name))

    unpicked_setscale(inst, 0.8 + 0.6*math.random())

    inst:AddComponent("inspectable") 

    inst:AddTag("jelly")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = false

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("jellyshroom_"..name..".tex")		   

    inst.OnSave = unpicked_common_onsave
    inst.OnLoad = unpicked_common_onload

    return inst
end

local function unpickedfn_red()
    local inst = unpickedfn_common("Redjellyshroom", "red")
    if math.random(1,4) == 1 then
        inst.components.pickable:SetUp("cloud_jelly", 1, 1)
    else inst.components.pickable:SetUp("jellycap_red", 1, 1) end	
    return inst
end	

local function unpickedfn_green(inst)
    local inst = unpickedfn_common("Greenjellyshroom", "green")
    if math.random(1,4) == 1 then
        inst.components.pickable:SetUp("cloud_jelly", 1, 1)
    else inst.components.pickable:SetUp("jellycap_green", 1, 1) end	
    return inst	
end	

local function unpickedfn_blue(inst)	
    local inst = unpickedfn_common("Bluejellyshroom", "blue")
    if math.random(1,4) == 1 then
        inst.components.pickable:SetUp("cloud_jelly", 1, 1)
    else inst.components.pickable:SetUp("jellycap_blue", 1, 1) end	
    return inst
end	

-- name is currently unused.
local function pickedfn_common(bank, name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild("jelly_caps")
    inst.AnimState:PlayAnimation("idle")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")

    inst:AddTag("alchemy")
    inst:AddTag("jelly")

    inst:AddComponent("inventoryitem")	

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "VEGGIE"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("cookable")
    inst.components.cookable.product = "cloud_jelly"     
    
    return inst
end

local function pickedfn_red(Sim)
    local inst = pickedfn_common("Redcap", "red")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("jellycap_red")
    inst.components.edible.healthvalue = 20
    inst.components.edible.hungervalue = -15
    inst.components.edible.sanityvalue = -15	
    return inst
end	

local function pickedfn_green(Sim)
    local inst = pickedfn_common("Greencap", "green")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("jellycap_green")
    inst.components.edible.healthvalue = -12
    inst.components.edible.hungervalue = 20
    inst.components.edible.sanityvalue = -12		
    return inst
end	

local function pickedfn_blue(Sim)
    local inst = pickedfn_common("Bluecap", "blue")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("jellycap_blue")
    inst.components.edible.healthvalue = -10
    inst.components.edible.hungervalue = -10
    inst.components.edible.sanityvalue = 20	
    return inst
end	


return {
    Prefab ("cloudrealm/flora/jellyshroom_red", unpickedfn_red, unpicked_assets),
    Prefab ("cloudrealm/flora/jellyshroom_green", unpickedfn_green, unpicked_assets),
    Prefab ("cloudrealm/flora/jellyshroom_blue", unpickedfn_blue, unpicked_assets),		

    Prefab ("cloudrealm/inventory/jellycap_red", pickedfn_red, picked_assets),
    Prefab ("cloudrealm/inventory/jellycap_green", pickedfn_green, picked_assets),
    Prefab ("cloudrealm/inventory/jellycap_blue", pickedfn_blue, picked_assets),
}	   
