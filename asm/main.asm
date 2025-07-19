INCLUDE "../hardware.inc"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

INCLUDE "macros.asm"

INCLUDE "startup.asm"

INCLUDE "mainLoop.asm"

INCLUDE "mainMenu.asm"

INCLUDE "ballCode.asm"

INCLUDE "vblankHandler.asm"

INCLUDE "functions.asm"

INCLUDE "graphics.asm"

INCLUDE "otherData.asm"

INCLUDE "memVariables.asm"