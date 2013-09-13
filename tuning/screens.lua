-- This is the margin between the top screen border and the contents.
SCREENS.CREDITS.TOP_MARGIN = 30

-- For the mod name and the category names (e.g., "Programmers")
SCREENS.CREDITS.TITLE.SIZE = 70
-- Horizontal displacement of the title (the names match accordingly).
SCREENS.CREDITS.TITLE.H_OFFSET = 400
-- Spacing below the title.
SCREENS.CREDITS.TITLE.BOTTOM_SPACING = 30

-- For each person's name.
SCREENS.CREDITS.NAMES.SIZE = 50
-- Maximum number of names per page.
SCREENS.CREDITS.NAMES.PER_PAGE = 8

-- Background colours per page type.
-- The last one is the default.
SCREENS.CREDITS.BGCOLOURS = {
	code = Point(202/255, 48/255, 209/255),
	art = Point(255/255, 89/255, 46/255),
	writing = Point(255/255, 196/255, 45/255),
	misc = Point(220/255, 150/255, 220/255),
	Point(0.3, 0.3, 0.3),
}

-- Animations played.
-- An empty default anim means no anim.
SCREENS.CREDITS.ANIMS = {
	code = "1",
	art = "2",
	writing = "3",
	misc = "4",
	"",
}

SCREENS.CREDITS.INITIAL_TEXT = [[
A large collaborative mod from the Fellowship of the Bean.
]]

SCREENS.CREDITS.FINAL_TEXT = [[
Thanks for playing!
]]

SCREENS.CREDITS.PAGE_TRANSITION_DELAY = 4
