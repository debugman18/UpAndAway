BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
    --Asset("ANIM", "anim/gold_harp.zip"),

    --Asset( "ATLAS", inventoryimage_atlas("gold_harp") ),
    --Asset( "IMAGE", inventoryimage_texture("gold_harp") ),	
}

local harp_speech = modrequire "resources.harp_speech"

-- Name of the quest for reaching the 2nd level of the cloudrealm.
local PRIMARY_QUEST = "reachtheclouds2"

local function flagplayer(inst, player)
    -- For singleplayer compatibility.
    if player == nil then
        player = GetLocalPlayer()
    end

    local quester = player and player.components.quester

    if not quester or inst.components.speechgiver:IsSpeaking() then return end

    if not quester:StartedQuest(PRIMARY_QUEST) then
        inst.components.speechgiver:PlaySpeech("SEE_PLAYER", player)
    elseif not quester:GetFlag(PRIMARY_QUEST, "got.hint1") then
        inst.components.speechgiver:PlaySpeech("OCTOCOPTER_HINT", player)
    else
        TheMod:DebugSay "La la la, la la."
    end
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    -- This isn't really a structure, but we want it to attracts enemies that are attracted to structures.
    inst:AddTag("structure")
    --inst.AnimState:SetBank("gold_harp")
    --inst.AnimState:SetBuild("gold_harp")

    --inst.AnimState:PlayAnimation("whistle")

    --inst:AddComponent("talker")
    --inst:AddComponent("playerprox")
    --inst:AddComponent("withdrawable")
    inst:AddComponent("speechgiver")

    ------------------------------------------------------------------------
    SetupNetwork(inst)
    ------------------------------------------------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    --inst.components.inventoryitem.atlasname = inventoryimage_atlas("gold_harp")

    return inst
end

return Prefab ("common/world/gold_harp", fn, assets) 