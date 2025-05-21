SECTION "Functions", ROM0

UpdateKeys:
    ; Poll half the controller
    ld a, P1F_GET_BTN
    call .onenibble
    ld b, a ; B7-4 = 1; B3-0 = unpressed buttons
    
    ; Poll the other half
    ld a, P1F_GET_DPAD
    call .onenibble
    swap a ; A3-0 = unpressed directions; A7-4 = 1
    xor a, b ; A = pressed buttons + directions
    ld b, a ; B = pressed buttons + directions
    
    ; And release the controller
    ld a, P1F_GET_NONE
    ldh [rP1], a
    
    ; Combine with previous wCurKeys to make wNewKeys
    ld a, [wCurKeys]
    xor a, b ; A = keys that changed state
    and a, b ; A = keys that changed to pressed
    ld [wNewKeys], a
    ld a, b
    ld [wCurKeys], a
    ret


.onenibble
    ldh [rP1], a ; switch the key matrix
    call .knownret ; burn 10 cycles calling a known ret
    REPT 3 ; ignore value while waiting for the key matrix to settle
        ldh a, [rP1]
    ENDR
    or a, $F0 ; A7-4 = 1; A3-0 = unpressed keys


.knownret
    ret



; Sets some memory to 0.
; @param hl: Starting pos
; @param bc: Length
Memclear:
    ld a, 0  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, Memclear  ;if not zero (data isn't finished copying), go back
    ret

; Copy bytes from one area to another.
; @param de: Source
; @param hl: Destination
; @param bc: Length
Memcopy:
    ld a, [de]  ;load val from source
    ld [hli], a ;put value into dest, increase dest
    inc de      ;increase source
    dec bc      ;decrease length
    ld a, b     ;
    or a, c     ;check if B or C aren't 0 (length is BC, if it's 0 it sets the 0 flag)
    jp nz, Memcopy  ;if not zero (data isn't finished copying), go back
    ret

; Write a number in hex at the specified tile coord
; @param A: number to write
; @param HL: tile index to write at
; @ also uses registers BC
DisplayHex:

    ;go to start of tilemap + selected tile
    ld bc, $9800
    add hl, bc

    ;store original number to b (for later use (when getting the second digit))
    ld b, a

    ;get the first digit
    swap a
    and a, $0F

    ;digit tile offset (font starts at $01)
    inc a

    ;write first digit
    ld [hl+], a

    ;get the second digit
    ld a, b
    and a, $0F

    ;digit tile offset
    inc a

    ;write second digit
    ld [hl+], a

    ret

; Write a string (from the list) at the specified tile coord
; @param L: string id
; @param DE: dest tile coord
; @uses A, BC, HL
DrawString:

    push de
    ld de, StringsLookup
    call GetAddressFromLookupTable
    pop de
    ; HL is now where the string starts

    ;get tilemap address
    push hl
    ld hl, _SCRN0
    add hl, de
    ld d, h
    ld e, l
    pop hl
    ; DE is the proper address to write on the tilemap
    ; HL is the string's starting pos
    ; BC and A should be free to use now

.loopStart

    ;get char to A
    ld a, [hli]

    ;return if char is FF (end of string)
    cp a, $FF
    ret z

    ;A contains the tile to set
    ld [de], a
    inc de

    jp .loopStart

; checks if A is pressed
; @ uses register A
CheckA:
    ld a, [wNewKeys]
    bit 1, a
    ret

CheckB:
    ld a, [wNewKeys]
    bit 2, a
    ret


TurnLCDOn:
    
    ; Turn the LCD on
    ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON | LCDCF_BG8000
    ld [rLCDC], a

    ret

; get an index's address from a lookup table
; @param L: index
; @param DE: table
GetAddressFromLookupTable:
    
    ; get address
    sla l
    ld h, 0
    ld b, d
    ld c, e
    add hl, bc
    ; HL is now the position to copy the location from

    ;go to string's starting pos
    ld a, [hli]
    ld b, a
    ld a, [hl]
    ld c, a
    ld l, b
    ld h, c
    ; HL is now where the string starts

    ret