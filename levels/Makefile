ifneq ($(wildcard ../make/config.mk),)
 include ../make/config.mk
endif
include ../make/common_rules.mk


# Tile and noise pngs.
PNG_ASSETS:=$(wildcard tiles/*.png textures/*.png)

TEX_ASSETS:=$(patsubst %.png, %.tex, $(PNG_ASSETS))



.PHONY: all clean distclean


all: $(TEX_ASSETS)

clean:
	$(RM) $(TEX_ASSETS)

distclean:

textures/%.tex : KTECH_EXTRA_ARGS = -c dxt1
