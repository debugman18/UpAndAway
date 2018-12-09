local function UpMenu()
    local UpMenuScreen = require "screens/upmenuscreen"
    _G.TheFrontEnd:PushScreen(UpMenuScreen())
end	

-- Ensures the main screen has a wilson entry.
local function configureCornerDude(self, bank, build, anim)
    bank = bank or "corner_dude"
    build = build or "corner_dude"
    anim = anim or "idle"

    local shopkeeper = self.shopkeeper
    if not shopkeeper then
        local UIAnim = require "widgets/uianim"

        shopkeeper = self.left_col:AddChild(UIAnim())
        shopkeeper:SetPosition(0,-370,0)
        self.shopkeeper = shopkeeper
    end

    shopkeeper:GetAnimState():SetBank(bank)
    shopkeeper:GetAnimState():SetBuild(build)
    shopkeeper:GetAnimState():PlayAnimation(anim, true)

end

if not IsDST() then
    TheMod:AddClassPostConstruct("screens/mainscreen", function(self)
		if self.timetonewanim then
			self.timetonewanim = math.huge
		end
	end)
end

--Changes the main menu.
local function MainMenuDoInit(self)

    local Lambda = wickerrequire "paradigms.functional"

    local Configurable = wickerrequire "adjectives.configurable"

    local cfg = Configurable("UP_SPLASH")

    local ENABLED = cfg:GetConfig "ENABLED"

    ---------------------------------------------

    if cfg and ENABLED then
        
    print("Custom menu enabled.")

    local Image = require "widgets/image"
    local ImageButton = require "widgets/imagebutton"
    local Text = require "widgets/text"	
    local UIAnim = require "widgets/uianim"
    
    --We can change the background image here.
    self.bg:SetTexture("images/up_new.xml", "ps4_mainmenu.tex")
    self.bg:SetTint(100, 100, 100, 1)
    self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)	
    self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)
    
    --We can change the shield image here.
    if not IsDLCInstalled(_G.CAPY_DLC) then
        self.shield:SetTexture("images/uppanels.xml", "panel_shield.tex")
        self.shield:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.shield:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    else 
        self.banner = self.shield:AddChild(Image("images/ui.xml", "update_banner.tex"))     
    end

    --This renames the banner.
    self.updatename:SetString(modinfo.name)
    self.banner:SetPosition(0, -170, 0)	
    self.banner:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.banner:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.banner:SetTint(0,0,0,0)

    --Adds our own mod button.
    self.upandaway_button = self.updatename:AddChild(ImageButton("images/ui.xml", "update_banner.tex"))
    self.upandaway_button:SetPosition(0, -8, 0)	
    self.upandaway_button:SetOnClick( function() UpMenu() end )	

    self.up_name = self.upandaway_button:AddChild(Text(GLOBAL.BUTTONFONT, 30))
    self.up_name:SetPosition(0,8,0)	
    self.up_name:SetString(modinfo.name) -- Now " (dev)" is already appended at the modinfo level.
    self.up_name:SetColour(0,0,0,1)

    --We change Wilson to the Shopkeeper here.
    if self.wilson then
        self.wilson:Hide()
    end
    _G.TheSim:LoadPrefabs {"shopkeeper"} -- needed for its assets to be loaded.
    configureCornerDude(self, "shop", "shop_basic", "idle")
    self.shopkeeper:SetPosition(80,-330,0) -- Original is -10, -330, 0
    self.shopkeeper:SetScale(.45,.45,.45)

    --Here we wrap everything up.
    self:MainMenu()
    self.menu:SetFocus()

    -------------------------------------------------

    -- This is done here as well as before the main screen pops.
    TheMod:DebugSay("Checking tile data...")

    -- Check the number of tiles.
    local IGNORE_TILES = TheMod:GetConfig("IGNORE_TILES")

    -- Count the entries in a non-indexed table.
    local function QuantifyTable(table, name)
        local count = 0
        
        for k,v in pairs(table) do
            count = count + 1
            TheMod:DebugSay(k)
            TheMod:DebugSay(v)
        end

        TheMod:DebugSay(count.." tiles of table "..tostring(name).." counted.")

        return count
    end

    -- Ignore these (and this many) tiles.
    local IGNORE_TILES = TheMod:GetConfig("IGNORE_TILES")

    -- Check to see how many tiles there are.
    local GROUND_COUNT = _G.GROUND
    local GROUND_COUNT_QUANTIFY = QuantifyTable(GROUND_COUNT, "GROUND_COUNT")

    -- Ignore this many tiles, since they're invalid, noise or walls.
    local IGNORE_TILES_QUANTIFY = QuantifyTable(IGNORE_TILES, "IGNORE_TILES")

    -- Ignore these because they're added by us.
    local NEW_TILES = TheMod:GetConfig("NEW_TILES")
    local NEW_TILES_QUANTIFY = QuantifyTable(NEW_TILES, "NEW_TILES")

    -- Our "real" tile count.
    local TILE_COUNT = GROUND_COUNT_QUANTIFY - IGNORE_TILES_QUANTIFY - NEW_TILES_QUANTIFY

    -- We will manually set this.
    local LAST_KNOWN_COUNT = TheMod:GetConfig("LAST_KNOWN_COUNT")

    -- Pop a warning if the number of tiles isn't what it is expected to be!

    local LOW_COUNT_WARNING = "There are less tiles than expected!\nWe STRONGLY encourage you to disable Up and Away before loading your saves.\nOnce the mod has been updated, you may reenable Up and Away.\nHowever, you may need to regenerate your cloudworld once you have updated.\nOtherwise, bugs can occur."

    local HIGH_COUNT_WARNING = "There are more tiles than expected!\nWe STRONGLY encourage you to disable Up and Away before loading your saves.\nOnce the mod has been updated, you may reenable Up and Away.\nHowever, you may need to regenerate your cloudworld once you have updated.\nOtherwise, bugs can occur."

    local PopupDialogScreen = require("screens/popupdialog")

    if not self.modtilewarning then
        if TILE_COUNT > LAST_KNOWN_COUNT then
            TheMod:DebugSay(HIGH_COUNT_WARNING)
            self.modtilewarning = PopupDialogScreen("WARNING!", HIGH_COUNT_WARNING, {text="OKAY", cb = function() end}, {text="OKAY", cb = function() end})
        elseif TILE_COUNT < LAST_KNOWN_COUNT then 
            TheMod:DebugSay(LOW_COUNT_WARNING)
            self.modtilewarning = PopupDialogScreen("WARNING!", LOW_COUNT_WARNING, {text="OKAY", cb = function() end}, {text="OKAY", cb = function() end})
        end 
    end

    if self.modtilewarning then
        TheFrontEnd:PushScreen(self.modtilewarning)
    end

    -------------------------------------------------

    else
        TheMod:DebugSay("Custom menu disabled.")
    end

