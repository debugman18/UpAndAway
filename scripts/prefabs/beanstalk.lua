--[[
-- To reduce the likelihood of bugs and to reduce code clutter, I've made loot prefabs get
-- automatically inserted here, so there's no need to specify them upfront.
--
-- I kept those I consider of "general relevance", besides loot. Feel free to readd (or erase) some
-- if you consider it more appropriate.
--]]
local prefabs = 
{
	--Mod prefabs.
	"golden_egg",
	"magic_beans",
}

local assets =
{
	Asset("ANIM", "anim/beanstalk.zip"),
	--Asset("ANIM", "anim/beanstalk_chopped.zip" ),	
	Asset("SOUND", "sound/tentacle.fsb"),
}

-- Loot specification. The field 'n' specifies how many, the field 'p'
-- the probability. 'n' defaults to 1, and so does 'p'.
local loot = {
	{"beanstalk_chunk"},
	{"beanstalk_chunk", p = 0.75},
	{"beanstalk_chunk", p = 0.5, n = 8},

	{"skeleton", p = 0.6},
	{"skeleton", p = 0.2},

	{"goldnugget", p = 0.7},
	{"goldnugget", p = 0.5},

	{"marble", p = 0.8, n = 2},

	{"cloud_turf", p = 0.5, n = 3},

	{"magic_beans", p = 0.21},
	{"magic_beans", p = 0.18},
}

--[[
-- Utility functions.
-- I wrote a framework/library for mod development that would relieve the need
-- from rewriting those, so if you'd like...
--
-- Receives a predicate and an iterator triple (such as the return from ipairs()).
--]]
local function ThereExists(p, f, s, var)
	for k, v in f, s, var do
		if p(v) then return true end
	end
	return false
end

local function IsEqualTo(x)
	return function(y)
		return x == y
	end
end

--[[
-- Ensures all the loot prefabs will be preloaded.
--
-- The test for duplicacy is not quite efficient (it's quadratic), but
-- since this will only run once per "game instance" (once on menu, once on
-- the actual game, once on each world generation) it doesn't really matter.
--]]
for _, l in ipairs(loot) do
	local name = l[1]
	assert( type(name) == "string" )
	
	if not ThereExists(IsEqualTo(name), ipairs(prefabs)) then
		table.insert(prefabs, name)
	end
end


-- Returns a function which adds the loot to an entity.
-- It didn't need to be coded as a "function which returns a function", this
-- is just for code encapsulation (and to get the same efficiency as writing
-- the preprocessing code directly in the main file).
local function NewLootAdder()
	-- Ugly name.
	-- Lists the prefabs which always drop, with multiplicity.
	local alwaysloot = {}
	
	-- Lists tables, whose first entry is a prefab name and the second one
	-- is the probability for it to drop.
	local notalwaysloot = {}

	for _, l in ipairs(loot) do
		local prefab = l[1]
		assert( type(prefab) == "string" )

		for i = 1, (l.n or 1) do
			if (l.p or 1) == 1 then
				table.insert(alwaysloot, prefab)
			else
				assert( type(l.p) == "number" )
				table.insert(notalwaysloot, {prefab, l.p})
			end
		end
	end

	return function(inst)
		local dropper = inst.components.lootdropper
		if not dropper then
			inst:AddComponent("lootdropper")
			dropper = inst.components.lootdropper
		end

		-- Non-probabilistic loot needs to be added first.
		dropper:SetLoot( alwaysloot )

		for _, t in ipairs(notalwaysloot) do
			assert( #t == 2 )
			dropper:AddChanceLoot( unpack(t) )
		end
	end
end

local AddLoot = NewLootAdder()


-- Drops an item from the sky (to be used mainly with loot).
-- 
-- @param item The item entity
-- @param center The center (on the ground) of the falling area.
-- @param min_radius Minimum radius from center it will fall on.
-- @param max_radius Maximum radius from center it will fall on.
--
-- @returns item
local function DropItemFromTheSky(item, center, min_radius, max_radius)
	local height = 35

	assert( item:is_a(EntityScript) )
	assert( center:is_a(Point) )

	min_radius = min_radius or 0
	max_radius = max_radius or 0

	assert( type(min_radius) == "number" and min_radius >= 0 )
	assert( type(max_radius) == "number" and max_radius >= 0 )

	if max_radius < min_radius then
		max_radius = min_radius
	end

	-- Angle in relation to center it should fall on (preferably).
	local theta = 2*math.pi*math.random()

	-- Offset from center on which it will reach the ground.
	local offset

	-- We try to find a valid position within the range.
	for _ = 1, 4 do
		local tentative_radius = min_radius + math.random()*(max_radius - min_radius)
		offset = FindWalkableOffset(center, theta, tentative_radius, 16)
		if offset then break end
	end

	local target_pt = center + offset

	-- If it doesn't have physics or is static (so that it won't fall), just spawn it on the ground.
	if not item.Physics or item.Physics:GetMass() == 0 then
		item.Transform:SetPosition(target_pt:Get())
		return item
	end

	-- Otherwise, things get interesting! ;]
	
	target_pt.y = height

	item.Physics:Teleport(target_pt:Get())

	return item
