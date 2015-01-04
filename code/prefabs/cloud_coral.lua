BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset("ANIM", "anim/cloud_coral.zip"),
}

local prefabs = CFG.CLOUD_CORAL.PREFABS

local function grow(inst, dt)
    if inst.components.scaler.scale < 2 then
        local new_scale = math.min(inst.components.scaler.scale + CFG.CLOUD_CORAL.GROW_RATE*dt, 2)
        inst.components.scaler:SetScale(new_scale)
    else
        if inst.growtask then
            inst.growtask:Cancel()
            inst.growtask = nil
        end
    end
end

local function applyscale(inst, scale)
    inst.components.workable:SetWorkLeft(scale*CFG.CLOUD_CORAL.WORK_TIME)

    local function lootscaling()
    	local lootamount = scale*0.2

    	inst.components.lootdropper.numrandomloot = lootamount
    end
end

local function onMined(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function OnWork(inst, worker, workleft)
	local pt = Point(inst.Transform:GetWorldPosition())			
	if workleft < CFG.CLOUD_CORAL.WORK_TIME*(1/3) then
		inst.AnimState:PlayAnimation("idle_low")
	elseif workleft < CFG.CLOUD_CORAL.WORK_TIME*(2/3) then
		inst.AnimState:PlayAnimation("idle_med")
	else
		inst.AnimState:PlayAnimation("idle_full")
	end
end

local function onsave(inst, data)
	if inst.components.scaler.scale then
		data.scale = inst.components.scaler.scale
	end
end

local function onload(inst, data)
	if data and data.scale then
		inst.components.scaler:SetScale(data.scale)
	end	
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	inst.AnimState:SetBank("cloud_coral")
	inst.AnimState:SetBuild("cloud_coral")
	inst.AnimState:PlayAnimation("idle_full")

	MakeObstaclePhysics(inst, .6)

	inst.Transform:SetScale(1,1,1)

    inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("cloud_coral.tex")


	------------------------------------------------------------------------
	SetupNetwork(inst)
	------------------------------------------------------------------------
 	

	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetOnFinishCallback(onMined)
	inst.components.workable:SetWorkLeft(CFG.CLOUD_CORAL.WORK_TIME)
	inst.components.workable:SetOnWorkCallback(OnWork)

    inst:AddComponent("scaler")
    inst.components.scaler.OnApplyScale = applyscale

   	inst:AddComponent("lootdropper") 
   	inst.components.lootdropper:AddRandomLoot("cloud_coral_fragment", CFG.CLOUD_CORAL.DROP_RATE)

    local start_scale = CFG.CLOUD_CORAL.START_SCALE
    inst.components.scaler:SetScale(start_scale)
    local dt = CFG.CLOUD_CORAL.GROW_RATE
    inst.growtask = inst:DoPeriodicTask(dt, grow, nil, dt)
	
    inst.OnLongUpdate = grow
    inst.OnLoad = onload
    inst.OnSave = onsave
    
	return inst
end

return Prefab ("common/inventory/cloud_coral", fn, assets, prefabs) 
