SECTION "Strings", ROM0

Strings:

.S0
    DB "PALETTE 1"
    DB $FF
.S1
    DB "PALETTE 2"
    DB $FF
.S2
    DB "RESTART"
    DB $FF
.S3
    DB "PLAY SOUND"
    DB $FF
.S4
    DB "PLAY SAMPLE"
    DB $FF
.S5
    DB "ADD BALL"
    DB $FF

.S6
    DB "BALL VARS"
    DB $FF
.S7
    DB "X"
    DB $FF
.S8
    DB "Y"
    DB $FF
.S9
    DB "X SPEED"
    DB $FF
.S10
    DB "Y SPEED"
    DB $FF

.S11
    DB "HOPE UPSTAIRS BALLIN"
    DB $FF

.S12
    DB "H   BALLS ACTIVE"
    DB $FF

.S13
    DB "REACHED SCANLINE H"
    DB $FF

.end

StringsLookup:
    DW Strings.S0
    DW Strings.S1
    DW Strings.S2
    DW Strings.S3
    DW Strings.S4
    DW Strings.S5
    DW Strings.S6
    DW Strings.S7
    DW Strings.S8
    DW Strings.S9
    DW Strings.S10
    DW Strings.S11
    DW Strings.S12
    DW Strings.S13
.end

;SECTION "HardLuck sample", ROM0

;HardLuck:
;    INCBIN "out.raw"
;.end
