--@@ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP

local BrewingRecipeBook = modrequire 'resources.brewing_recipebook'

local Debuggable = wickerrequire 'adjectives.debuggable'


local Brewer = Class(Debuggable, function(self, inst)
    self.inst = inst
	Debuggable._ctor(self)
	self:SetConfigurationKey("BREWER")

    self.brewing = false
    self.done = false
    
    self.product = nil
    self.product_spoilage = nil
end)

local function dobrew(inst)
	inst.components.brewer.task = nil
	
	if inst.components.brewer.ondonebrewing then
		inst.components.brewer.ondonebrewing(inst)
	end
	
	inst.components.brewer.done = true
	inst.components.brewer.brewing = nil
end

function Brewer:GetTimeToBrew()
	if self.brewing then
		return self.targettime - GetTime()
	end
	return 0
end


function Brewer:CanBrew()
	return self.inst.components.container and next( self.inst.components.container.slots ) ~= nil
end


function Brewer:StartBrewing()
	if not self.done and not self.brewing then
		if self.inst.components.container then
			local spoilage_total = 0
			local spoilage_n = 0
			local ings = {}			
			for k,v in pairs (self.inst.components.container.slots) do
				table.insert(ings, v)
				if v.components.perishable then
					spoilage_n = spoilage_n + 1
					spoilage_total = spoilage_total + v.components.perishable:GetPercent()
				end
			end
			self.product_spoilage = 1
			if spoilage_total > 0 then
				self.product_spoilage = spoilage_total / spoilage_n
				self.product_spoilage = 1 - (1 - self.product_spoilage)*.5
			end
			
			local recipe = BrewingRecipeBook(ings, self.inst)

			if not recipe then return end

			self.product = recipe:GetName()
			local brewtime = recipe:GetBrewingTime()

			self.done = nil
			self.brewing = true
			
			if self.onstartbrewing then
				self.onstartbrewing(self.inst)
			end
			
			local grow_time = self:GetConfig("BASE_BREW_TIME") * brewtime
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, dobrew, "brew")

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
		
	end
end

function Brewer:OnSave()
    if self.brewing then
		local data = {}
		data.brewing = true
		data.product = self.product
		data.product_spoilage = self.product_spoilage
		local time = GetTime()
		if self.targettime and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
    elseif self.done then
		local data = {}
		data.product = self.product
		data.product_spoilage = self.product_spoilage
		data.done = true
		return data		
    end
end

function Brewer:OnLoad(data)
    if data.brewing then
		self.product = data.product
		if self.oncontinuebrewing then
			local time = data.time or 1
			self.product_spoilage = data.product_spoilage or 1
			self.oncontinuebrewing(self.inst)
			self.brewing = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dobrew, "brew")
			
			if self.inst.components.container then		
				self.inst.components.container.canbeopened = false
			end
			
		end
    elseif data.done then
		self.product_spoilage = data.product_spoilage or 1
		self.done = true
		self.product = data.product
		if self.oncontinuedone then
			self.oncontinuedone(self.inst)
		end
		if self.inst.components.container then		
			self.inst.components.container.canbeopened = false
		end
		
    end
end


function Brewer:CollectSceneActions(doer, actions, right)
    if self.done then
        table.insert(actions, _G.ACTIONS.HARVEST)
    elseif right then
		print("code undeploy")
    end
end


function Brewer:Harvest( harvester )
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot = SpawnPrefab(self.product)
				
				if loot then
					if loot and loot.components.perishable then
					loot.components.perishable:SetPercent( self.product_spoilage)
					end
					harvester.components.inventory:GiveItem(loot, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
				end
			end
			self.product = nil
		end
		
		if self.inst.components.container then		
			self.inst.components.container.canbeopened = true
		end
		
		return true
	end
end


return Brewer