end

--[[
-- Drops all loot from inst from the sky.
--
-- @param inst Lootdropper entity
-- @param max_distance Maximum distance from inst loot should drop on.
--]]
local function DropLootFromTheSky(inst, max_distance)
	assert( inst:is_a(EntityScript) )

	max_distance = max_distance or 0
	assert( type(max_distance) == "number" and max_distance >= 0 )

	if not inst.components.lootdropper then return end


	local center = inst:GetPosition()

	local prefabs = inst.components.lootdropper:GenerateLoot()
	for _, v in pairs(prefabs) do
		local item = SpawnPrefab(v)
		if item then
			print("Doing item: " .. v)

			local min_radius = inst.Physics and inst.Physics:GetRadius() or 1
			local max_radius = min_radius + max_distance

			if item.Physics then
				min_radius = min_radius + (item.Physics:GetRadius() or 1)
			end

			DropItemFromTheSky(item, center, min_radius, max_radius)
		end
	end
end


local function onsave(inst, data)
	-- Lets save a bit of disk space: use nil instead of false.
	data.chopped = inst.chopped or nil
end		   

local function onload(inst, data)
	inst.chopped = data and data.chopped

	if inst.chopped then
		chopped(inst)
	end
end  

--Fixes silly string.
local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end

local function BeanstalkAdventure(cb, slot, start_world)
	local playerdata = {}
	local player = GetPlayer()
	local self = SaveGameIndex
	if player then
		playerdata = player:GetSaveRecord().data
		playerdata.leader = nil
		playerdata.sanitymonsterspawner = nil
		
	end 
		
	self.data.slots[self.current_slot].current_mode = "adventure"
	
	if self.data.slots[self.current_slot].modes.adventure then
		self.data.slots[self.current_slot].modes.adventure.playerdata = playerdata
	end
		
	self.data.slots[slot].modes.adventure = {world = start_world}
	self:Save(cb)
end

--Makes the beanstalk climbable.
local function OnActivate(inst)
	
	SetHUDPause(true)

	
	local function startadventure()
		
		local function onsaved()
			StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
			SaveGameIndex.data.slots[SaveGameIndex:GetCurrentSaveSlot()].modes.adventure = {world = 8}
		end

		local level = 8
		local slot = SaveGameIndex:GetCurrentSaveSlot()
		local character = GetPlayer().prefab
		
		SetHUDPause(false)	
				
		--SaveGameIndex:SaveCurrent(function() SaveGameIndex:FakeAdventure(onsaved, slot, level) end)
		SaveGameIndex:SaveCurrent(function() BeanstalkAdventure(onsaved, slot, level) end)
	end
	
	local function rejectadventure()
		SetHUDPause(false) 
		inst.components.activatable.inactive = true
		TheFrontEnd:PopScreen()
	end		
	
	local options = {
		{text="YES", cb = startadventure},
		{text="NO", cb = rejectadventure},  
	}

	TheFrontEnd:PushScreen(PopupDialogScreen(
	
	"Up and Away", 
	"The land above is strange and foreign. Do you want to continue?",
	
	options))
	
