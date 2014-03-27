BindGlobal()

local assets =
{
	Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
	"balloon",
	"hound",
}

local Game = wickerrequire "utils.game"

local cfg = wickerrequire("adjectives.configurable")("BALLOON_HOUND")


local function new_dummy_entity()
	local inst = CreateEntity()
	inst.persists = false
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	return inst
end

local make_ground_shadow = (function()
	local UPDATE_PERIOD = 0.1

	local function get_height(inst)
		local x, y = inst.Transform:GetWorldPosition()
		return y
	end

	local function update_ground_shadow(shadowinst)
		shadowinst.Transform:SetPosition(0, -get_height(shadowinst.parent), 0)
	end

	local function stop_updating(shadowinst)
		if shadowinst.updatetask then
			shadowinst.updatetask:Cancel()
			shadowinst.updatetask = nil
		end
	end

	local function start_updating(shadowinst)
		if not shadowinst.updatetask and not shadowinst:IsInLimbo() and not shadowinst.parent:IsAsleep() then
			shadowinst.updatetask = shadowinst:DoPeriodicTask(UPDATE_PERIOD, update_ground_shadow)
		end
	end

	local function from_parent(f)
		return function(inst)
			return f(inst.shadowinst)
		end
	end
	
	return function(inst)
		local shadowinst = new_dummy_entity()
		inst.shadowinst = shadowinst

		shadowinst.entity:AddTransform()--:SetPosition(0, -HEIGHT, 0)
		shadowinst.entity:AddAnimState()
		shadowinst.entity:AddDynamicShadow():SetSize(2.5, 1.5)
		shadowinst.AnimState:SetBank("hound")
		shadowinst.AnimState:SetBuild("hound")
		shadowinst.AnimState:PlayAnimation("nonexistent")

		shadowinst:ListenForEvent("exitlimbo", start_updating)
		shadowinst:ListenForEvent("enterlimbo", stop_updating)
		shadowinst:ListenForEvent("entitywake", from_parent(start_updating), inst)
		shadowinst:ListenForEvent("entersleep", from_parent(stop_updating), inst)

		inst:AddChild(shadowinst)

		start_updating(shadowinst)
	end
end)()

local function configure_balloon(balloon, data)
	data = data or balloon.data or {}
	balloon.data = data

	balloon.AnimState:OverrideSymbol("swap_balloon", "balloon_shapes", "balloon_"..tostring(data.id or 1))

	if not data.colour then
		local colours = cfg:GetConfig("BALLOON_COLOURS")
		data.colour = colours[math.random(#colours)]
	end
	balloon.AnimState:SetMultColour(data.colour.x, data.colour.y, data.colour.z, 1)
end

local function make_balloon(inst)
	local balloon = new_dummy_entity()
	balloon.data = data
	inst.ballooninst = balloon

	balloon.entity:AddTransform()
	balloon.entity:AddAnimState()
	balloon.entity:AddSoundEmitter()

	local scale = cfg:GetConfig("BALLOON_SCALE")
	balloon.Transform:SetScale(scale, scale, scale)

	local follower = balloon.entity:AddFollower()
	follower:FollowSymbol( inst.GUID, "hound_body", 20*scale, -260 + 50*scale, -0.1 )

	balloon.AnimState:SetBank("balloon")
	balloon.AnimState:SetBuild("balloon")
	balloon.AnimState:PlayAnimation("idle", true)
	balloon.AnimState:SetTime(math.random()*2)
	balloon.AnimState:SetRayTestOnBB(true)
	
	balloon:ListenForEvent("onremove", function() balloon:Remove() end, inst)

	configure_balloon(balloon)
end

local function set_floating(inst)
	inst.grounded = false

	inst.DynamicShadow:Enable(false)
	inst.shadowinst:ReturnToScene()
	inst.ballooninst:ReturnToScene()

	inst.ballooninst.SoundEmitter:PlaySound("dontstarve/common/balloon_bounce")

	-- FIXME: remove this once we have a custom brain for the floating state.
	inst:StopBrain()
	inst:SetBrain(nil)
end

local function set_grounded(inst)
	inst.Physics:SetDamping(0.5)
	inst.Physics:SetMotorVel(1, 0, 0)
	inst.Physics:SetMotorVel(0, 0, 0)

	inst.grounded = true

	inst.ballooninst:RemoveFromScene()

	inst:StopBrain()

	inst:StartThread(function()
		if not inst:IsValid() then return end

		local period = 0.1
		local epsilon = 0.2
		local x, y = inst.Transform:GetWorldPosition()

		while inst:IsValid() and not inst:IsAsleep() and y > epsilon do
			Sleep(period)
			x, y = inst.Transform:GetWorldPosition()
		end

		if not inst:IsValid() then return end

		inst.Physics:SetDamping(5)

		inst.shadowinst:RemoveFromScene()
		inst.DynamicShadow:Enable(true)
		do
			local x, y, z = inst.Transform:GetWorldPosition()
			inst.Physics:Teleport(x, 0, z)
		end

		inst:SetBrain(require "brains/houndbrain")
		inst:RestartBrain()
	end)
end

local function pop_balloon(inst)
	if inst.grounded then return end

	inst.grounded = true

	local balloon = inst.ballooninst

	balloon.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
	balloon:DoTaskInTime(0, function(balloon)
		-- I don't know why this is necessary. The first sound simply doesn't
		-- play.
		balloon.SoundEmitter:PlaySound("dontstarve/common/balloon_pop")
	end)
	balloon.AnimState:PlayAnimation("pop")

	Game.ListenForEventOnce(balloon, "animover", function() set_grounded(inst) end)
end

local function OnSave(inst, data)
	if inst.grounded then
		data.grounded = true
	end
	data.balloondata = inst.ballooninst.data
end

local function OnLoad(inst, data)
	if data then
		if data.balloondata then
			configure_balloon(inst.ballooninst, data.balloondata)
		end
		if data.grounded then
			set_grounded(inst)
		end
	end
end

local function fn(Sim)
	local inst = SpawnPrefab("hound")

	--------------------------------------
	
	make_ground_shadow(inst)
	make_balloon(inst)

	--------------------------------------
	
	set_floating(inst)

	--------------------------------------
	
	inst:ListenForEvent("attacked", pop_balloon)
	inst:ListenForEvent("death", pop_balloon)

	--------------------------------------
	
	-- FIXME: for debugging purposes, remove later.
	function inst:SetHeight(h)
		local x, y, z = self.Transform:GetWorldPosition()
		self.Transform:SetPosition(x, h, z)
	end
	function inst:Pop()
		pop_balloon(self)
	end

	return inst
end

return Prefab ("monsters/balloon_hound", fn, assets, prefabs) 
