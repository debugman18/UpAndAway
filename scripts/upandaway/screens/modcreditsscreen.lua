--@@GLOBAL ENVIRONMENT BOOTUP
local _modname = assert( (assert(..., 'This file should be loaded through require.')):match('^[%a_][%w_%s]*') , 'Invalid path.' )
module( ..., package.seeall, require(_modname .. '.booter') )
--@@END ENVIRONMENT BOOTUP


local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"


local Tree = wickerrequire 'utils.table.tree'

--Very very unfinished.

local new_ui_strings = 
{	
	MODCREDITS=
	{
		TITLE = "MODCREDITS",
		NAMES=
		{
			"Debugman18",
			"Simplex,",
			"Lifemare,",
			"Willette",
			"MilleniumCount",
			"Sukoushi",
			"Lord_Battal",
			"TheDanaAddams",
			"TheLeftHelix",
			"Luggs",
			"KidneyBeanBoy",
		},
	},	
		
	MODALTCREDITS=
	{
		TITLE = "MODALTCREDITS",
		NAMES=
		{
			"Craig_Perry",
			"GTG3000",
			"Hugo M.",
			"Lord_Battal",
			
			"Rabbitfist",
			"Stephenmrush",
			"TeoSS69",
			
			"TheHockeyGods",
			"Wilbur",
			"Xjurwi",
		},
	},	
}

Tree.InjectInto(STRINGS.UI, new_ui_strings)


