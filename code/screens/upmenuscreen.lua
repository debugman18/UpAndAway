BindGlobal()

local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"

local platform_modstatus = nil

local function Credits()
	local ModCreditsScreen = require "screens/modcreditsscreen"
	GLOBAL.TheFrontEnd:PushScreen(ModCreditsScreen())
end

local function SetVersion(str, cache)
    local status, modstatus = pcall( function() return json.decode(str) end )
    print("decode:", status, modversion)
    if status and modstatus then
        if cache then
            SavePersistentString("modstatus", str)
        end

        if PLATFORM == "WIN32_STEAM" or PLATFORM == "LINUX_STEAM" or PLATFORM == "OSX_STEAM" then
            platform_modstatus = modstatus.steam
        else
            platform_modstatus = modstatus.standalone
        end

        if platform_modstatus then
            if platform_modstatus.modversion and string.len(platform_modstatus.modversion) > 0 then
                print(platform_modstatus.modversion)
            end
        end
    end
end

local function OnStatusQueryComplete(result, isSuccessful, resultCode)
    print("OnStatusQueryComplete", result, isSuccessful, resultCode )
    if isSuccessful and string.len(result) > 1 and resultCode == 200 then 
        print "Query made successfully."
        SetVersion(result, true)
    end
end

local function CheckModVersion(load_success, str)
    if load_success and string.len(str) > 1 then
        SetVersion(str, false)
    end    
    _G.TheSim:QueryServer("https://raw.githubusercontent.com/debugman18/UpAndAway/master/modstatus.json", function(...) OnStatusQueryComplete(...) end, "GET")
end

local function UpdateStatus()
    
end

local UpMenuScreen = Class(Screen, function(self, buttons)
	Screen._ctor(self, "UpMenuScreen")
    
    _G.TheSim:GetPersistentString("modstatus", function(...) CheckModVersion(...) end)

    if platform_modstatus and platform_modstatus.modversion then
        print(platform_modstatus.modversion)
        print("This is A.")
    end    

	self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

	--throw up the background
    self.bg = self.proot:AddChild(Image("images/globalpanels.xml", "panel_upsell.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(0.8,0.8,0.8)
	--self.bg:SetOnClick(function() TheFrontEnd:PopScreen(self) end)
	
	--title	
    self.title = self.proot:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(0, 180, 0)
    self.title:SetString("Up and Away")

	--text
    self.text = self.proot:AddChild(Text(BODYTEXTFONT, 30))
    self.text:SetVAlign(ANCHOR_TOP)

	--local character = GetPlayer().profile:GetValue("characterinthrone") or "wilson"

	local is_rog_enabled = IsDLCEnabled ~= nil and IsDLCEnabled(REIGN_OF_GIANTS)

    print("This is B.")

    self.text:SetPosition(0, -60, 0)
    self.text:SetString("You are running version '" .. modinfo.version .. "' of Up and Away.\nThe latest version of Up and Away is '" .. platform_modstatus.modversion .. "'.\nThank you for playtesting, and being a part of our mod's development!")
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(700, 350)

    if is_rog_enabled then
    	self.text:SetString("Warning: The Reign of Giants DLC may cause bugs with this mod currently.\n\n You are running version '" .. modinfo.version .. "' of Up and Away.\nThe latest version of Up and Away is '" .. platform_modstatus.modversion .. "'.\nThank you for playtesting, and being a part of our mod's development!")
    end	

	self.button = self.title:AddChild(ImageButton())
	self.button:SetPosition(0,-390,0)
	self.button:SetText("Return")
	self.button:SetOnClick( function() TheFrontEnd:PopScreen(self) end )
	self.button.text:SetColour(0,0,0,1)
	self.button:SetFont(BUTTONFONT)
	self.button:SetTextSize(40)    

	self.info_button = self.title:AddChild(ImageButton())
    self.info_button:SetPosition(-100, -290, 0)
    self.info_button:SetText("More Info")
    self.info_button:SetOnClick( function() VisitURL("http://forums.kleientertainment.com/index.php?" .. TheMod.modinfo.forumthread) end )    
	self.info_button:SetScale(.8)
	
	--Adds a mod credits button.
	self.modcredits_button = self.title:AddChild(ImageButton())
    self.modcredits_button:SetPosition(100, -290, 0)
    self.modcredits_button:SetText("Credits")
    self.modcredits_button:SetOnClick( function() Credits() end )	
    self.modcredits_button:SetScale(.8)

end)

return UpMenuScreen