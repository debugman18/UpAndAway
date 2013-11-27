# Without the anim/ prefix.
BUILD_DIRS:=$(patsubst anim/%/build.bin,%,$(wildcard anim/*/build.bin))
EFFECTIVE_BUILD_DIRS:=$(foreach dir, $(BUILD_DIRS), $(if $(wildcard anim/$(dir)/atlas-0.png), $(dir),))


# Receives a build dir name, as above.
GET_BUILD_NAME = $(shell perl -e 'open FH, "<", "anim/$(1)/build.bin" || die $$!; binmode FH; read FH, $$_, 16; read FH, $$_, 4; $$sz = unpack "V", $$_; read FH, $$name, $$sz; print $$name; close FH;')


# Receives a build dir name, as above.
define GEN_BUILD_TARGET =
anim/$(call GET_BUILD_NAME,$(1)).zip: anim/$(1)/atlas-0.tex $(filter $(wildcard anim/$(1)/*.bin), anim/$(1)/build.bin anim/$(1)/anim.bin)
	zip -j $$@ $$^

anim/$(1)/atlas-0.tex: anim/$(1)/atlas-0.png
	ktech $$< $$@

endef


.PHONY: builds

$(foreach dir, $(EFFECTIVE_BUILD_DIRS), $(eval $(call GEN_BUILD_TARGET,$(dir))))

builds: $(foreach dir, $(EFFECTIVE_BUILD_DIRS), anim/$(call GET_BUILD_NAME,$(dir)).zip)
