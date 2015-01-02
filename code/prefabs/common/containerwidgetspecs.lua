--[[
-- Specs for the container widgets used by the mod. See kettle.lua for
-- an example usage.
--
-- The itemtestfn function, is set on each individual prefab file, even
-- though it is apart of the widget spec.
--]]

local ContainerWidgetSpec = wickerrequire "gadgets.containerwidgetspec"

--[[
-- These use the sizes/borders/etc. for vertical line containers with
-- standard art (including the kettle).
--]]
local function NewVerticalLineWidgetSpec(prefab_name, numslots, has_button, acceptsstacks)
    local widget_spec = ContainerWidgetSpec(prefab_name, numslots)

    local last_slot_pos = widget_spec:SetupSlotsLine {
        direction = "y",

        -- Vertical offset for all widget elements.
        offset = Vector3(0, 14, 0),

        margin = 8,

        slot_length = 64,
    }

    widget_spec:Include {
        type = "cooker",
        acceptsstacks = acceptsstacks and true or false,

        widget = {
            pos = Point(200, 0, 0),
            side_align_tip = 100,
        },
    }

    if has_button then
        widget_spec:SetButtonInfoPos(last_slot_pos + Vector3(0, -57, 0))
    end

    return widget_spec
end

local function GetBrewingButtonInfo(text)
    return {
        text = text,
        -- position is already set from the function above.
        fn = function(inst)
            local container = inst.components.container
            local container_rep = replica(inst).container
            if container or (IsClient() and container_rep and not container_rep:IsBusy()) then
                ServerRPC.DoWidgetButtonAction(ACTIONS.BREW, inst)
            end
        end,
        validfn = function(inst)
            return replica(inst).container and Game.IsNonEmptyContainer(inst)
        end,
    }
end

---

kettle = NewVerticalLineWidgetSpec("kettle", 2, true)
kettle:SetAnim {bank = "ui_kettle_1x2", build = "ui_kettle_1x2"}
kettle:SetButtonInfo( GetBrewingButtonInfo("Brew") )

print("ket but pos: "..tostring(kettle.spec.widget.buttoninfo.position))

---

refiner = NewVerticalLineWidgetSpec("refiner", 4, true)
refiner:SetAnim {bank = "ui_cookpot_1x4", build = "ui_cookpot_1x4"}
refiner:SetButtonInfo( GetBrewingButtonInfo("Refine") )

---

cauldron = NewVerticalLineWidgetSpec("cauldron", 4, true)
cauldron:SetAnim {bank = "ui_cookpot_1x4", build = "ui_cookpot_1x4"}
cauldron:SetButtonInfo( GetBrewingButtonInfo("Brew") )
