--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/void_placeholder.zip"),
}

local game = wickerrequire "utils.game"

local function onLight(inst)
    local partner = game.FindClosestEntity(inst, 100, function(e)
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
    local partner = game.FindClosestEntity(inst, 100, function(e)
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

	inst.AnimState:SetBank("marble")
	inst.AnimState:SetBuild("void_placeholder")
	inst.AnimState:PlayAnimation("anim")

	inst:AddComponent("inspectable")

	inst:AddTag("crystal_lamp")

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = onLight
	inst.components.machine.turnofffn = onDim	

    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(4)
    inst.Light:SetFalloff(5)
    inst.Light:SetIntensity(.7)
    inst.Light:SetColour(135/255,221/255,12/255)	

	return inst
end

return Prefab ("common/inventory/crystal_lamp", fn, assets) 
