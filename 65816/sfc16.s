;NOT TESTED
RandomState:
    .word 4
RandomScratch:
    .word 2

Random:
    .a16
    ; function prefix can be adjusted as needed of course
    PHP
    PHD
    REP #$20 ; 16 bit accumulator/memory
    LDA #RandomState
    TCD

    ; important stuff starts here
    LDA $0
    CLC
    ADC $2
    CLC
    ADC $6
    INC $6
    STA $8
    LDA $2
    LSR
    LSR
    LSR
    EOR $2
    STA $0
    LDA $4
    ASL
    ASL
    CLC
    ADC $4
    STA $2
    LDA $4
    ASL
    ADC #0
    ASL
    ADC #0
    ASL
    ADC #0
    ASL
    ADC #0
    ADC $8
    STA $4
    LDA $8

    ;end important stuff
    PLD
    PLP
    RTS