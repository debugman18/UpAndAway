PROJECT:=Up and Away
AUTHOR:=Up and Away team
VERSION:=prealpha
API_VERSION:=3
define DESCRIPTION =
A massive mod that adds many new things to the traditional Don't Starve experience, including new items, new monsters, new food, new structures, new recipes, and more.

Original concept by debugman18.
endef
FORUM_THREAD:=26501
FORUM_DOWNLOAD_ID:=1

# Base dir for generating doc.
DOC_BASE:=scripts
# Dir with doc templates.
DOC_TEMPLATE_DIR:=doc_templates
# Doc output dir.
DOC_DIR:=doc


PROJECT_lc:=$(shell echo "$(PROJECT)" | tr A-Z a-z | tr -d ' ')
SCRIPT_DIR:=scripts/$(PROJECT_lc)


include $(SCRIPT_DIR)/wicker/make/preamble.mk

FILES:=

THEMAIN:=$(SCRIPT_DIR)/main.lua
FILES+=$(THEMAIN)

GROUND_SCRIPTS:=modmain.lua modinfo.lua
FILES+=$(GROUND_SCRIPTS)

MISC_SCRIPTS:=
FILES+=$(MISC_SCRIPTS)

POSTINIT_SCRIPTS:=
FILES+=$(POSTINIT_SCRIPTS)

PREFAB_SCRIPTS:=
COMPONENT_SCRIPTS:=
FILES+=$(PREFAB_SCRIPTS) $(COMPONENT_SCRIPTS)


LICENSE_FILES:=LICENSE
IMAGE_FILES:=

FILES+=$(LICENSE_FILES) $(IMAGE_FILES)


.PHONY: none doc




none:
	-true

doc:
	mkdir -p $(DOC_DIR)
	(\
		cd $(DOC_BASE); \
		LUA_PATH="$(realpath $(DOC_TEMPLATE_DIR))/?.lua;;" \
		export LUA_PATH; \
		luadoc -d $(realpath $(DOC_DIR)) -t . `find . -path '**/wicker/*' -prune -o -type f -name '*.lua' -exec git ls-files --error-unmatch -- {} \;` \
	)


include $(SCRIPT_DIR)/wicker/make/rules.mk
