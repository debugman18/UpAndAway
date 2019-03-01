BindGlobal()

local Game = wickerrequire "game"

local CFG = TheMod:GetConfig()

local assets=
{
	Asset("ANIM", "anim/winnie_flute.zip"),
    Asset("ATLAS", inventoryimage_atlas("winnie_flute") ),
    Asset("IMAGE", inventoryimage_texture("winnie_flute") ),    
}

local function HearWinnieFlute(inst, musician, instrument)
	if inst.components.sleeper then
	    inst.components.sleeper:AddSleepiness(10, CFG.WINNIE_FLUTE.SLEEP_TIME, inst)
	end
end


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst:AddTag("flute")
    
    inst.AnimState:SetBank("winnie_flute")
    inst.AnimState:SetBuild("winnie_flute")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = inventoryimage_atlas("winnie_flute")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.range = CFG.WINNIE_FLUTE.SLEEP_RANGE
    inst.components.instrument:SetOnHeardFn(HearWinnieFlute)
    
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
    return inst
end

return Prefab( "common/inventory/winnie_flute", fn, assets) 
