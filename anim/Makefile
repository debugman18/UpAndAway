include ../make/config_loader.mk
include ../make/common_rules.mk


# Lists all directories with a build.bin in them.
POSSIBLE_BUILD_DIRS:=$(patsubst %/build.bin,%,$(wildcard */build.bin))

# Filters the above by requiring an atlas-0.png or atlas-0.tex to exist as well.
BUILD_DIRS:=$(foreach dir,$(POSSIBLE_BUILD_DIRS),\
	$(if $(wildcard $(dir)/atlas-0.tex),\
		$(dir),\
		$(if $(wildcard $(dir)/atlas-0.png),\
			$(dir),\
		)\
	)\
)

# Build zip names.
BUILD_ZIPS:=$(addsuffix .zip, $(BUILD_DIRS))


ifndef TOOLS_DIR
 TOOLS_DIR:=../tools
endif


define ADD_ANIM_DEPENDENCY
$(1).zip: $(1)/anim.bin
endef


.PHONY: all clean distclean

.INTERMEDIATE: %.tex


all: $(BUILD_ZIPS)

%.zip: %/build.bin %/atlas-0.tex
	$(TOOLS_DIR)/kbr.pl -i -n "$*" "$<"
	(cd "$*"; zip -q "$(CURDIR)/$@" $(patsubst $*/%,%,$^))

clean:
	$(RM) $(BUILD_ZIPS)

distclean:


$(foreach dir, $(BUILD_DIRS),\
	$(if $(wildcard $(dir)/anim.bin),\
		$(eval $(call ADD_ANIM_DEPENDENCY,$(dir))),\
	)\
)
