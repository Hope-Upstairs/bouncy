DEF noMaxBalls equ $28

SECTION "Variables", WRAM0

;faux oam
    FauxOAM: DS $A0

;input
    wCurKeys: DB
    wNewKeys: DB

;menu
    varCurPos: DB
    varNoOfOptions: DB
    varFrameCounter: DB
    varSoundOn: DB
    varShouldHideLastBall: DB

;balls
    varNoOfBalls: DB
    BallVars: DS 4*noMaxBalls
    