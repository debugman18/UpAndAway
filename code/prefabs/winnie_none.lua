BindGlobal()

local CFG = TheMod:GetConfig()

local assets =
{
	Asset( "ANIM", "anim/winnie.zip" ),
	--Asset( "ANIM", "anim/ghost_winnie_build.zip" ),
}

local skins =
{
	normal_skin = "winnie",
	ghost_skin = "ghost_winnie_build",
}

local base_prefab = "winnie"

local tags = {"WINNIE", "CHARACTER"}

return CreatePrefabSkin("winnie_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})
