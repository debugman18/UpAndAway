use "asset_utils"

--These assets are for everything.
Assets = GLOBAL.JoinArrays(
	--[[
	{
		Asset("SOUNDPACKAGE", "sound/music_mod.fev"),
		Asset("SOUND", "sound/music_mod.fsb"),
	},
	]]--
	
	AnimationAssets {
		"generating_cloud",
		"temperature_meter",
		--"player_drink.zip",
	},

	{
		Asset("SOUNDPACKAGE", "sound/upandaway.fev"),
		Asset("SOUND", "sound/upandaway.fsb"),
	},

	ImageAssets {
		"ua_inventoryimages",
		"ua_minimap",

		"uppanels",
		"bg_up",
		"bg_gen",
		"up_new",
	},

	--Winnie assets.
	ImageAssets "saveslot_portraits" {
		"winnie",
	},

	ImageAssets "avatars" {
		"avatar_winnie",
		"avatar_ghost_winnie",
	},

	ImageAssets "selectscreen_portraits" {
		"winnie",
		"winnie_silho",
	},

	{
		Asset( "IMAGE", "images/names_winnie.tex"),
		Asset( "ATLAS", "images/names_winnie.xml"),
	},

	{
		Asset( "IMAGE", "bigportraits/winnie.tex" ),
		Asset( "ATLAS", "bigportraits/winnie.xml" ),
		--Asset( "IMAGE", "bigportraits/winnie_dst.tex" ),
		--Asset( "ATLAS", "bigportraits/winnie_dst.xml" ),
		--Asset( "IMAGE", "bigportraits/winnie_none.tex" ),
		--Asset( "ATLAS", "bigportraits/winnie_none.xml" ),

	},

	{
		Asset( "IMAGE", "bigportraits/winston.tex" ),
		Asset( "ATLAS", "bigportraits/winston.xml" ),		
	},

	-- Dummy end, just so we can put commas after everything.
	{}
)

-- The return statement is just for using this file externally.
return Assets
