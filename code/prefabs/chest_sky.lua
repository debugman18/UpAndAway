BindGlobal()

local CFG = TheMod:GetConfig()

require "prefabutil"

local assets=
{
    Asset("ANIM", "anim/chest_sky.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),    	
}

local function onopen(inst) 
    inst.AnimState:PlayAnimation("open") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end 

local function onclose(inst) 
    inst.AnimState:PlayAnimation("closed") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")		
end 

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
end
    
local slotpos = {}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(slotpos, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
    end
end

local fn = function(inst)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local minimap = inst.entity:AddMiniMapEntity()
    
    --minimap:SetIcon("sky_chest.png")

    inst:AddTag("structure")
    inst.AnimState:SetBank("chest_sky")
    inst.AnimState:SetBuild("chest_sky")
    inst.AnimState:PlayAnimation("closed")

    inst.AnimState:SetScale(0.9,0.9,0.9)   

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------


    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
    inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4" 
    inst.components.container.widgetpos = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160
    
    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("common/chest_sky", fn, assets)
