BindGlobal()


local Screen = require "widgets/screen"
--local Button = require "widgets/button"
--local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"


local Lambda = wickerrequire "paradigms.functional"

local Tree = wickerrequire "utils.table.tree"

local Pred = wickerrequire "lib.predicates"


local CFG = TheMod:GetConfig("SCREENS", "CREDITS")


local function SortNames(cat)
    shuffleArray(cat[2])
    return cat
end

local function SortInfo(info)
    local sinfo = Tree.InjectInto({}, info)

    --[[
    -- Lists the indexes of the sortable categories.
    --]]
    local sortable_cats = {}

    for i, category in ipairs(info) do
        if category.sort ~= false then
            table.insert(sortable_cats, i)
        end
    end

    local sorted_cats = shuffleArray(Lambda.InjectInto({}, ipairs(sortable_cats)))

    for j = 1, #sortable_cats do
        local original_i, target_i = sortable_cats[j], sorted_cats[j]

        sinfo[ original_i ] = Tree.InjectInto({}, info[ target_i ])
    end

    for i, v in ipairs(sinfo) do
        sinfo[i] = SortNames(v)
    end

    return sinfo
end

--[[
-- Count lines in a string, accounting for the Linux, Mac and Windows
-- conventions.
--]]
local function count_lines(s)
    s = s:gsub("%s+$", "")

    if s == "" then return 0 end

    -- Normalize Windows line breaks.
    s = s:gsub("\
\13", "\
")

    -- Normalize Mac line breaks.
    s = s:gsub("\13", "\
")

    local num_breaks
    s, num_breaks = s:gsub("\
", "\
")

    return 1 + num_breaks
end


local function NewStringHeightCalculator(font, size)
    return function(s)
        local widget = Text(font, size)
        widget:SetString(s)
        local w, h = widget:GetRegionSize()
        widget:Kill()
        return h
    end
end


local function GetPageBuilders(info)
    assert( Pred.IsTable(info) )
    info = SortInfo(info)

    local title_height = NewStringHeightCalculator(TITLEFONT, CFG.TITLE.SIZE)("A")

    local GetNamesHeight = NewStringHeightCalculator(TITLEFONT, CFG.NAMES.SIZE)


    local top_pos = Point(0, -CFG.TOP_MARGIN)

    -- Title bottom pos
    local title_pos = top_pos - Point(0, title_height)

    local names_top_pos = title_pos - Point(0, CFG.TITLE.BOTTOM_SPACING)

    --[[
    local screen_w, screen_h = TheSim:GetScreenSize()

    local bottom_pos = Point(0, -screen_h + CFG.BOTTOM_MARGIN)
    
    local real_estate = -( bottom_pos.y - names_top_pos.y )

    local max_lines = 1
    do
        local test_str = "A"
        repeat
            test_str = test_str .. "\
A"
            max_lines = max_lines + 1
        until GetNamesHeight(test_str) > real_estate
        max_lines = max_lines - 1
    end
    ]]--

    local max_lines = CFG.NAMES.PER_PAGE


    --[[
    -- 1 is right, -1 is left.
    --]]
    local anim_orientation = {
        -1,
        1,
        1,
        -1,
        1,
        -1,
    }


    local title_hoffset = Point(CFG.TITLE.H_OFFSET)


    local function new_page_builder(contents, title, bgcolour, anim)
        contents = contents or ""
        title = title or info.title or ""
        bgcolour = bgcolour or CFG.BGCOLOURS[1] or Point(0, 0, 0)
        anim = anim or CFG.ANIMS[1] or "1"

        local names_voffset = Point(0, -0.5*GetNamesHeight("\
" .. contents))

        return function(screen)
            -- Text orientation.
            local orient
            if tonumber(anim) then
                orient = -(anim_orientation[tonumber(anim)] or 0)
            else
                orient = 0
            end
            -- Text alignment.
            local anchor
            if orient > 0 then
                anchor = ANCHOR_RIGHT
            elseif orient < 0 then
                anchor = ANCHOR_LEFT
            else
                anchor = ANCHOR_MIDDLE
            end


            local title_offset = title_hoffset*orient

            screen.titletext:SetHAlign(anchor)
            screen.titletext:SetString(title)
            screen.titletext:SetPosition((title_pos + title_offset):Get())
        

            screen.namestext:SetHAlign(anchor)
            screen.namestext:SetString(contents)

            local title_w = screen.titletext:GetRegionSize()
            local names_w = screen.namestext:GetRegionSize()

            local names_offset = names_voffset + Point((title_hoffset.x + 0.5*(title_w - names_w))*orient)

            screen.namestext:SetPosition((names_top_pos + names_offset):Get())


            screen.titletext:Show()
            screen.namestext:Show()


            screen.bg:SetTint(bgcolour.x, bgcolour.y, bgcolour.z, 1)


            if anim and anim ~= "" then
                local state = screen.worldanim:GetAnimState()
                state:PlayAnimation(anim, true)
            else
                screen.worldanim:GetAnimState():PlayAnimation("")
            end
        end
    end

    local function new_category_page_builder(cat, contents)
        return new_page_builder(
            contents,
            cat[2].title,
            CFG.BGCOLOURS[cat[1]], 
            CFG.ANIMS[cat[1]]
        )
    end

    local pages = {}

    table.insert(pages, new_page_builder(CFG.INITIAL_TEXT))

    for _, cat in ipairs(info) do
        local lines = {}
        for name_idx, name in ipairs(cat[2]) do
            table.insert(lines, name)
            if name_idx % max_lines == 0 then
                table.insert(pages, new_category_page_builder(cat, table.concat(lines, "\
")))
                lines = {}
            end
        end
        if #lines > 0 then
            table.insert(pages, new_category_page_builder(cat, table.concat(lines, "\
")))
        end
    end

    table.insert(pages, new_page_builder(CFG.FINAL_TEXT))

    return pages
