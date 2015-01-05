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

local function OnUpdate(self)
    if self.timetonewanim then
        self.timetonewanim = math.huge
    end
end	

if not IsDST() then
    TheMod:AddClassPostConstruct("screens/mainscreen", OnUpdate)
end

--Changes the main menu.
local function DoInit(self)
    --do
        --return
    --end

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


    --[[
    --This displays the current version to the user.	
    self.motd.motdtext:SetPosition(0, 10, 0)
    self.motd.motdtitle:SetString("Version Information")
    self.motd.motdtext:EnableWordWrap(true)   
    self.motd.motdtext:SetString("You are currently using version '" .. modinfo.version .. "' of Up and Away. Thank you for testing!")
    
    --This adds a button to the MOTD.
    self.motd.button = self.motd:AddChild(ImageButton())
    self.motd.button:SetPosition(0, -80, 0)
    self.motd.button:SetText("More Info")
    self.motd.button:SetOnClick( function() VisitURL("http://forums.kleientertainment.com/index.php?" .. TheMod.modinfo.forumthread) end )    
    self.motd.button:SetScale(.8)
    self.motd.motdtext:EnableWordWrap(true)
    
    --Adds a mod credits button.
    self.modcredits_button = self.motd:AddChild(ImageButton())
    self.modcredits_button:SetPosition(0, -150, 0)
    self.modcredits_button:SetText("Credits")
    self.modcredits_button:SetOnClick( function() Credits() end )	
    self.modcredits_button:SetScale(.8)
    ]]
    
    --We can change the background image here.
    self.bg:SetTexture("images/up_new.xml", "ps4_mainmenu.tex")
    self.bg:SetTint(100, 100, 100, 1)
    self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
    self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)	
    self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)
    
    --We can change the shield image here.
    self.shield:SetTexture("images/uppanels.xml", "panel_shield.tex")
    self.shield:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
    self.shield:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)

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
    self.up_name:SetString( modinfo.name ) -- Now " (dev)" is already appended at the modinfo level.
    self.up_name:SetColour(0,0,0,1)

    --We change Wilson to the Shopkeeper here.
    if self.wilson then
        self.wilson:Hide()
    end
    _G.TheSim:LoadPrefabs {"shopkeeper"} -- needed for its assets to be loaded.
    configureCornerDude(self, "shop", "shop_basic", "idle")
    self.shopkeeper:SetPosition(80,-330,0) -- Original is -10, -330, 0
    self.shopkeeper:SetScale(.45,.45,.45)

    --Here we move that pesky RoG advert.
    if self.RoGUpgrade then
        self.RoGUpgrade:SetPosition(435, 215, 0)
    end

    --Here we move the upsell, if it exists.
    if self.chester_upsell then
        self.chester_upsell:SetPosition(-70, -170, 0)
    end

    --Here we wrap everything up.
    self:MainMenu()
    self.menu:SetFocus()

    else
        print("Custom menu disabled.")
    end

end

if not IsDST() then
    TheMod:AddClassPostConstruct("screens/mainscreen", DoInit)
end

--This gives us custom worldgen screens.	
local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
	if not world_gen_options then return end

    --Check for cloudrealm.
    local Climbing = modrequire "lib.climbing"

    TheMod:DebugSay "update worldgen!"

    -- The old version only worked for the 1st save slot, because
    -- there's no selected slot in the SaveIndex when this runs.
    if Climbing.IsCloudLevelNumber(world_gen_options.level_world) then
        TheMod:DebugSay "update worldgen passed!"

        TheSim:LoadPrefabs {"MOD_"..modname}
        
        --Changes the background during worldgen.
        --[[
        local bgtest = self.bg:__tostring()
        print(bgtest)
        print("PRE")			
        ]]--

        --This is a temporary fix because on Windows the background refuses to load
        --even though the following two lines display the correct information.
        --self.bg:SetTexture("images/bg_up.xml", "images/bg_up.tex")
        self.bg:SetTexture("images/bg_up.xml", "bg_up.tex")
        --[[
        local bgtest = self.bg:__tostring()
        print(bgtest)
        print("POST")	
        ]]--
        --self.bg:SetTint(54, 189, 255, 1.0) --Red
        --self.bg:SetTint(255, 54, 189, 1.0) --Green
        --self.bg:SetTint(54, 255, 54, 1.0) --Purple
        --self.bg:SetTint(255, 255, 54, 1.0) --Blue
        self.bg:SetTint(100, 100, 100, 1)
        self.bg:SetVRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHRegPoint(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetVAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        self.bg:SetScaleMode(GLOBAL.SCALEMODE_FILLSCREEN)
        self.bg:OnEnable()	
        
        --The shadow hands can be changed.
        --[[
        local hand_scale = 1.5
        self.hand1:GetAnimState():SetBuild("creepy_hands")
        self.hand1:GetAnimState():SetBank("creepy_hands")
        self.hand1:GetAnimState():SetTime(math.random()*2)
        self.hand1:GetAnimState():PlayAnimation("idle", true)
        self.hand1:SetPosition(400, 0, 0)
        self.hand1:SetScale(hand_scale,hand_scale,hand_scale)	
    
        self.hand2 = self.bottom_root:AddChild(UIAnim())
        self.hand2:GetAnimState():SetBuild("creepy_hands")
        self.hand2:GetAnimState():SetBank("creepy_hands")
        self.hand2:GetAnimState():PlayAnimation("idle", true)
        self.hand2:GetAnimState():SetTime(math.random()*2)
        self.hand2:SetPosition(-425, 0, 0)
        self.hand2:SetScale(-hand_scale,hand_scale,hand_scale)	
        --]]

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
