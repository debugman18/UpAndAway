local Pred = wickerrequire "lib.predicates"

local Debuggable = wickerrequire "adjectives.debuggable"


--[[
-- Just to ensure the relevant predicates have been placed into Pred.
--]]
modrequire "lib.brewing"


local Brewer = HostClass(Debuggable, function(self, inst)
    self.inst = inst
    Debuggable._ctor(self, "Brewer")
    self:SetConfigurationKey("BREWER")

    self.brewing = false
    
    --[[
    -- There should NEVER be edited when configuring the component.
    -- They are internal variables.
    --]]
    self.product = nil
    self.product_spoilage = nil

    self.recipe_book = nil
end)

function Brewer:IsBrewing()
    return self.brewing
end

function Brewer:IsDone()
    return self.inst:HasTag("donebrewing")
end

function Brewer:SetDone(b)
    if b then
        self.inst:AddTag("donebrewing")
    else
        self.inst:RemoveTag("donebrewing")
    end
end

function Brewer:SetRecipeBook(book)
    assert( Pred.IsBrewingRecipeBook(book), "Brewing.RecipeBook expected as SetRecipeBook parameter." )
    self.recipe_book = book
end

local function dobrew(inst)
    inst.components.brewer.task = nil
    
    if inst.components.brewer.ondonebrewing then
        inst.components.brewer.ondonebrewing(inst)
    end
    
    inst.components.brewer:SetDone(true)
    inst.components.brewer.brewing = nil
end

function Brewer:GetTimeToBrew()
    if self:IsBrewing() then
        return self.targettime - GetTime()
    end
    return 0
end

function Brewer:StopBrewing()
    if self:IsBrewing() then
        if self.task then
            self.task:Cancel()
            self.task = nil
        end
        self.brewing = nil
        self:SetDone(false)
        if self.inst.components.inventory then
            self.inst.components.inventory.canbeopened = true
        end
    end
end

function Brewer:StartBrewing(dude)
    if not Pred.IsBrewingRecipeBook(self.recipe_book) then
        error(2, "Attempt to brew without setting a recipe book first.")
    end

    if not self:IsDone() and not self.brewing then
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
            
            local recipe = self.recipe_book(ings, self.inst, dude)

            if not recipe then return end

            self.product = recipe:GetName()
            local brewtime = recipe:GetBrewingTime()

            self:SetDone(false)
            self.brewing = true

            self.inst.components.container:Close()
            self.inst.components.container.canbeopened = false
            
            if self.onstartbrewing then
                self.onstartbrewing(self.inst)
            end
            
            local grow_time = self:GetConfig("BASE_BREW_TIME") * brewtime
            self.targettime = GetTime() + grow_time
            self.task = self.inst:DoTaskInTime(grow_time, dobrew, "brew")

            self.inst.components.container:DestroyContents()
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
    elseif self:IsDone() then
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
        self:SetDone(true)
        self.product = data.product
        if self.oncontinuedone then
            self.oncontinuedone(self.inst)
        end
        if self.inst.components.container then		
            self.inst.components.container.canbeopened = false
        end
        
    end
end


function Brewer:Harvest( harvester )
    if self:IsDone() then
        if self.onharvest then
            self.onharvest(self.inst)
        end
        self:SetDone(false)
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

---

function Brewer:OnRemoveFromEntity()
    self:SetDone(false)
end

---

return Brewer
