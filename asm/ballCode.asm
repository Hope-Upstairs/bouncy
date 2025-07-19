SECTION "BallCode", ROM0

SpawnBall:

    ;get no of balls
        ld a, [varNoOfBalls]
        ld bc, 0
        ld hl, BallVars

    ;return if max balls already reached
        cp a, noMaxBalls
        ret z

    ;go to the current ball's vars (4 vars per ball so multiply by 4)
        sla a
        sla a
        ld c, a
        add hl, bc

    ;hl is now the proper address for the ball vars

    ;set vars
        ;ball y
            ld a, [rDIV]
            ld [hli], a

        ;ball x
            ld a, [rDIV]
            swap a
            ld [hli], a

        ;ball yspd
            ld a, -1
            ld [hli], a
        
        ;ball xspd
            ld a, [rDIV]
            and a, %00000011
            ld [hli], a

    ;increase no of balls
        ld hl, varNoOfBalls
        inc [hl]

    ret
    
.end

RemoveBall:

    ;get no of balls
        ld a, [varNoOfBalls]
        cp a, 0
        ret z   ;return if no balls
        ;ld bc, 0
        ;ld hl, BallVars

    ;decrease no of balls
        ld hl, varNoOfBalls
        dec [hl]

        ld a, 1
        ld [varShouldHideLastBall], a

    ret

.end


;=============================================   ball handler   =========================================


HandleBalls:

    ;get no of balls, vars pos
        ld a, [varNoOfBalls]
        ld d, a
        ld hl, BallVars

    ;d = no of balls
    ;hl = ball var address
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
        ld hl, FauxOAM
        ld bc, BallVars

    ;d = no of balls
    ;hl = oam address
    ;bc = ball vars

.checkAnyBallsLeft

    ;check if any balls left
        ld a, d
        cp a, 0
    ;if not, exit loop
        jp z, .hideLastBall

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

.hideLastBall:

    ld a, [varShouldHideLastBall]
    cp a, 0
    ret z

    ld a, 0
    ld [hl], a
    ld [varShouldHideLastBall], a
    ret

.end

MakeBumpSound:

    push hl
    push bc

    ;get sound state
    ld bc, varSoundOn
    ;check if 0
    ld a, [bc]
    cp a, 0
    jp z, .skip

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

.skip
    pop bc
    pop hl
    ret

.end