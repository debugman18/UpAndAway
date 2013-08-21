local assets =
{
	Asset("ANIM", "anim/shop_basic.zip"),
	Asset("SOUND", "sound/maxwell.fsb"),
}

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.75, .75 )
    inst.Transform:SetTwoFaced()

    anim:SetBank("shop")
    anim:SetBuild("shop_basic")
	anim:PlayAnimation("idle", "loop")
    
    inst:AddComponent("talker")
    inst:AddComponent("inspectable")

    --inst:ListenForEvent( "ontalk", function(inst, data) inst.AnimState:PlayAnimation("dialog_pre") inst.AnimState:PushAnimation("dial_loop", true) end)
    --inst:ListenForEvent( "donetalking", function(inst, data) inst.AnimState:PlayAnimation("dialog_pst") inst.AnimState:PushAnimation("idle", true) end)

    return inst
end

return Prefab( "common/characters/shopkeeper", fn, assets) 
