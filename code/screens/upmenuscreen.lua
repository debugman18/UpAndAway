BindGlobal()

-- Version of the encoding used for the cached modinfo string.
local MODINFO_ENCODING_VERSION = "1.0"

-- Git branch corresponding to this version of the mod.
local GIT_BRANCH = assert( modinfo.branch )

-- GitHub user who owns the repository.
local GITHUB_ACCOUNT = "debugman18"

-- Name of the repository.
local GITHUB_REPO = "UpAndAway"

local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local Widget = require "widgets/widget"
require "dumper"

local Time = wickerrequire "utils.time"


---
-- Returns the fetch URL.
local function get_modinfo_url()
    return "https://raw.githubusercontent.com/"..table.concat({GITHUB_ACCOUNT, GITHUB_REPO, GIT_BRANCH}, "/").."/modinfo.lua"
end

---
-- Shows the mod credits.
local function Credits()
    local ModCreditsScreen = require "screens/modcreditsscreen"
    TheFrontEnd:PushScreen(ModCreditsScreen())
end

---
-- Decodes a string into a Lua table. Serves as an abstraction to allow easy switching
-- between Lua and JSON string representations as we see fit.
local function decode_modinfo(external_modinfo_str)
    assert( type(external_modinfo_str) == "string", "string expected as stored modinfo" )
    local fn = assert( loadstring(external_modinfo_str) )

    local env = {}
    setfenv(fn, env) -- runs it in an empty environment

    local ret = fn()

    if not external_modinfo_str:match("^return") then
        ret = env
    end

    assert( type(ret) == "table", "table expected as result of processing modinfo string, got "..tostring(ret) )

    return ret
end

---
-- Encodes a Lua table into a string.
local function encode_modinfo(external_modinfo)
    local ret = DataDumper(external_modinfo)
    assert( type(ret) == "string", "string expected as result of dumping modinfo table, got "..tostring(ret) )
    return ret
end

---
-- Enriches the modinfo received from the server with metadata.
--
-- @param latest_modinfo The modinfo table received from the server.
-- @returns An enriched table representing the modinfo table and metadata.
local function EnrichModInfo(external_modinfo)
    local metadata = {
        last_synced = os.time(),
    }

    return {
        encoding_version = MODINFO_ENCODING_VERSION,

        modinfo = external_modinfo,
        metadata = metadata,
    }
end

---
-- Breaks a modinfo table extended with metadata into a regular modinfo
-- table and a separate metadata table.
--
-- @param rich_modinfo The enriched modinfo table, as returned by EnrichModInfo.
-- @returns The modinfo table followed by the metadata table.
local function ExtractMetadataFromModInfo(rich_modinfo)
    local external_modinfo = rich_modinfo.modinfo
    local metadata = rich_modinfo.metadata or {}
    assert( type(external_modinfo) == "table", "table expected in field 'modinfo' of enriched modinfo, got "..tostring(external_modinfo) )

    return external_modinfo, metadata
end

local function ProcessModInfo(str, cache)
    local status, external_modinfo = pcall( decode_modinfo, str )
    if status then
        TheMod:DebugSay("ModInfo decoded successfully.")
    else
        TheMod:Say("Error decoding ModInfo: ", external_modinfo)
    end
    if status and external_modinfo then
        if cache then
            local enriched_str = encode_modinfo(EnrichModInfo(external_modinfo))
            TheMod:DebugSay("Caching enriched modinfo string:\
", enriched_str)
            SavePersistentString("upandaway_modinfo", enriched_str)
        end
        return external_modinfo
    end
end

local function OnModInfoQueryComplete(result, success, httpcode)
    TheMod:Say("OnModStatusQueryComplete [success = ", success, ", HTTP ", httpcode, "]", TheMod:Debug() and (":\
"..result))
    if success and #result > 0 and httpcode == 200 then 
        return ProcessModInfo(result, true)
    end
end

---
-- Asynchronously fetches the mod status.
-- Calls the callback cb twice, first with the cached mod status table (nil
-- if there is none) and then with the one just obtained by the server (nil
-- if the query fails). The second argument to cb is the modinfo metadata,
-- which is only non-nil for cached results (i.e., for the first call of cb).
local function GetModInfo(cb)
    return TheSim:GetPersistentString("upandaway_modinfo", function(load_success, str)
        local status, external_modinfo, metadata

        status = load_success and #str > 0
        if status then
            status, external_modinfo, metadata = pcall(ExtractMetadataFromModInfo, ProcessModInfo(str, false))
        end

        if status and external_modinfo then
            cb(external_modinfo, metadata)
        else
            cb()
        end

        TheSim:QueryServer(get_modinfo_url(), function(...)
            cb(OnModInfoQueryComplete(...))
        end, "GET")
    end)
end

