# Path to ktech.
ifndef KTECH
 KTECH:=ktech
endif

KTECH_EXTRA_ARGS=
%.tex: %.png
	$(KTECH) -q -f lanczos $(KTECH_EXTRA_ARGS) "$<" "$@"
