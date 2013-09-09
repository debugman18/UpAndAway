--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )

--@@END ENVIRONMENT BOOTUP

local assets =
{
	Asset("ANIM", "anim/skyflies.zip"),
}

local INTENSITY = .7

local colours=
{
	{198/255,43/255,43/255},
	{79/255,153/255,68/255},
	{35/255,105/255,235/255},
	{233/255,208/255,69/255},
	{109/255,50/255,163/255},
	{222/255,126/255,39/255},
}

local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("swarm_pre")
    inst.AnimState:PushAnimation("swarm_loop", true)
    inst.Light:Enable(true)
    inst.Light:SetIntensity(0)
    inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end, function() inst:RemoveTag("NOCLICK") end)
end

local function updatelight(inst)
    if not inst.components.inventoryitem.owner then
        if not inst.lighton then
            fadein(inst)
        end
        inst.lighton = true
    end
end

local function ondropped(inst)
    inst.components.workable:SetWorkLeft(1)
    fadein(inst)
    inst.lighton = true
    inst:DoTaskInTime(2+math.random()*1, function() updatelight(inst) end)
end

local function getstatus(inst)
    if inst.components.inventoryitem.owner then
        return "HELD"
    end
end

local function onfar(inst) 
    updatelight(inst) 
end

local function onnear(inst) 
	updatelight(inst) 
end

local function onsave(inst, data)
    data.colour_idx = inst.colour_idx
end

local function onload(inst, data)
    if data then
        if data.colour_idx then
            inst.colour_idx = math.min(#colours, data.colour_idx)
            inst.AnimState:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],1)
			inst.Light:SetColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3])
        end
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    inst.entity:AddPhysics()
 
    local light = inst.entity:AddLight()
    light:SetFalloff(1)

	inst.colour_idx = math.random(#colours)
    inst.AnimState:SetMultColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3],1)
    light:SetRadius(.5)
	light:SetColour(colours[inst.colour_idx][1],colours[inst.colour_idx][2],colours[inst.colour_idx][3])
    inst.Light:Enable(true)
    inst.Light:SetIntensity(.5)	
    
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    inst.AnimState:SetBank("fireflies")
    inst.AnimState:SetBuild("skyflies")

    inst.AnimState:PlayAnimation("swarm_pre")
    inst.AnimState:PushAnimation("swarm_loop", true)
	
    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddComponent("playerprox")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(function(inst, worker)
        if worker.components.inventory then
            worker.components.inventory:GiveItem(inst, nil, Vector3(TheSim:GetScreenPos(inst.Transform:GetWorldPosition())))
            fadeout(inst)
        end
    end)

    inst:AddComponent("fader")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    inst.components.stackable.forcedropsingle = true

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnDroppedFn(ondropped)
    inst.components.inventoryitem.canbepickedup = false

    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

	--[[
    inst:ListenForEvent( "daytime", function()
        inst:DoTaskInTime(2+math.random()*1, function() updatelight(inst) end)
    end, GetWorld())
    inst:ListenForEvent( "nighttime", function()
        inst:DoTaskInTime(2+math.random()*1, function() updatelight(inst) end)
    end, GetWorld())
	--]]
	

    updatelight(inst)
    inst.OnSave = onsave
    inst.OnLoad = onload   
    return inst
end

return Prefab( "common/objects/skyflies", fn, assets) 