end

if not IsDST() then
    TheMod:AddClassPostConstruct("screens/mainscreen", MainMenuDoInit)
end

--This gives us custom worldgen screens.	
local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
	if not world_gen_options then return end

    --Check for cloudrealm.
    local Climbing = modrequire "lib.climbing"

    TheMod:DebugSay "update worldgen!"

    if Climbing.IsCloudLevelNumber(world_gen_options.level_world) then
        TheMod:DebugSay "update worldgen passed!"

        TheSim:LoadPrefabs {"MOD_"..modname}

        --This is a temporary fix because on Windows the background refuses to load
        --even though the following two lines display the correct information.
        --self.bg:SetTexture("images/bg_up.xml", "images/bg_up.tex")
        self.bg:SetTexture("images/bg_up.xml", "bg_up.tex")
        self.bg:SetTint(100, 100, 100, 1)
        self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)
        self.bg:OnEnable()	


        --We can replace the worldgen animation and strings.
        self.worldanim:GetAnimState():SetBank("generating_cloud")
        self.worldanim:GetAnimState():SetBuild("generating_cloud")
        self.worldanim:GetAnimState():PlayAnimation("idle", true)

        --[[
        -- The worldgen strings are defined in strings.lua.
        --]]
        self.worldgentext:SetString("GROWING BEANSTALK")	
        self.verbs = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.VERBS)
        self.nouns = GLOBAL.shuffleArray(STRINGS.UPUI.CLOUDGEN.NOUNS)
    end
end

--AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

--[[
-- This is quite ugly, but we need the ctor parameters.
--]]
do
    local WorldGenScreen = require "screens/worldgenscreen"
    local mt = getmetatable(WorldGenScreen)

    local old_ctor = WorldGenScreen._ctor
    WorldGenScreen._ctor = function(...)
        old_ctor(...)
        UpdateWorldGenScreen(...)
    end
    local old_call = mt.__call
    mt.__call = function(class, ...)
        local self = old_call(class, ...)
        UpdateWorldGenScreen(self, ...)
        return self
    end
end
