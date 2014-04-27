# Directory of the current include.
LOCALDIR := $(dir $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST)))

ifneq ($(wildcard $(LOCALDIR)/config.mk),)
 include $(LOCALDIR)/config.mk
endif
