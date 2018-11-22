local Common = pkgrequire "common"


local Lambda = wickerrequire "paradigms.functional"
local Pred = wickerrequire "lib.predicates"
local table = wickerrequire "utils.table"

local Geo = wickerrequire "math.geometry"

local function GetRoadsData()
	local roads = rawget(_G, "Roads")
	TheMod:DebugSay("Roads: "..tostring(roads))
	if not roads then
		return OuterError("Attempt to fetch road data before it is available.")
	end
	return roads
end


local function build_road_curves(roads)
	TheMod:DebugSay("Trying to build road curves.")
	local road_parts = {}

	local Point = Point

	local function process_road(road_data)
		if road_data[1] ~= 3 then
			-- trail
			TheMod:DebugSay("Road is a trail, not a road.")
			return
		end

		TheMod:DebugSay("Mapping vertices.")
		local vertices = Lambda.CompactlyMap(function(pt)
			return Point(pt[1], 0, pt[2])
		end, table.ipairs(road_data, 2))

		TheMod:DebugSay("Creating curves from vertices.")
		table.insert(road_parts, Geo.Curves.PolygonalPathFromTable(vertices))
	end

	for _, road_data in pairs(roads) do
		TheMod:DebugSay("Processing roads.")
		TheMod:DebugSay("Road Type: "..road_data[1])
		process_road(road_data)
	end

	TheMod:DebugSay("Concatenating road parts.")
	for k,v in pairs(road_parts) do
		TheMod:DebugSay("Road parts K: "..tostring(k))
		TheMod:DebugSay("Road parts V: "..tostring(v))
	end
	_M.TheRoad = Geo.Curves.Concatenate(road_parts)
	TheMod:DebugSay("TheRoad is "..tostring(_M.TheRoad))
	GLOBAL.ShopkeeperRoad = _M.TheRoad
	TheMod:DebugSay("TheShopkeeperRoad is "..tostring(_G.ShopkeeperRoad))
end

local function define_road_stuff()
	define_road_stuff = Lambda.Error("Attept to redefine road structures.")

	local roads = GetRoadsData()

	build_road_curves(roads)

	if TheMod then
		TheMod:DebugSay("Finished building road structures.")
	end
end

AddLazyVariable("TheRoad", function() define_road_stuff() end)
