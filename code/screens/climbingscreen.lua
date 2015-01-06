local PopupDialogScreen = require "screens/popupdialog"

---
local CustomPopup = Class(PopupDialogScreen, function(self, title, body, opts)
	PopupDialogScreen._ctor(self, title, body, opts)
end)

function CustomPopup:OnBecomeActive()
	TryPause(true)
	if PopupDialogScreen.OnBecomeActive then
		return PopupDialogScreen.OnBecomeActive(self)
	end
end

function CustomPopup:OnBecomeInactive()
	TryPause(false)
	if PopupDialogScreen.OnBecomeInactive then
		return PopupDialogScreen.OnBecomeInactive(self)
	end
end

---

local build_options

---

local ClimbingScreen = Class(CustomPopup, function(self, target_inst, direction)
	assert( Pred.IsValidEntity(target_inst), "Invalid target entity." )
	
	assert( Pred.IsString(direction), "String expected as climbing direction." )
	direction = direction:upper()

	if direction ~= "UP" and direction ~= "DOWN" then
		return error("Invalid climbing direction '"..direction.."'.")
	end

	self.target_inst = target_inst
	self.direction = direction
	self.onyes = nil
	self.onno = nil
	self.onactive = nil
	self.oninactive = nil

	local S = assert( STRINGS.UPUI.CLIMBINGSCREEN[direction] )
	CustomPopup._ctor(self, S.TITLE, S.BODY, build_options(self))
end)

function ClimbingScreen:SetOnYesFn(fn)
	assert( Pred.IsCallable(fn) )
	self.onyes = fn
end

function ClimbingScreen:SetOnNoFn(fn)
	assert( Pred.IsCallable(fn) )
	self.onno = fn
end

function ClimbingScreen:SetOnBecomeActiveFn(fn)
	assert( Pred.IsCallable(fn) )
	self.onactive = fn
end

function ClimbingScreen:SetOnBecomeInactiveFn(fn)
	assert( Pred.IsCallable(fn) )
	self.oninactive = fn
end

function ClimbingScreen:OnBecomeActive()
	if self.onactive then
		self.onactive()
	end
	return CustomPopup.OnBecomeActive(self)
end

function ClimbingScreen:OnBecomeInactive()
	if self.oninactive then
		self.oninactive()
	end
	return CustomPopup.OnBecomeInactive(self)
end

build_options = function(self)
	local inst = assert( self.target_inst )
	local S = assert( STRINGS.UPUI.CLIMBINGSCREEN[self.direction] )

    local function startadventure()
		assert( self.onyes, "OnYes callback not set." )
		self.onyes()
		TheFrontEnd:PopScreen(self)
    end
    
    local function rejectadventure()
		assert( self.onno, "OnNo callback not set." )
		self.onno()
        TheFrontEnd:PopScreen(self)
    end		

	--[[
	-- Only available when climbing UP, and only in singleplayer.
	--]]
	local function regenadventure()
		local SR = assert( S.REGEN )

        TheFrontEnd:PopScreen(self)

		local regen_screen = nil

        local function regencloud()
            inst.components.climbable:DestroyCave()
            inst.components.climbable:Climb()
			TheFrontEnd:PopScreen(regen_screen)
        end

        local function keepcloud()
            TheFrontEnd:PopScreen(regen_screen)
        end

        local regenoptions = {
            {
                text = SR.BUTTONS.YES, 
                cb = regencloud
            },

            {
                text = SR.BUTTONS.NO, 
                cb = keepcloud
            },  
        }

        regen_screen = CustomPopup(
			SR.TITLE, 
			SR.BODY,
			regenoptions)
		TheFrontEnd:PushScreen(regen_screen)
	end

	local opts = {
        {
            text = S.BUTTONS.YES, 
            cb = startadventure
        },
        {
            text = S.BUTTONS.NO, 
            cb = rejectadventure
        },
	}

	if IsSingleplayer() and self.direction == "UP" then
		table.insert(opts, {
			text = S.BUTTONS.REGEN,
			cb = regenadventure
		})
	end

	return opts
end

---

return ClimbingScreen
