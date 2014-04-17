# Path to ktech.
ifndef KTECH
 KTECH:=ktech
endif

KTECH_EXTRA_ARGS=
%.tex: %.png
	$(KTECH) -f bicubic $(KTECH_EXTRA_ARGS) "$<" "$@"

selectscreen_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend
selectscreen_portraits/%_silho.tex : KTECH_EXTRA_ARGS =
saveslot_portraits/%.tex : KTECH_EXTRA_ARGS = --pow2 --extend
inventoryimages/%.tex : KTECH_EXTRA_ARGS = --width 64 --height 64
