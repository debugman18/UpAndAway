ifneq ($(wildcard ../make/config.mk),)
 include ../make/config.mk
endif
include ../make/common_rules.mk


# List of png assets.
PNG_ASSETS:=$(wildcard *.png)

# List of tex assets.
TEX_ASSETS:=$(patsubst %.png, %.tex, $(PNG_ASSETS))


.PHONY: all clean distclean


all: $(TEX_ASSETS)

clean:
	$(RM) $(TEX_ASSETS)

distclean:

%.tex : KTECH_EXTRA_ARGS = --pow2 --extend
