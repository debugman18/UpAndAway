# Scripts directory (under the wicker redirection).
SCRIPT_DIR:=scripts/upandaway

# Tools directory.
TOOLS_DIR:=tools


.PHONY: none


none:
	-@true


include make/doc.mk
#include make/build_rename.mk
include $(SCRIPT_DIR)/wicker/make/utils.mk
