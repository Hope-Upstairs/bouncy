SECTION "BallCode", ROM0

SpawnBall:
    ld a, [varNoOfBalls]
    ld e, a

    ;check if 20 balls already
    cp a, 20
    ;cp a, 1
    ret z

    ld hl, BallVars
    add a, a
    add a, a
    ld d, a
    ld a, l
    add a, d
    ld l, a
    ;hl is now the proper address for the ball vars

    ;ball y
    ld bc, rDIV
    ld a, [bc]
    and a, %11110000
    ;ld a, 100
    ld [hli], a
    ;ball x
    ld bc, rDIV
    ld a, [bc]
    swap a
    ld [hli], a
    ;ball yspd
    ld a, -1
    ld [hli], a
    ;ball xspd
    ld bc, rDIV
    ld a, [bc]
    and a, %00000011
    ld [hli], a

    ld a, e
    inc a
    ld [varNoOfBalls], a
    ret
.end


;=============================================   ball handler   =========================================


HandleBalls:

    ;get no of balls, vars pos
        ld a, [varNoOfBalls]
        ld d, a
        ld hl, BallVars

    ;d = no of balls
    ;hl = oam address
    ;bc = ball vars

.checkIfAnyBalls

    ;check if any balls left
        ld a, d
        cp a, 0
    ;if not, exit loop
        ret z

.ballLoopStart
    ;loop here

    ;get y speed to b
        ;go to y speed
        inc hl
        inc hl

        ;load
        ld a, [hl]

        ;apply gravity and store
        inc a
        ld [hld], a

        ;send to b
        ld b, a

    ;move
        ;get y
        dec hl
        ld a, [hl]

        ;apply speed
        add a, b

        ;c is y, b is speed
        ld c, a

        jp z, .groundBallAndBounce
        jp c, .groundBallAndBounce

    ;test stuff: press b to bounce (DELETE AFTER)
        ld a, [wNewKeys]
        and a, PADF_B
        ld a, c
        jp nz, .groundBallAndBounce
        
    jp .applyBallY

.groundBallAndBounce

    ;check: if going up, nevermind don't bounce
        ld a, b
        and a, %10000000
        jp nz, .applyBallY

    ;ground ball

        ;y should be on the ground
            ld a, $FF

        ;load ball y to c
            ld c, a

    ;invert y speed
        ;go to y speed
            inc hl
            inc hl

        ;invert it
            ld a, [hl]
            xor a, $FF
            inc a
            ld [hl], a

        ;go back to y
            dec hl
            dec hl

    cp a, 0
    jp z, .applyBallY
    cp a, $FF
    jp z, .applyBallY

    ;make sound
    call MakeBumpSound

.applyBallY

    ld a, c

    ;apply y
    ld [hli], a
    
    ;get x speed to b
    inc hl
    inc hl
    ld a, [hld]
    ld b, a
    dec hl
    ;get x to a
    ld a, [hl]
    ;a is x, b is speed
    add a, b
    ;c is x, b is speed
    ld c, a

    ;check if touched wall
    cp a, 160-8
    jp nc, .checkXtoReverse
    jp z, .checkXtoReverse
    cp a, 0
    jp z, .checkXtoReverse

    jp .afterReversingXspd

.checkXtoReverse

    ld a, b
    and a, %10000000
    jp nz, .clampToLeftWall
    jp z, .clampToRightWall

.clampToLeftWall

    ld a, 0
    jp .reverseXspd

.clampToRightWall

    ld a, 160-8
    jp .reverseXspd

.reverseXspd

    ld c, a

    inc hl
    inc hl

    ld a, b
    xor a, $FF
    inc a
    ld [hl], a

    dec hl
    dec hl

    cp a, 0
    jp z, .afterReversingXspd
    ;cp a, $FF
    ;jp z, .afterReversingXspd

    call MakeBumpSound

.afterReversingXspd

    ld a, c

    ;if x >= (screen width - 8)

    ;apply x
    ld [hli], a

    inc hl
    inc hl

    ;decrease ball count, jump back to ball check
    dec d
    jp .checkIfAnyBalls

.end


;============================================   ball gfx handler   ======================================


BallGFXHandler:

    ;get no of balls, source pos and dest pos
        ld a, [varNoOfBalls]
        ld d, a
        ld hl, _OAMRAM+4
        ld bc, BallVars

    ;d = no of balls
    ;hl = oam address
    ;bc = ball vars

.checkAnyBallsLeft

    ;check if any balls left
        ld a, d
        cp a, 0
    ;if not, exit loop
        ret z

.copyABall
    ;copy y
        ld a, [bc]
        sra a
        and a, %01111111
        add a, 27
        ld [hli], a
        inc bc
    ;copy x
        ld a, [bc]
        add a, 8
        ld [hli], a
        inc bc
    ;set sprite
        ld a, 38
        ld [hli], a
        inc bc
    ;skip sprite options
        inc hl
        inc bc

    ;decrease ball count, jump back to ball check
        dec d
        jp .checkAnyBallsLeft

.end

MakeBumpSound:

    push  hl

    ;length timer
    ld hl, rAUD4LEN
    ;2 ignored bits, timer speed (higher means channel cuts earlier)
    ld a, %00111100
    ld [hl], a

    ;volume and envelope
    ld hl, rAUD4ENV
    ;volume, sweep dir, sweep speed
    ld a, %11110000
    ld [hl], a

    ;frequency and randomness
    ld hl, rAUD4POLY
    ;4 clock shift, 1 sample length (15/7 bits), 3 clock divider
    ld a, %00010100
    ld [hl], a

    ;control
    ld hl, rAUD4GO
    ;trigger, length enable, 6 ignored bits
    ld a, %11000000
    ld [hl], a


    pop hl
    ret

.end