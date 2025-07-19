; Define a new section and hard-code it to be at $0040.
SECTION "VBlank Interrupt Call", ROM0[$0040]
    ;push registers to stack so we don't fuck up something if the handler was called outside of halt
    push af
    push bc
    push de
    push hl
    jp VblankHandler

SECTION "VBlank interrupt handler", ROM0

VblankHandler:

    ;copy fauxOAM to the OAM through DMA transfer (function previously copied to HRAM)
        call _HRAM

    ;draw no of balls
        ld a, [varNoOfBalls]
        ld hl, $01A3
        call DisplayHex

    ;draw cur scanline
        ld a, [rLY]
        ld hl, $0172
        call DisplayHex

    ;put everything back
        ei
        nop
        pop hl
        pop de
        pop bc
        pop af

    ret

.end
