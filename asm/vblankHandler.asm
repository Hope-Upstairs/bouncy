; Define a new section and hard-code it to be at $0040.
SECTION "VBlank Interrupt Call", ROM0[$0040]
    ;push registers to stack so we don't fuck up something if the handler was called outside of halt
    push af
    push bc
    push de
    push hl
    jp VblankHandler

SECTION "VBlank interrupt handler", ROM0

FauxHandler:

    ;cursor
        ;get cursor position
        ld hl, varCurPos
        ld a, [hl]
        inc a

        ;multiply by 16 and add offset
        swap a
        and a, $F0
        ld b, $08 ;+ 16*1
        add a, b

        ;write to vram
        ld hl, FauxOAM
        ld [hl], a

    call BallGFXHandler

    ret

.end

VblankHandler:

    ;copy fauxOAM to the OAM through DMA transfer (previously copied to HRAM)
    call _HRAM

    ;draw no of balls
        ld a, [varNoOfBalls]
        ld hl, $01A3
        call DisplayHex

    ;draw cur scanline
        ld a, [rLY]
        ld hl, $0172
        call DisplayHex

    ei
    nop

    ;pop registers
        pop hl
        pop de
        pop bc
        pop af

    ret

.end
