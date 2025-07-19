SECTION "MainLoop", ROM0

MainLoop:
    ;code that doesn't do anything to the VRAM

    ;wait a frame
        ld a, [varFrameCounter]
        inc a
        ld [varFrameCounter], a
        and a, %00000001
        call z, HandleBalls

    ;call HandleBalls

    call UpdateKeys

    ;if A pressed,
    ld a, [wNewKeys]
    and a, PADF_A
    jp z, .skipAPress

    ;do something (depends on the selected action) then don't move the cursor
    call MenuPerformAction

    jp .SkipCurMove

.skipAPress

    ; skip if both or neither up and down pressed
    ld a, [wNewKeys]
    cp a, PADF_DOWN | PADF_UP
    jp z, .SkipCurMove
    and a, PADF_DOWN | PADF_UP
    jp z, .SkipCurMove

    ;move cursor
    call MoveCursor

.SkipCurMove

    call BallGFXHandler
    call FauxHandler

    halt
    nop
    jp MainLoop
