BindGlobal()

local assets =
{
	Asset("ANIM", "anim/crystal_lamp.zip"),
}

local game = wickerrequire "utils.game"

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

local function onLight(inst)
    local partner = game.FindClosestEntity(inst, 12, function(e)
        return e ~= inst and e.components.machine and not e.components.machine:IsOn()
    end, {"crystal_lamp"})

    inst.Light:Enable(true)

    if partner and not partner.components.machine.ison then
        partner.components.machine.turnonfn = onLight
        partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOn() end)    

        TheMod:DebugSay("Partner lamp [", partner, "] lit.")
    end    
end

--[[
local function onLight(inst)
	local partner = GLOBAL.GetClosestInstWithTag("crystal_lamp", inst, 100)

	inst.Light:Enable(true)

	if partner and not partner.components.machine.ison then
		partner.components.machine.turnonfn = onLight
		partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOn() end)	

		print "Partner lamp lit."
	end	

end
--]]

local function onDim(inst)
    local partner = game.FindClosestEntity(inst, 12, function(e)
        return e ~= inst and e.components.machine and e.components.machine:IsOn()
    end, {"crystal_lamp"})

    inst.Light:Enable(false)

    if partner and partner.components.machine.ison then
        partner.components.machine.turnofffn = onDim
        partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOff() end)    

        TheMod:DebugSay("Partner lamp [", partner, "] dimmed.")
    end    
end

--[[
local function onDim(inst)
	local partner = GLOBAL.GetClosestInstWithTag("crystal_lamp", inst, 100)
	
	inst.Light:Enable(false)

	if partner and partner.components.machine.ison then
		partner.components.machine.turnonfn = onDim
		partner:DoTaskInTime(0.3, function(inst, data) partner.components.machine:TurnOff() end)

		furtherpartner = GLOBAL.GetClosestInstWithTag("crystal_lamp", partner, 100)

		print "Partner lamp dimmed."
	end	
end
]]

local function fn(Sim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("crystal_lamp")
	inst.AnimState:SetBuild("crystal_lamp")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("inspectable")

	inst:AddTag("crystal_lamp")

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("crystal_lamp.tex")	

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = onLight
	inst.components.machine.turnofffn = onDim	

    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(4)
    inst.Light:SetFalloff(5)
    inst.Light:SetIntensity(.7)
    inst.Light:SetColour(135/255,221/255,12/255)

    inst:AddComponent("deployable")
    inst.components.deployable.test = test_ground
    --inst.components.deployable.ondeploy = ondeploy	

	return inst
end

return {
	Prefab ("common/inventory/crystal_lamp", fn, assets),
	MakePlacer ("common/crystal_lamp_placer", "crystal_lamp", "crystal_lamp", "idle"), 
}
