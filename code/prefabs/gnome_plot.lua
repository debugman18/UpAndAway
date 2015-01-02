BindGlobal()

local assets =
{
    Asset("ANIM", "anim/gnome_plot.zip"),	
}

local crops = {

    "colored_corn",
    "pineapple_bush",

}

local prefabs = 
{

    "colored_corn",
    "pineapple_bush",

    "gnome_wilson",

    "gnome_farmrock",
    "gnome_farmrocktall",
    "gnome_farmrockflat",
    "gnome_stick",
    "gnome_stickright",
    "gnome_stickleft",
    "gnome_signleft",
    "gnome_fencepost",
    "gnome_fencepostright",
    "gnome_signright",     
}

local function onsave(inst, data)
    print("saved")
    if inst.fertile then
        data.fertile = inst.fertile
    end

    if inst.gnome then
        data.gnome = inst.gnome
    end
end

local function onload(inst, data)
    print("loaded")

    if data and data.fertile then
        inst.fertile = data.fertile
    end

    if data and data.gnome then
        inst.gnome = data.gnome
    end
end

local function pickcrop(inst)
    if not inst.fertile then	
        local plant = crops[math.random(#crops)]
        local crop = SpawnPrefab(plant)
        local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,0,0)
        crop.Transform:SetPosition(pt:Get())	

        inst.fertile = true
    end

    if math.random(1,4) == 4 and not inst.gnome then
        local gnome = SpawnPrefab("gnome_wilson")
        local random = math.random(1,2)
        local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(random,0,random)
        gnome.Transform:SetPosition(pt:Get())
    end

    inst.gnome = true

end

local back = -1
local front = 0
local left = 1.5
local right = -1.5

local function plot(level)
    local rock_front = 1

    local decor_defs =
    {
        [1] = { { signright = { { -1.1, 0, 0.5 } } } },

        [2] = {	{ stick = {
                            { left - 0.9, 0, back },
                            { right, 0, front },
                          }
                },
                { stickleft = {
                            { 0.0, 0, back },
                            { left, 0, front },
                          }
                },
                { stickright = {
                            { right + 0.9, 0, back },
                            { left - 0.3, 0, back + 0.5 },
                            { right + 0.3, 0, back + 0.5 },
                          }
                },
                { signleft = { { -1.0, 0, 0.5 } } }
              },

        [3] = {	
                -- left side
                { gnome_farmrock = {
                        { right + 3.0, 0, rock_front + 0.2 },
                        { right + 3.05, 0, rock_front - 1.5 },
                    }
                },

                { gnome_farmrocktall = { { right + 3.07, 0, rock_front - 1.0 }, }	},
                { gnome_farmrockflat = { { right + 3.06, 0, rock_front - 0.4 }, }	},

                -- right side
                { gnome_farmrock = { { left - 3.05, 0, rock_front - 1.0 }, } },
                { gnome_farmrocktall = { { left - 3.07, 0, rock_front - 1.5 }, } },
                { gnome_farmrockflat = { { left - 3.06, 0, rock_front - 0.4 }, } },

                -- front row
                { gnome_farmrock = {
                        { right + 1.1, 0, rock_front + 0.21 },
                        { right + 2.4, 0, rock_front + 0.25 },
                    }
                },

                { gnome_farmrocktall = { { right + 0.5, 0, rock_front + 0.195 }, } },
                
                { gnome_farmrockflat = {
                        { right + 0.0, 0, rock_front - 0.0 },
                        { right + 1.8, 0, rock_front + 0.22 },
                    }
                },

                -- back row
                { gnome_farmrockflat = {
                        
                        { left - 1.3, 0, back - 0.19 },
                    }
                },

                { gnome_farmrock = {
                        { left - 0.5, 0, back - 0.21 },
                        { left - 2.5, 0, back - 0.22 },
                    }
                },

                { gnome_farmrocktall = {
                        { left + 0.0, 0, back - 0.15 },
                        { left - 3.0, 0, back - 0.20 },
                        { left - 1.9, 0, back - 0.205 },
                    }
                },

                { gnome_fencepost = {
                        { left - 1.0,  0, back + 0.15 },
                        { right + 0.8, 0, back + 0.15 },
                        { right + 0.3, 0, back + 0.15 },
                    },
                },

                { gnome_fencepostright = {
                        { left - 0.5,  0, back + 0.15 },
                        { 0,		   0, back + 0.15 },
                    },
                },
          }
    }

    return function(Sim)

        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst.AnimState:SetBank("gnome_plot")
        inst.AnimState:SetBuild("gnome_plot")
        inst.AnimState:PlayAnimation("idle")

        inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        inst.Transform:SetRotation(45)

        ------------------------------------------------------------------------
        SetupNetwork(inst)
        ------------------------------------------------------------------------

        inst:DoTaskInTime(.1, function() pickcrop(inst) end)
    
        inst.decor = {}

        local decor_items = decor_defs[level]

        for k, item_info in pairs(decor_items) do
            for item_name, item_offsets in pairs(item_info) do
                for l, offset in pairs(item_offsets) do
                    local item_inst = SpawnPrefab(item_name)
                    item_inst.entity:SetParent(inst.entity)
                    item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
                    table.insert(inst.decor, item_inst)
                end
            end
        end

        inst.OnSave = onsave
        inst.OnLoad = onload

        return inst
    end

end

return Prefab ("common/inventory/gnome_plot", plot(3), assets, prefabs) 