local ModCreditsScreen = Class(Screen, function(self)
	Screen._ctor(self, "ModCreditsScreen")
    
    self.bg = self:AddChild(Image("images/ui.xml", "bg_plain.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.bgcolors = 
    {
        BGCOLOURS.RED,
        BGCOLOURS.YELLOW,
        BGCOLOURS.PURPLE
    }
    self.bg:SetTint(self.bgcolors[1][1],self.bgcolors[1][2],self.bgcolors[1][3], 1)

    self.klei_img = self:AddChild(Image("images/ui.xml", "klei_new_logo.tex"))
    self.klei_img:SetVAnchor(ANCHOR_MIDDLE)
    self.klei_img:SetHAnchor(ANCHOR_MIDDLE)
    self.klei_img:SetScaleMode(SCALEMODE_PROPORTIONAL)
    self.klei_img:SetPosition( 0, 25, 0)

    self.center_root = self:AddChild(Widget("root"))
    self.center_root:SetVAnchor(ANCHOR_MIDDLE)
    self.center_root:SetHAnchor(ANCHOR_MIDDLE)
    self.center_root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.bottom_root = self:AddChild(Widget("root"))
    self.bottom_root:SetVAnchor(ANCHOR_BOTTOM)
    self.bottom_root:SetHAnchor(ANCHOR_MIDDLE)
    self.bottom_root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
    self.worldanim = self.bottom_root:AddChild(UIAnim())
    self.worldanim:GetAnimState():SetBuild("credits")
    self.worldanim:GetAnimState():SetBank("credits")
    self.worldanim:GetAnimState():PlayAnimation("1", true)

    self.flavourtext = self.center_root:AddChild(Text(TITLEFONT, 70))
    self.thankyoutext = self.center_root:AddChild(Text(BODYTEXTFONT, 40))
    self.thankyoutext:SetString("")
    self.thankyoutext:Hide()

    TheFrontEnd:DoFadeIn(2)
    
    self.positions = {
            {x=300,y=30, bg=1},
            {x=-220,y=30, bg=3},
            {x=-325,y=30, bg=2},
            {x=260,y=30, bg=1},
            {x=-300,y=30, bg=2},
            {x=220,y=0, bg=3, tx=220,ty=200},    -- EXTRA THANKS 
            {x=220,y=0, bg=1, tx=220,ty=200},    -- EXTRA THANKS - STEAM
            {x=0,y=0, bg=3, tx=0,ty=200},    -- ALTGAME
            {x=0,y=60, bg=1, tx=0,ty=180},    -- FMOD
            {x=0,y=180, bg=2, tx=0,ty=180},      -- THANKS
            {x=0,y=180, bg=1},      -- KLEI
        }
		
		
	local names = shuffleArray(STRINGS.UI.MODCREDITS.NAMES)
	self.page_contents = {}

    local page_idx = 1
    self.page_contents[page_idx] = ""

    local name_cnt = 0
    for i,name in ipairs(names) do
        self.page_contents[page_idx] = self.page_contents[page_idx]..name.."\n"
        name_cnt = name_cnt + 1 

        if page_idx ~=4 then
            if name_cnt % 4 == 0 then
                page_idx = page_idx + 1
                self.page_contents[page_idx] = ""
                name_cnt = 0
            end
        else
            if name_cnt % 5 == 0 then
                page_idx = page_idx + 1
                self.page_contents[page_idx] = ""
                name_cnt = 0
            end
        end  

    end
	
    self.page_contents[page_idx] = "A Thanks To The Collaborators"
    page_idx = page_idx + 1
    self.page_contents[page_idx] = "A Thanks To The "
    page_idx = page_idx + 1
	
    local names = shuffleArray(STRINGS.UI.MODALTCREDITS.NAMES)
    self.page_contents[page_idx] = ""
    for i,name in ipairs(names) do
        self.page_contents[page_idx] = self.page_contents[page_idx]..name.."\n"
    end

    self.titletext = self.center_root:AddChild(Text(TITLEFONT, 70))
    self.titletext:SetPosition(0, 180, 0)
    self.titletext:SetString("")
    self.titletext:Hide()

    self.pageidx = 1
    self.pagemax = 11
    self:ChangeFlavourText()
    
    local right_pos_x = -150
    local left_pos_x = 150

    self.OK_button = self:AddChild(ImageButton())
    self.OK_button:SetScale(.8,.8,.8)
    self.OK_button:SetText("Exit")
    self.OK_button:SetOnClick( function() TheFrontEnd:PopScreen(self) end )
    self.OK_button:SetHAnchor(ANCHOR_RIGHT)
    self.OK_button:SetVAnchor(ANCHOR_BOTTOM)
    self.OK_button:SetPosition( right_pos_x, 55, 0)

	
    self.FB_button = self:AddChild(ImageButton())
    self.FB_button:SetScale(.8,.8,.8)
    self.FB_button:SetText("Facebook")
    self.FB_button:SetOnClick( function() VisitURL("http://facebook.com/kleientertainment") end )
    self.FB_button:SetHAnchor(ANCHOR_LEFT)
    self.FB_button:SetVAnchor(ANCHOR_BOTTOM)
    self.FB_button:SetPosition( left_pos_x, 55*2, 0)
	
	
    self.TWIT_button = self:AddChild(ImageButton())
    self.TWIT_button:SetScale(.8,.8,.8)
    self.TWIT_button:SetText("Twitter")
    self.TWIT_button:SetOnClick( function() VisitURL("http://twitter.com/klei", true) end )
    self.TWIT_button:SetHAnchor(ANCHOR_LEFT)
    self.TWIT_button:SetVAnchor(ANCHOR_BOTTOM)
    self.TWIT_button:SetPosition( left_pos_x, 55, 0)

    self.THANKS_button = self:AddChild(ImageButton())
    self.THANKS_button:SetScale(.8,.8,.8)
    self.THANKS_button:SetText("Thank You")
    self.THANKS_button:SetOnClick( function() VisitURL("http://www.dontstarvegame.com/Thank-You") end )
    self.THANKS_button:SetHAnchor(ANCHOR_LEFT)
    self.THANKS_button:SetVAnchor(ANCHOR_BOTTOM)
    self.THANKS_button:SetPosition( left_pos_x, 55*3, 0)


    --focus crap
    self.OK_button:SetFocusChangeDir(MOVE_LEFT, self.TWIT_button)
    self.TWIT_button:SetFocusChangeDir(MOVE_RIGHT, self.OK_button)
    self.TWIT_button:SetFocusChangeDir(MOVE_UP, self.FB_button)
    self.FB_button:SetFocusChangeDir(MOVE_DOWN, self.TWIT_button)
    self.FB_button:SetFocusChangeDir(MOVE_UP, self.THANKS_button)
    self.THANKS_button:SetFocusChangeDir(MOVE_DOWN, self.FB_button)
    self.default_focus = self.OK_button
end)


function ModCreditsScreen:OnBecomeActive()
    ModCreditsScreen._base.OnBecomeActive(self)
    TheFrontEnd:GetSound():PlaySound("dontstarve/music/gramaphone_ragtime", "creditsscreenmusic")    
end

function ModCreditsScreen:OnBecomeInactive()
    ModCreditsScreen._base.OnBecomeInactive(self)

    TheFrontEnd:GetSound():KillSound("creditsscreenmusic")    
    TheFrontEnd:GetSound():PlaySound("dontstarve/music/music_FE","FEMusic")
end

function ModCreditsScreen:OnControl(control, down)
    if Screen.OnControl(self, control, down) then return true end
    if not down and control == CONTROL_CANCEL then
        TheFrontEnd:PopScreen(self)
        return true
    end
end


function ModCreditsScreen:ChangeFlavourText()
    TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/creditpage_flip", "flippage")   
    local bgidx = self.positions[self.pageidx].bg

    self.bg:SetTint(self.bgcolors[bgidx][1],self.bgcolors[bgidx][2],self.bgcolors[bgidx][3], 1)

    self.flavourtext:Hide()
    self.thankyoutext:Hide()
    self.titletext:Hide()
    self.klei_img:Hide()

    local delay = 3.3
    if self.pageidx == self.pagemax then
         self.klei_img:Show()
    else
        if self.pageidx >= 6 then
            self.titletext:Show()
        end
         
         self.worldanim:Show()

        if self.pageidx < 7 then         
            self.worldanim:GetAnimState():PlayAnimation(tostring(self.pageidx), true)
        elseif self.pageidx == 7 then
            self.worldanim:GetAnimState():PlayAnimation(tostring(self.pageidx), false)
        else
            self.worldanim:Hide()
        end

        if self.pageidx == 10 then
            delay = 15
            self.titletext:SetPosition(self.positions[self.pageidx].tx, self.positions[self.pageidx].ty, 0)
            self.thankyoutext:Show()
        else
            self.flavourtext:Show()
        end
        
        self.flavourtext:SetPosition(self.positions[self.pageidx].x, self.positions[self.pageidx].y, 0)

        if self.pageidx == 8 then 
            self.titletext:SetString("Thanks For Playing!")
        else
            self.titletext:SetString("Up and Away")
        end

        if self.pageidx == 9 then
            self.titletext:Hide()
            self.titletext:SetPosition(self.positions[self.pageidx].tx, self.positions[self.pageidx].ty, 0)
            self.flavourtext:SetString("A final thanks to Klei for\ngiving the world ''Don't Starve''")
        elseif self.pageidx == 6 or self.pageidx == 8 then  
            self.titletext:SetPosition(self.positions[self.pageidx].tx, self.positions[self.pageidx].ty, 0)
            self.titletext:Show()
            self.flavourtext:SetString(self.page_contents[self.pageidx])
        else
            self.flavourtext:SetString(self.page_contents[self.pageidx])
        end
    end
    --print("TEXT", self.pageidx, self.page_contents[self.pageidx])
    self.pageidx = (self.pageidx == self.pagemax) and 1 or (self.pageidx + 1)
	self.inst:DoTaskInTime(delay, function() self:ChangeFlavourText() end)
end

return ModCreditsScreen