end


local ModCreditsScreen = Class(Screen, function(self)
    Screen._ctor(self, "ModCreditsScreen")
    
    self.bg = self:AddChild(Image("images/ui.xml", "bg_plain.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
    self.bg:SetVAnchor(ANCHOR_MIDDLE)
    self.bg:SetHAnchor(ANCHOR_MIDDLE)
    self.bg:SetScaleMode(SCALEMODE_FILLSCREEN)

    self.top_root = self:AddChild(Widget("root"))
    self.top_root:SetVAnchor(ANCHOR_TOP)
    self.top_root:SetHAnchor(ANCHOR_MIDDLE)
    self.top_root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.bottom_root = self:AddChild(Widget("root"))
    self.bottom_root:SetVAnchor(ANCHOR_BOTTOM)
    self.bottom_root:SetHAnchor(ANCHOR_MIDDLE)
    self.bottom_root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    
    self.worldanim = self.bottom_root:AddChild(UIAnim())
    self.worldanim:GetAnimState():SetBuild("credits")
    self.worldanim:GetAnimState():SetBank("credits")
    --self.worldanim:GetAnimState():SetBuild("up_credits")
    --self.worldanim:GetAnimState():SetBank("up_credits")

    self.titletext = self.top_root:AddChild(Text(TITLEFONT, CFG.TITLE.SIZE))
    self.titletext:SetString("")
    self.titletext:Hide()

    self.namestext = self.top_root:AddChild(Text(TITLEFONT, CFG.NAMES.SIZE))
    self.namestext:SetString("")
    self.namestext:Hide()


    TheFrontEnd:DoFadeIn(2)


    ;(function(delay)
        local page_builders = GetPageBuilders( domodfile "credits.lua" )

        page_builders[1](self)

        local i = 2

        local task
        task = self.inst:DoPeriodicTask(delay, function()
            if i > #page_builders then
                task:Cancel()
                return
            end

            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/creditpage_flip", "flippage")

            page_builders[i](self)

            i = i + 1
        end)
    end)(CFG.PAGE_TRANSITION_DELAY)

    
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
    self.FB_button:SetText("Wiki")
    self.FB_button:SetOnClick( function() VisitURL("up-and-away.wikia.com") end )
    self.FB_button:SetHAnchor(ANCHOR_LEFT)
    self.FB_button:SetVAnchor(ANCHOR_BOTTOM)
    self.FB_button:SetPosition( left_pos_x, 55*2, 0)
    
    self.TWIT_button = self:AddChild(ImageButton())
    self.TWIT_button:SetScale(.8,.8,.8)
    self.TWIT_button:SetText("Forums")
    self.TWIT_button:SetOnClick( function() VisitURL("http://forums.kleientertainment.com/forum/49-mod-collaboration-up-and-away/", true) end )
    self.TWIT_button:SetHAnchor(ANCHOR_LEFT)
    self.TWIT_button:SetVAnchor(ANCHOR_BOTTOM)
    self.TWIT_button:SetPosition( left_pos_x, 55, 0)

    self.THANKS_button = self:AddChild(ImageButton())
    self.THANKS_button:SetScale(.8,.8,.8)
    self.THANKS_button:SetText("Thank You")
    self.THANKS_button:SetOnClick( function() VisitURL("http://www.dontstarvegame.com/fan-art/dont-starve-mod-collaboration-and-away") end )
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
    --[[
    TheFrontEnd:GetSound():PlaySound("dontstarve/music/gramaphone_ragtime", "creditsscreenmusic")    
    ]]--
end

function ModCreditsScreen:OnBecomeInactive()
    ModCreditsScreen._base.OnBecomeInactive(self)
    --[[
    TheFrontEnd:GetSound():KillSound("creditsscreenmusic")    
    TheFrontEnd:GetSound():PlaySound("dontstarve/music/music_FE","FEMusic")
    ]]--
end

function ModCreditsScreen:OnControl(control, down)
    if Screen.OnControl(self, control, down) then return true end
    if not down and control == CONTROL_CANCEL then
        TheFrontEnd:PopScreen(self)
        return true
    end
end

return ModCreditsScreen
