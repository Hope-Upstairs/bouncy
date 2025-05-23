INCLUDE "../hardware.inc"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

Chars:
    CHARMAP " ", $00
    CHARMAP "0", $01 
    CHARMAP "1", $02 
    CHARMAP "2", $03 
    CHARMAP "3", $04 
    CHARMAP "4", $05 
    CHARMAP "5", $06 
    CHARMAP "6", $07 
    CHARMAP "7", $08 
    CHARMAP "8", $09 
    CHARMAP "9", $0A 
	CHARMAP "A", $0B 
	CHARMAP "B", $0C 
	CHARMAP "C", $0D 
	CHARMAP "D", $0E 
	CHARMAP "E", $0F 
	CHARMAP "F", $10
	CHARMAP "G", $11
	CHARMAP "H", $12
	CHARMAP "I", $13
	CHARMAP "J", $14
	CHARMAP "K", $15
	CHARMAP "L", $16
	CHARMAP "M", $17
	CHARMAP "N", $18
	CHARMAP "O", $19
	CHARMAP "P", $1A
	CHARMAP "Q", $1B
	CHARMAP "R", $1C
	CHARMAP "S", $1D
	CHARMAP "T", $1E
	CHARMAP "U", $1F
	CHARMAP "V", $20
	CHARMAP "W", $21
	CHARMAP "X", $22
	CHARMAP "Y", $23
	CHARMAP "Z", $24
	CHARMAP "a", $0B 
	CHARMAP "b", $0C 
	CHARMAP "c", $0D 
	CHARMAP "d", $0E 
	CHARMAP "e", $0F 
	CHARMAP "f", $10
	CHARMAP "g", $11
	CHARMAP "h", $12
	CHARMAP "i", $13
	CHARMAP "j", $14
	CHARMAP "k", $15
	CHARMAP "l", $16
	CHARMAP "m", $17
	CHARMAP "n", $18
	CHARMAP "o", $19
	CHARMAP "p", $1A
	CHARMAP "q", $1B
	CHARMAP "r", $1C
	CHARMAP "s", $1D
	CHARMAP "t", $1E
	CHARMAP "u", $1F
	CHARMAP "v", $20
	CHARMAP "w", $21
	CHARMAP "x", $22
	CHARMAP "y", $23
	CHARMAP "z", $24
.end

INCLUDE "startup.asm"

INCLUDE "mainLoop.asm"

INCLUDE "mainMenu.asm"

INCLUDE "ballCode.asm"

INCLUDE "vblankHandler.asm"

INCLUDE "functions.asm"

INCLUDE "graphics.asm"

INCLUDE "otherData.asm"

INCLUDE "memVariables.asm"