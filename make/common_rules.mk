# Path to ktech.
ifndef KTECH
 KTECH:=ktech
endif

KTECH_EXTRA_ARGS=
%.tex: %.png
	$(KTECH) -f bicubic $(KTECH_EXTRA_ARGS) "$<" "$@"
