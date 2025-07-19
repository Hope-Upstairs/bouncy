SECTION "Strings", ROM0

Strings:

.S0
    DB "ADD BALL"
    DB $FF

.S1
    DB "RESTART"
    DB $FF

.S2
    DB "HOPE UPSTAIRS BALLIN"
    DB $FF

.S3
    DB "H   BALLS ACTIVE"
    DB $FF

.S4
    DB "REACHED SCANLINE H"
    DB $FF

.S5
    DB "REMOVE BALL"
    DB $FF

.S6
    DB "BOUNCE SOUND ON "
    DB $FF

.S7
    DB "V2"
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
.end
    