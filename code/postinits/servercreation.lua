if not IsDST() then return end


local Reflection = wickerrequire "game.reflection"


-- This adds an "Add Cloudrealm" button to server creation.
local function modCustomizationTab(self)
	--- 
	-- Imports
	--
	
	local CustomizationTab = require "widgets/customizationtab"
	local TEMPLATES = require "widgets/templates"

	---
	-- Shorthands
	--
	
	local mltabs = assert(self.multileveltabs)
	assert(#mltabs.tabs >= 2)

	local OnClickTab = Reflection.RequireUpvalue(mltabs.tabs[1].onclick, "OnClickTab")

	---
	-- Parameter computation
	--
	
	local num_multilevels0 = #mltabs.tabs
	local num_multilevels = num_multilevels0 + 1

	-- scaling factor
	local sf = num_multilevels0/num_multilevels

	-- "y" value for the buttons
	local btn_y = mltabs.tabs[1]:GetPosition().y

	-- original width of the buttons
	local btn_w0 = mltabs.tabs[2]:GetPosition().x - mltabs.tabs[1]:GetPosition().x

	-- "x" range for the buttons
	local btn_xrange = {
		mltabs.tabs[1]:GetPosition().x - btn_w0/2,
		mltabs.tabs[#mltabs.tabs]:GetPosition().x + btn_w0/2,
	}

	-- new (outer) width of the buttons
	local btn_w = sf*btn_w0

	-- original (inner) size of the buttons
	local btn_sz0 = {mltabs.tabs[1]:GetSize()}

	-- new (inner) size of the buttons
	local btn_sz = {sf*btn_sz0[1], btn_sz0[2]}

	---
	-- UI modification
	--

	table.insert(mltabs.tabs,
		mltabs:AddChild(
			TEMPLATES.TabButton(
				0, -- temporary value
				btn_y,
				"",
				function() OnClickTab(self, 3) end,
				"small"
				)
			)
		)
	
	for i, btn in ipairs(mltabs.tabs) do
		btn:SetPosition(btn_xrange[1] + (i - 1 + 0.5)*btn_w, btn_y)
		-- btn:ForceImageSize(unpack(btn_sz))
		btn:SetScale(sf, 1)
		-- btn:SetTextSize(math.floor( 1.2*sf*24 ))
	end

	--- 
	-- Backend extension
	--
	
	local DEFAULT_PRESETS = Reflection.RequireUpvalue(
		CustomizationTab.AddMultiLevel,
		"DEFAULT_PRESETS"
		)

	local DEFAULT_TAB_LOCATIONS = Reflection.RequireUpvalue(
		CustomizationTab.RefreshTabValues,
		"DEFAULT_TAB_LOCATIONS"
		)
	
	assert(DEFAULT_PRESETS[num_multilevels] == nil)
	DEFAULT_PRESETS[num_multilevels] = "SKY_LEVEL_1"

	assert(DEFAULT_TAB_LOCATIONS[num_multilevels] == nil)
	DEFAULT_TAB_LOCATIONS[num_multilevels] = "cloudrealm"

	---
	-- Finalization
	--

    self:HookupFocusMoves()
    self:UpdateMultilevelUI()
end
TheMod:AddClassPostConstruct("widgets/customizationtab", modCustomizationTab)
