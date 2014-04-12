BindGlobal()

local assets = {}

local prefabs = {}

local function fn(inst)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()        
    MakeInventoryPhysics(inst)
    
	return inst
end

return Prefab("cloudrealm/inventory/wind_axe", fn, assets, prefabs)