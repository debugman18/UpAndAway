# Path to ktech.
ifndef KTECH
 KTECH:=ktech
endif

KTECH_COMMON_ARGS=-q -f lanczos
KTECH_EXTRA_ARGS=
%.tex: %.png
	$(KTECH) $(KTECH_COMMON_ARGS) $(KTECH_EXTRA_ARGS) "$<" "$@"

%.tex %.xml:
	$(KTECH) --atlas "$*.xml" $(KTECH_COMMON_ARGS) $(KTECH_EXTRA_ARGS) $^
