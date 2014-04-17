BindGlobal()


local RefiningRecipeBook = modrequire 'resources.refining_recipebook'


local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local prefabs =
{
    "rocks",
    "twigs",
    "cutgrass",
}    

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

local slotpos = {
    Vector3(0,64+32+8+4,0), 
    Vector3(0,32+4,0),
    Vector3(0,-(32+4),0), 
    Vector3(0,-(64+32+8+4),0)
}

local widgetbuttoninfo = {
    text = "Refine",
    position = Vector3(0, -165, 0),
    fn = function(inst)
        inst.components.brewer:StartBrewing( GetPlayer() )  
    end,
        
    validfn = function(inst)
        return inst.components.brewer:CanBrew()
    end,
}

local function itemtest(inst, item, slot)
    return (item:HasTag("refinable")) 
        or item.prefab == "beanstalk_chunk"
        or item.prefab == "cloud_coral_fragment"
        or item.prefab == "cloud_algae_fragment"
        or item.prefab == "cloud_cotton"
end

--[[
--The following is unused.

local function ShouldAcceptItem(inst, item)
    if item then
        if item:HasTag("coral") then
        	print "Rock from..."
        	return true
        end
        
        if item:HasTag("algae")  then
			print "Twigs from..."
			return true
		end

        return true
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item then
        if item:HasTag("coral") then
            print "Coral taken."
            local refined1 = SpawnPrefab("rocks")
            
            if refined1 then 
                refined1.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())             
            end            
        end

        if item:HasTag("algae") then
        	print "Algae taken."
            local refined2 = SpawnPrefab("cutgrass")
            
            if refined2 then
                refined2.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())    
            end         	
        end

        if item:HasTag("beanstalk_chunk") then
            print "Beanstalk taken."
            local refined3 = SpawnPrefab("twigs")

            if refined3 then
                refined3.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
            end    
        end                

        if not item:HasTag("coral") and not item:HasTag("algae") and not item:HasTag("beanstalk_chunk") then
            print "Other item taken."
            local refined4 = SpawnPrefab("ash")

            if refined4 then
                refined4.Transform:SetPosition(GetPlayer().Transform:GetWorldPosition())
            end    
        end    
    end
end

local function OnRefuseItem(inst, item)
	print "The refiner cannot accept that."
end

--]]

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	--MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

    inst:AddTag("structure")

    inst:AddComponent("brewer")
	do
		local brewer = inst.components.brewer

		brewer:SetRecipeBook(RefiningRecipeBook)
	end

    inst:AddComponent("inspectable")
        
    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(4)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_cookpot_1x4"
    inst.components.container.widgetanimbuild = "ui_cookpot_1x4"
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = false

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("refiner.tex") 

    --[[
    inst:AddComponent("trader")
    inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
    inst.components.trader.onrefuse = OnRefuseItem	
	inst.components.trader:Enable()

    inst:AddComponent("lootdropper")
    --]]

	--inst:AddComponent("inventory")

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    --inst.components.deployable.ondeploy = ondeploy

	return inst
end

return {
    Prefab ("common/inventory/refiner", fn, assets, prefabs),
    MakePlacer ("common/refiner_placer", "marble", "void_placeholder", "anim"),
}    
