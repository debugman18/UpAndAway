# List of png assets.
PNG_ASSETS:=$(wildcard *.png inventoryimages/*.png saveslot_portraits/*.png selectscreen_portraits/*.png)

# List of tex assets.
TEX_ASSETS:=$(patsubst %.png, %.tex, $(PNG_ASSETS))


.PHONY: all clean distclean


all: $(TEX_ASSETS)

clean:
	$(RM) $(TEX_ASSETS)

distclean:

include ../make/common_rules.mk
