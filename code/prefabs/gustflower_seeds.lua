BindGlobal()

local assets=
{
	Asset("ANIM", "anim/silk.zip"),
    Asset("ANIM", "anim/gustflower.zip"),
}

local function ondeploy (inst, pt) 
    inst = inst.components.stackable:Get()
    inst.Transform:SetPosition(pt:Get() )
    local gustflower = SpawnPrefab("gustflower")
    gustflower.Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local notags = {'NOBLOCK', 'player', 'FX'}
local function test_ground(inst, pt)
    local tiletype = GetGroundTypeAtPosition(pt)
    local ground_OK = tiletype ~= GROUND.ROCKY and tiletype ~= GROUND.ROAD and tiletype ~= GROUND.IMPASSABLE and
                        tiletype ~= GROUND.UNDERROCK and tiletype ~= GROUND.WOODFLOOR and 
                        tiletype ~= GROUND.CARPET and tiletype ~= GROUND.CHECKER and tiletype < GROUND.UNDERGROUND
    
    if ground_OK then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 4, nil, notags) -- or we could include a flag to the search?
        local min_spacing = inst.components.deployable.min_spacing or 2

        for k, v in pairs(ents) do
            if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

local function spawngustflower(inst)
    local gustflower = SpawnPrefab("gustflower")
    gustflower.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end    

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("silk")
    inst.AnimState:SetBuild("silk")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    inst.components.deployable.ondeploy = ondeploy

    inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("gustflower")
    inst.components.periodicspawner:SetOnSpawnFn(spawngustflower)
    inst.components.periodicspawner:Start()
    
    return inst
end

return {
    Prefab( "common/inventory/gustflower_seeds", fn, assets), 
    MakePlacer ("common/gustflower_seeds_placer", "gustflower", "gustflower", "idle_2"),
}
