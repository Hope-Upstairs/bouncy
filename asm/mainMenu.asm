SECTION "MainMenu", ROM0

MoveCursor:

    ;play sound

        ;channel 1 settigns
            ;sweep
            ld hl, rAUD1SWEEP
            ld a, %00000000
            ld [hl], a

            ;timer length and duty cycle
            ld hl, rAUD1LEN
            ld a, %10011000
            ld [hl], a

            ;volume and envelope
            ld hl, rAUD1ENV
            ld a, %01000000
            ld [hl], a

            ;period low
            ld hl, rAUD1LOW
            ld a, %00000000
            ld [hl], a

            ;trigger + period high
            ld hl, rAUD1HIGH
            ld a, %11000111
            ld [hl], a

    ld a, [varCurPos]
    ld b, a
    ld a, [varNoOfOptions]
    ld c, a
    ; now B is the current pos and C is the number of options

; check if down pressed
.CheckDown
    ld a, [wNewKeys]
    and a, PADF_DOWN
    jp z, .CheckUp
.Down
    ; increase cursor position

    ;compare b and c
    ld a, b
    cp a, c

    ;if they're not equal, increase B
    jp nz, .incB

    ;if it was on the last on the list, wrap around
    ld b, 0
    jp .AfterMoving

.incB
    inc b
    jp .AfterMoving

.CheckUp
    ld a, [wNewKeys]
    and a, PADF_UP
    jp z, .AfterMoving
.Up
    ;compare b and c
    ld a, 0
    cp a, b

    ;if they're not equal, increase B
    jp nz, .decB

    ;if it was on the last on the list, wrap around
    ld b, c
    jp .AfterMoving

.decB
    dec b
    jp .AfterMoving

.AfterMoving

    ld a, b
    ld [varCurPos], a

    ret


MenuPerformAction:

    ld a, [varCurPos]
    ld l, a
    ;a and l have the offset

    ld de, MenuLookup
    call GetAddressFromLookupTable
    ; HL is now where the function starts

    jp hl


MenuActions:

.spawn ;spawn ball

    jp SpawnBall

.remove ;remove ball

    jp RemoveBall

.reset ;reset

    pop bc
    jp $100

.soundToggle

    jp ToggleSound

.end

MenuLookup:

    DW MenuActions.spawn
    DW MenuActions.remove
    DW MenuActions.soundToggle
    DW MenuActions.reset

.end

ToggleSound:

    ;tilemap address
    ld hl, $98B0

    ;get sound state
    ld bc, varSoundOn

    ;check if 0
    ld a, [bc]
    cp a, 0

    ;if 0, enable
    jp z, .enable

    ;if not 0, disable
    jp .disable

.disable

    ;set sound to off
    ld a, 0
    ld [bc], a

    ;write "FF"
    ld a, $10
    ld [hli], a
    ld [hli], a

    jp .after

.enable

    ;set sound to on
    ld a, 1
    ld [bc], a

    ;write "N"
    ld a, $18
    ld [hli], a
    ;write " "
    ld a, $00
    ld [hli], a

    jp .after

.after

    ret

.end