BindGlobal()


local PopupDialogScreen = require "screens/popupdialog"


local assets=
{
	Asset("ANIM", "anim/rock_stalagmite_tall.zip"),
	Asset("ANIM", "anim/beanstalk_exit.zip"),
}
--[[
local function onnear(inst)
	inst.AnimState:PlayAnimation("down")
    inst.AnimState:PushAnimation("idle_loop", true)
    inst.SoundEmitter:PlaySound("dontstarve/cave/rope_down")
end

local function onfar(inst)
    inst.AnimState:PlayAnimation("up")
    inst.SoundEmitter:PlaySound("dontstarve/cave/rope_up")
end
--]]

--[[
local function LeaveSky(onsavedcb)
	local playerdata = {}
	local player = GetPlayer()
	local self = SaveGameIndex
	if player then
		playerdata = player:GetSaveRecord().data
		playerdata.leader = nil
		playerdata.sanitymonsterspawner = nil
        
	end 
	self.data.slots[self.current_slot].current_mode = "survival"
	
	if self.data.slots[self.current_slot].modes.survival then
		self.data.slots[self.current_slot].modes.survival.playerdata = playerdata
	end
	self:Save(onsavedcb)
end
]]--
local function OnActivate(inst)
	SetPause(true)
	
	--local character = GetPlayer().prefab
	
	--local level = GetWorld().topology.level_number or 8
	local function startadventure()
		--[[
		local function onsaved()
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end
		
		local saveslot = SaveGameIndex:GetCurrentSaveSlot()
		local character = GetPlayer().prefab		
		
		
		SaveGameIndex:SaveCurrent(function() LeaveSky(onsaved) end)
		]]--

		SetPause(false)		
		if inst.components.climbable then
			inst.components.climbable:Climb()
		end
	end

	local function rejectadventure()
		SetPause(false) 
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
