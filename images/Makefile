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

selectscreen_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend
selectscreen_portraits/%_silho.tex : KTECH_EXTRA_ARGS =
saveslot_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend
inventoryimages/%.tex : KTECH_EXTRA_ARGS = --width 64 --height 64
colour_cubes/%.tex : KTECH_EXTRA_ARGS = -c rgb --no-mipmaps --width 1024 --height 32
