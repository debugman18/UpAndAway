---
-- Postinits to tweak the item tile widget, for displaying item temperature.
--
-- @author simplex




local ItemTile = require "widgets/itemtile"
local UIAnim = require "widgets/uianim"


local Lambda = wickerrequire 'paradigms.functional'


local meter_key = {}


-- The parameter is the item tile.
local function HasTemperature(self)
	local item = self.item
	return item.components.temperature and (item.components.heatededible or item:HasTag("show_temperature"))
end


--[[
-- Stacks meters horizontally.
--
-- The parameter is the item tile.
--]]
local function stack_meters(self, meters)
	local n = #meters

	local grand_image = self.bg
	local width = grand_image:GetSize() - 3

	local step = width/n
	local offset = -(width + step)/2

	for i, child in ipairs(meters) do
		child:SetScale(1/n, 1, 1)
		child:SetPosition( offset + i*step, 0, 0 )
	end
end

local function make_temperature_meter(self)
	local temp = self:AddChild(UIAnim())
	local anim = temp:GetAnimState()
	anim:SetBank("spoiled_meter")
	anim:SetBuild("temperature_meter")
	temp:SetClickable(false)

	temp:Show()

	local function SetTempPercent()
		if HasTemperature(self) then
			local temperature = self.item.components.temperature
			local p = (temperature:GetCurrent() - temperature.mintemp)/(temperature.maxtemp - temperature.mintemp)
			temp:GetAnimState():SetPercent("anim", 1 - p)
		end
	end

	self.inst:ListenForEvent("temperaturedelta", function(inst)
		SetTempPercent()
	end, self.item)

	SetTempPercent()

	return temp
end

local function tweak_itemtile_meters(self)
	local item = self.item

	local meters = {}

	if self:HasSpoilage() then
		table.insert(meters, self.spoilage)
	end
	if HasTemperature(self) then
		table.insert(meters, make_temperature_meter(self))
	end

	self.spoilage.Hide = (function()
		local oldHide = self.spoilage.Hide

		return function(spoilage)
			oldHide(spoilage)
			for _, v in ipairs(meters) do
				if v ~= spoilage then
					v:Hide()
				end
			end
		end
	end)()

	self[meter_key] = meters
end


ItemTile._ctor = (function()
	local old_ctor = ItemTile._ctor

	local ItemTileProxy = Lambda.Map(Lambda.Identity, pairs(ItemTile))
	ItemTileProxy.__newindex = function(self, k, v)
		rawset(self, k, v)
		if k == "spoilage" then
			tweak_itemtile_meters(self)
		end
	end
	setmetatable(ItemTileProxy, getmetatable(ItemTile))

	return function(self, ...)
		local oldmeta = getmetatable(self)
		setmetatable(self, ItemTileProxy)

		old_ctor(self, ...)

		setmetatable(self, oldmeta)

		local meters = self[meter_key]
		for _, meter in ipairs(meters) do
			if meter ~= self.spoilage then
				meter:Show()
			end
		end

		stack_meters(self, meters)
	end
end)()
