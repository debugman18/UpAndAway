# Path to ktech.
ifndef KTECH
 KTECH:=ktech
endif

%.tex: %.png
	$(KTECH) -f bicubic "$<" "$@"
