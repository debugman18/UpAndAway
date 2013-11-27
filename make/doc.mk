# Base dir for generating doc.
DOC_BASE:=scripts

# Base dir for LuaDoc customization.
LUADOC_CUSTOM_BASE:=luadoc

# Dir with doc templates, relative to LUADOC_CUSTOM_BASE
DOC_TEMPLATE_DIR:=templates

# Doc output dir.
DOC_DIR:=doc


.PHONY: doc


doc:
	mkdir -p $(DOC_DIR)
	rm -rf $(DOC_DIR)/*
	(\
		cd $(DOC_BASE); \
		LUA_PATH="$(realpath $(LUADOC_CUSTOM_BASE))/?.lua;;" \
		export LUA_PATH; \
		luadoc --doclet upandaway_doclet --nomodules -d $(realpath $(DOC_DIR)) -t "$(DOC_TEMPLATE_DIR)" `find . -path '**/wicker/*' -prune -o -type f -name '*.lua' -exec git ls-files --error-unmatch -- {} \;` \
	)
	git add --all $(DOC_DIR)
