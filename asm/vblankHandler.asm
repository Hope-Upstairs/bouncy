; Define a new section and hard-code it to be at $0040.
SECTION "VBlank Interrupt Call", ROM0[$0040]
    ;push registers to stack so we don't fuck up something if the handler was called outside of halt
    push af
    push bc
    push de
    push hl
    jp VBlankHandler

SECTION "VBlank interrupt handler", ROM0
VBlankHandler:

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
        ld hl, _OAMRAM
        ld [hl], a

    ;draw no of balls
        ld a, [varNoOfBalls]
        ld hl, $01A3
        call DisplayHex

    call BallGFXHandler

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