end


--This changes the screen some if the player is far.
local function onfar(inst)
	--TheCamera:SetDistance(100)
end

--This changes the screen some if the player is near.
local function onnear(inst)
	--TheCamera:SetDistance(100)
end

local function chopbeanstalk(inst, chopper, chops)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")		  
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")		  
	end
end

chopped = function(inst)
	inst:RemoveComponent("workable")
	inst:RemoveComponent("activatable")
	inst.AnimState:PushAnimation("idle_hole","loop")
	inst.chopped = true	
end

local function chopdownbeanstalk(inst, chopper)
	inst:RemoveComponent("workable")
	inst:RemoveComponent("activatable")

	-- I know the game uses this idiom a lot, but it's just so ugly!
	--local pt = Vector3(inst.Transform:GetWorldPosition())
	local pt = inst:GetPosition()

	inst:DoTaskInTime(.4, function() 
		local sz = 10
		GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.25, 0.03, sz, 6)
	end)

	inst.AnimState:PlayAnimation("retract",false)
	inst.AnimState:PushAnimation("idle_hole","loop")	
	--inst.components.lootdropper:DropLoot(pt)
	DropLootFromTheSky(inst, 4)
	inst.chopped = true
end

local function fn(Sim)
	--[[
	-- Engine-level components.
	--]]
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local physics = inst.entity:AddPhysics()
	local anim = inst.entity:AddAnimState()	
	local sound = inst.entity:AddSoundEmitter()
	local minimap = inst.entity:AddMiniMapEntity()

	--[[
	-- Why was this here? exitcavelight should be spawned (and set to the player's/beanstalk's position)
	-- when he exits the foreign land, just to prevent the grue from insta-killing him in case
	-- it's night. It's not really a part of entity creation.
	--
	-- I renamed it "exitlight" to avoid confusion with inst.Light (which the beanstalk currently does
	-- not have, but anyway).
	--]]
	--[[
	local exitlight = SpawnPrefab("exitcavelight")	
	exitlight.Transform:SetPosition(inst.Transform:GetWorldPosition())
	]]--
	

	--[[
	-- Engine-level components configuration (and related tags).
	--]]
	
	trans:SetScale(1.5, 1, 1.5)

	inst:AddTag("blocker")
	physics:SetMass(0) -- 0 mass means infinite mass, actually (i.e., static object).
	--physics:SetCylinder(0.6, 2)
	physics:SetCylinder(2, 24)
	physics:SetCollisionGroup(COLLISION.OBSTACLES)
	physics:SetFriction(10000)
	physics:CollidesWith(COLLISION.WORLD)
	physics:CollidesWith(COLLISION.ITEMS)
	physics:CollidesWith(COLLISION.CHARACTERS)

	anim:SetBank("tentaclepillar")
	anim:SetBuild("beanstalk")
	anim:PlayAnimation("idle", "loop")	

	minimap:SetIcon( "tentapillar.png" )

	sound:PlaySound("dontstarve/tentacle/tentapiller_idle_LP","loop")

	
	--[[
	-- Lua-level components.
	--]]

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(10, 30)
	inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)

	---------------------  
	
	inst:AddComponent("activatable")
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.OnActivate = OnActivate	
	inst.components.activatable.quickaction = true

	---------------------  
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chopbeanstalk)
	inst.components.workable:SetOnFinishCallback(chopdownbeanstalk)

	---------------------  
	
	inst:AddComponent("inspectable")
	
	---------------------
	
	inst:AddComponent("lootdropper")
	AddLoot(inst)

	---------------------
	
	inst.chopped = false
	inst.OnSave = onsave
	inst.OnLoad = onload
	return inst
end

return Prefab( "common/monsters/beanstalk", fn, assets, prefabs )