---
-- Builds the screen. Meant to be called as a subroutine.
--
-- @param self The Screen object.
local function build_screen(self)
    TheMod:DebugSay("Building U&A menu screen...")

    -- Returns the height of a text widget.
    local function get_region_height(text_widget)
        local x, y = text_widget:GetRegionSize()
        return y
    end

    -- Returns the lower left corner of a text widget.
    local function get_lower_corner(text_widget)
        return text_widget:GetPosition() + Point(0, -get_region_height(text_widget), 0)
    end

    --[[
    -- First part: things that do not rely on the external modinfo.
    --]]
    TheMod:DebugSay("Building part 1 of screen...")
    
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
    local bg_w, bg_h = self.bg:GetSize()
    --self.bg:SetOnClick(function() TheFrontEnd:PopScreen(self) end)
    
    --title	
    self.title = self.proot:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(0, 0.3*bg_h, 0)
    self.title:SetString(modinfo.name)

    --freshness (info about how long since the last sync)
    self.freshness = self.proot:AddChild(Text(TITLEFONT, 30))
    self.freshness:SetPosition(get_lower_corner(self.title))
    self.freshness:SetString("PLACEHOLDER")

    --text
    local text_margins = {x = 10, y = 40}
    self.text = self.proot:AddChild(Text(BODYTEXTFONT, 30))
    self.text:SetVAlign(ANCHOR_MIDDLE)
    self.text:SetPosition(0, 0, 0)
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(
        bg_w - 2*text_margins.x, bg_h - 2*text_margins.y
    )

    self.button = self.proot:AddChild(ImageButton())
    self.button:SetPosition(0, -0.32*bg_h, 0)
    self.button:SetText("Return")
    self.button:SetOnClick( function() TheFrontEnd:PopScreen(self) end )
    self.button.text:SetColour(0,0,0,1)
    self.button:SetFont(BUTTONFONT)
    self.button:SetTextSize(40)    

    self.info_button = self.proot:AddChild(ImageButton())
    self.info_button:SetPosition(-0.12*bg_w, -0.28*bg_h, 0)
    self.info_button:SetText("More Info")
    self.info_button:SetOnClick( function() VisitURL("http://forums.kleientertainment.com/index.php?" .. TheMod.modinfo.forumthread) end )    
    self.info_button:SetScale(.8)
    
    --Adds a mod credits button.
    self.modcredits_button = self.proot:AddChild(ImageButton())
    self.modcredits_button:SetPosition(0.12*bg_w, -0.28*bg_h, 0)
    self.modcredits_button:SetText("Credits")
    self.modcredits_button:SetOnClick( function() Credits() end )	
    self.modcredits_button:SetScale(.8)


    TheMod:DebugSay("Built part 1 of screen.")
    --------------------------------------------------------------------
    

    --[[
    -- Second part: things that rely on the external modinfo.
    --]]
    TheMod:DebugSay("Building part 2 of screen...")

    -- Last time modinfo was fetched from the server.
    -- Defaults to the Big Bang.
    local last_synced = -math.huge

    ---
    -- Updates self.freshness.
    local function update_freshness()
        local dt = os.time() - last_synced

        local dt_string
        if dt == math.huge then
            dt_string = "NEVER"
        elseif dt < 5 then
            dt_string = "just now"
        else
            dt_string = tostring(Time.FactorTime(dt)).." ago"
        end

        self.freshness:SetString("(information last updated "..dt_string..")")
    end

    update_freshness()
    self.freshness.inst:DoPeriodicTask(1, function(inst)
        update_freshness()
        print "UP"
    end)
    
    local function display_external_modinfo(external_modinfo, force)
        if not external_modinfo then
            if force then
                external_modinfo = {}
            else
                return
            end
        end

        local lines = {
            "You are running version '" .. modinfo.version .. "' of Up and Away.",
            "The latest version of Up and Away is '" .. (external_modinfo.version or "UNKNOWN") .. "'.",
            "\
Thank you for playtesting, and being a part of our mod's development!",
        }

        if IsDLCInstalled(REIGN_OF_GIANTS) then
            table.insert(lines, 1, "Warning: Disabling Reign of Giants may currently cause bugs.\
")
        end

        self.text:SetString(table.concat(lines, "\
"))
    end


    -- Waits for the first (cached) external modinfo.
    TheMod:DebugSay("Waiting for cached modinfo...")
    local cached_modinfo, cached_metadata = coroutine.yield()
    if cached_modinfo then
        TheMod:DebugSay("Got cached modinfo, mod version = '", cached_modinfo.version, "'.")
        last_synced = cached_metadata and cached_metadata.last_synced or last_synced
        update_freshness()
    else
        TheMod:DebugSay("Got nil for cached modinfo.")
    end
    display_external_modinfo(cached_modinfo, true)

    -- Waits for the second (github) external modinfo.
    TheMod:DebugSay("Waiting for github modinfo...")
    local github_modinfo = coroutine.yield()
    if github_modinfo then
        TheMod:DebugSay("Got github modinfo, mod version = '", github_modinfo.version, "'.")
        last_synced = os.time()
        update_freshness()
    else
        TheMod:DebugSay("Got nil for github modinfo.")
    end
    display_external_modinfo(github_modinfo)

    TheMod:DebugSay("Built part 2 of screen.")

    TheMod:DebugSay("Built U&A menu screen.")
end


local UpMenuScreen = Class(Screen, function(self, buttons)
    Screen._ctor(self, "UpMenuScreen")
    
    local screen_builder = coroutine.wrap(build_screen)
    screen_builder(self)

    GetModInfo(function(...)
        if self.inst:IsValid() then
            screen_builder(...)
        end
    end)
end)

return UpMenuScreen
