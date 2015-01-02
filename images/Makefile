ifneq ($(wildcard ../make/config.mk),)
 include ../make/config.mk
endif
include ../make/common_rules.mk


# List of png assets.
PNG_ASSETS:=$(wildcard *.png saveslot_portraits/*.png selectscreen_portraits/*.png)

# List of tex assets.
TEX_ASSETS:=$(patsubst %.png, %.tex, $(PNG_ASSETS))


.PHONY: all inventoryimages minimap selectscreen_portraits saveslot_portraits portraits clean distclean


all: $(TEX_ASSETS) inventoryimages minimap

inventoryimages: ua_inventoryimages.tex ua_inventoryimages.xml

ua_inventoryimages.tex ua_inventoryimages.xml: $(wildcard inventoryimages/*.png)

minimap: ua_minimap.tex ua_minimap.xml

ua_minimap.tex ua_minimap.xml: $(wildcard minimap/*.png)

selectscreen_portraits: $(filter selectscreen_portraits/%.tex,$(TEX_ASSETS))

saveslot_portraits: $(filter saveslot_portraits/%.tex,$(TEX_ASSETS))

portraits: selectscreen_portraits saveslot_portraits

clean:
	$(RM) $(TEX_ASSETS)

distclean:

selectscreen_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend --square
saveslot_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend --square
inventoryimages/%.tex : KTECH_EXTRA_ARGS = --width 64 --height 64
colour_cubes/%.tex : KTECH_EXTRA_ARGS = -c rgb --no-mipmaps --width 1024 --height 32
