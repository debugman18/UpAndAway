BindGlobal()

local assets =
{
	Asset("ANIM", "anim/cauldron.zip"),
}

local slotpos = {
	Vector3(0,64+32+8+4,0), 
	Vector3(0,32+4,0),
	Vector3(0,-(32+4),0), 
	Vector3(0,-(64+32+8+4),0)
}

local widgetbuttoninfo = {
	text = "Brew",
	position = Vector3(0, -165, 0),
	fn = function(inst)
		inst.components.brewer:StartBrewing( GetPlayer() )	
	end,
		
	validfn = function(inst)
		return inst.components.brewer:CanBrew()
	end,
}

local function itemtest(inst, item, slot)
	return (item:HasTag("alchemy"))
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("cauldron")
	inst.AnimState:SetBuild("cauldron")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("brewer")

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

	--container.onopenfn = onopen
	--container.onclosefn = onclose

	return inst
end

return Prefab ("common/inventory/cauldron", fn, assets) 
