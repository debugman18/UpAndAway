BindGlobal()


local PopupDialogScreen = require "screens/popupdialog"


local assets=
{
	Asset("ANIM", "anim/rock_stalagmite_tall.zip"),
	Asset("ANIM", "anim/beanstalk_exit.zip"),
}

local function OnActivate(inst)
	TryPause(true)
	
	local function startadventure()
		TryPause(false)	
		if inst.components.climbable then
			inst.components.climbable:Climb()
		end
	end

	local function rejectadventure()
		TryPause(false) 
		inst.components.activatable.inactive = true
		TheFrontEnd:PopScreen()
	end		
	
	local options = {
		{text="YES", cb = startadventure},
		{text="NO", cb = rejectadventure},  
	}

	TheFrontEnd:PushScreen(PopupDialogScreen(
	
	"Up and Away", 
	"Would you like to return to the world below?",
	
	options))
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    --MakeObstaclePhysics(inst, 1)
    
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("beanstalk_exit.tex")
    
    anim:SetBank("rock_stalagmite_tall")
    anim:SetBuild("beanstalk_exit")

	inst.type = math.random(2)
    inst.AnimState:PlayAnimation("full_"..inst.type)

    inst:AddComponent("climbable")
    inst.components.climbable:SetDirection("DOWN")

    --inst:AddComponent("playerprox")
    --inst.components.playerprox:SetDist(5,7)
    --inst.components.playerprox:SetOnPlayerFar(onfar)
    --inst.components.playerprox:SetOnPlayerNear(onnear)

    inst:AddComponent("inspectable")

	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
	inst.components.activatable.quickaction = true

    return inst
end

return Prefab( "common/beanstalk_exit", fn, assets) 
