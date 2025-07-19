SECTION "setup", ROM0

EntryPoint:
    ld a, 0
    ld bc, 0
    ld de, 0
    ld hl, 0

    ;clear ram
        ld hl, $C000
        ld de, $E000
:
        ld a, 0
        ld [hli], a
        ld a, h
        cp a, d
        jp nz, :-
        ld a, l
        cp a, e
        jp nz, :-

.WaitVBlank ; Do not turn the LCD off outside of VBlank
    ld a, [rLY]
    cp 144
    jp c, .WaitVBlank
    
    ; Turn the LCD off
    ld a, 0
    ld [rLCDC], a

.SetupGFX
    ; clear the nintendo logo
        ld hl, _VRAM
        ld bc, $800
        call Memclear

    ; copy the font tiles
        ld de, Font
        ld hl, _VRAM
        ld bc, Font.end - Font
        call Memcopy

    ; copy the ball
        ld de, Ball
        ld bc, Ball.end - Ball
        call Memcopy

    ; clear the object ram
        ld hl, _OAMRAM
        ld bc, $A0
        call Memclear

    ; clear the tilemap
        ld hl, _SCRN0
        ld bc, _SCRN1 - _SCRN0
        call Memclear
        ld hl, _SCRN1
        ld bc, _SCRN1 - _SCRN0
        call Memclear

    ;create cursor
        ld hl, FauxOAM
        ld a, $08 + 16 ;y
        ld [hli], a
        ld a, $08 + 8 ;x
        ld [hli], a
        ld a, 37 ;tile
        ld [hli], a
        ld a, 0 ;attributes
        ld [hli], a
    
.drawStrings

    ;buttons
        ;add ball
        ld l, 0
        ld de, $0022
        call DrawString
        ;remove ball
        ld l, 5
        ld de, $0062
        call DrawString
        ;sound o
        ld l, 6
        ld de, $00A2
        call DrawString
        ;restart
        ld l, 1
        ld de, $00E2
        call DrawString

    ;reached scanline
        ld l, 4
        ld de, $0160
        call DrawString

    ;balls active
        ld l, 3
        ld de, $01A2
        call DrawString

    ;hope upstairs ballin
        ld l, 2
        ld de, $0200
        call DrawString

    ;version number
        ld l, 7
        ld de, $0012
        call DrawString

.prepareScreen

    call TurnLCDOn

    ; During the first (blank) frame, initialize display registers
        ;bg palette
            ld a, %11100100
            ld [rBGP], a
        ;sprite palette 0
            ld a, %11100100
            ld [rOBP0], a
            ld [rOBP1], a

.SetUpVariables

    ; Initialize global variables
        ld a, $FF
        ld [wCurKeys], a
        
        ld a, 1
        ld [varSoundOn], a

        ld a, 0
        ld [wNewKeys], a
        ld [varCurPos], a
        ld [varNoOfBalls], a
        ld [varFrameCounter], a
        ld [varShouldHideLastBall], a

    ;enable vblank interrupt
        ldh [rIF], a
        ld a, IEF_VBLANK
        ldh [rIE], a
        ei
        nop
    
    ;no of options on the menu
        ld a, 3
        ld [varNoOfOptions], a

.prepareSound

    ;set master volume
    ld hl, rAUDVOL
    ;VIN left, left, VIN right, right
    ld a, %01110111
    ld [hl], a

    ;set panning
    ld hl, rAUDTERM
    ;4321 left, 4321 right
    ld a, %11111111
    ld [hl], a

    ;enable sound
    ld hl, rAUDENA
    ld a, %10000000
    ld [hl], a

.copyDMAthingy

    ld hl, _HRAM
    ld bc, OAM_transfer_routine
    ld d, (OAM_transfer_routine.end - OAM_transfer_routine)

.dmaLoopStart

    ld a, [bc]
    ld [hli], a
    inc bc
    dec d
    jp nz, .dmaLoopStart

.dmaLoopEnd

.finish

    jp MainLoop