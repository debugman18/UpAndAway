name = "Up and Away"
author = "The Fellowship of the Bean"
version = "alpha-0.0.6"

id = "upandaway"
branch = "dev"

description = ([[
A massive mod that adds many new things to the traditional Don't Starve experience, including new items, new monsters, new food, new structures, new recipes, and more.

Original concept by debugman18.
]]):gsub("^%s+", ""):gsub("%s+$", "")

dont_starve_compatible = true
reign_of_giants_compatible = true

forumthread = "/forum/49-mod-collaboration-up-and-away"

api_version = 6

icon_atlas = "favicon/upandaway.xml"
icon = "upandaway.tex"

priority = -1

if not _PARSING_ENV and branch ~= "master" then
	name = name.." ("..branch..")"
end
