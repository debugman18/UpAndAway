BindGlobal()

local Game = wickerrequire "game"

local CFG = TheMod:GetConfig()

local assets=
{
	Asset("ANIM", "anim/pan_flute.zip"),
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
    
    inst.AnimState:SetBank("pan_flute")
    inst.AnimState:SetBuild("pan_flute")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    
    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.range = CFG.WINNIE_FLUTE.SLEEP_RANGE
    inst.components.instrument:SetOnHeardFn(HearWinnieFlute)
    
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
        
    inst:AddComponent("inventoryitem")
    
    return inst
end

return Prefab( "common/inventory/winnie_flute", fn, assets) 
