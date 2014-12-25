# Name of the zip archive to create for mod distribution.
# MOD_VERSION is defined below (by peeking into modinfo.lua), to avoid
# cluttering.
ZIPNAME=UpAndAway-$(MOD_VERSION).zip

# Name of the package info file.
PKGINFO:=pkginfo.lua

# Directory with the mod's own utility scripts.
TOOLS_DIR:=tools

# Scripts directory (under the wicker redirection).
SCRIPT_DIR:=code

# Wicker directory
WICKER_SCRIPT_DIR:=wicker

# Wicker tools directory.
WICKER_TOOLS_DIR:=wickertools


MOD_VERSION=$(shell $(TOOLS_DIR)/get_modversion.lua modinfo.lua)


# Paths to the Lua and Perl interpreters, and to ktech.
# If you need to change this, see the remark about config.mk below.
LUA:=lua
PERL:=perl
KTECH:=ktech


#
# If you need to customize something for your system (such as changing the
# paths to the Lua or Perl interpreters), create a file make/config.mk with
# the customizations and it'll be automatically loaded.
#
ifneq ($(wildcard make/config.mk),)
 include make/config.mk
endif

export LUA
export PERL
export KTECH


.PHONY: all anim images bigportraits levels exported fiximages dist clean distclean wicker wickertools check checkxml checklua

all: anim images bigportraits levels exported

anim:
	$(MAKE) -C anim all

images:
	$(MAKE) -C images all

bigportraits:
	$(MAKE) -C bigportraits all

levels:
	$(MAKE) -C levels all

exported:
	$(MAKE) -C exported all

fiximages:
	$(MAKE) -C exported fiximages

dist: all check
	$(LUA) "$(TOOLS_DIR)/pkgfilelist_gen.lua" "$(PKGINFO)" | $(PERL) "$(TOOLS_DIR)/pkg_archiver.pl" "$(ZIPNAME)"

clean: distclean
	$(MAKE) -C anim clean
	$(MAKE) -C images clean
	$(MAKE) -C bigportraits clean
	$(MAKE) -C levels clean
	$(MAKE) -C exported clean

distclean:
	$(MAKE) -C anim distclean
	$(MAKE) -C images distclean
	$(MAKE) -C bigportraits distclean
	$(MAKE) -C levels distclean
	$(MAKE) -C exported distclean
	$(RM) UpAndAway-*.zip

check: checkxml checklua

checkxml:
	find . -name '*.xml' | xargs xmllint --noout

checklua:
	find . -name '*.lua' | xargs luac -p --

include $(WICKER_SCRIPT_DIR)/make/utils.mk
