BindGlobal()

require "prefabutil"


local CFG = TUNING.UPANDAWAY
local new_tiles = CFG.NEW_TILES


local function test_ground(inst, pt)
    return GetGroundTypeAtPosition(pt) ~= GROUND.IMPASSABLE
end

local function ondeploy(inst, pt, deployer)
    if deployer and deployer.SoundEmitter then
        deployer.SoundEmitter:PlaySound("dontstarve/wilson/dig")
    end

    local ground = GetWorld()
    if ground then
        local original_tile_type = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
        local x, y = ground.Map:GetTileCoordsAtPoint(pt.x, pt.y, pt.z)
        if x and y then
            ground.Map:SetTile(x,y, inst.data.tile)
            ground.Map:RebuildLayer( original_tile_type, x, y )
            ground.Map:RebuildLayer( inst.data.tile, x, y )
        end

        local minimap = TheSim:FindFirstEntityWithTag("minimap")
        if minimap then
            minimap.MiniMap:RebuildLayer( original_tile_type, x, y )
            minimap.MiniMap:RebuildLayer( inst.data.tile, x, y )
        end
    end

    
    -- Simply incrementing the stack size (or erasing the remove call below)
    -- was not working, and I'm not in the mood for digging into the deploy
    -- action specifics.
    local callback
    if inst.components.stackable:StackSize() <= 1 then
        local prefab = inst.prefab
        callback = function(deployer)
            local inv = deployer.components.inventory
            if inv then inv:SetActiveItem( SpawnPrefab(prefab) ) end
        end
    end

    inst.components.stackable:Get():Remove()

    if callback then callback(deployer) end
end


local assets =
{
    Asset("ANIM", "anim/turf.zip"),
}
    
local prefabs =
{
    "gridplacer",
}


local function make_test_turf(name, data)
    local function fn(Sim)
        local inst = CreateEntity()
        inst:AddTag("groundtile")
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)
            
        inst.AnimState:SetBank("turf")
        data.build = data.build or "turf"
        inst.AnimState:SetBuild(data.build)
        data.anim = assert( data.anim )
        inst.AnimState:PlayAnimation(data.anim)


        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------

    
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
            
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        if data.imagename then
            inst.components.inventoryitem:ChangeImageName(data.imagename)
        end

        data.tile = data.tile or assert( GROUND[name:upper()] )
    
        inst.data = data
            
        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploy
        inst.components.deployable.test = test_ground
        inst.components.deployable.min_spacing = 0
        inst.components.deployable.placer = "gridplacer"
    
        ---------------------  
        return inst	  
    end

    STRINGS.NAMES["TURF_" .. name:upper()] = name:gsub("^%a", string.upper) .. " Turf"
    
    return Prefab( "common/objects/turf_" .. name, fn, assets, prefabs)
end


local test_turfs = {}
for _, v in ipairs(new_tiles) do
    table.insert( test_turfs, make_test_turf("poopcloud", {anim = "carpet", imagename = "turf_carpetfloor"}) )
end


return test_turfs
