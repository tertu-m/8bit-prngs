;Returns 1 random byte in A and B
rand:
    ldab RndB
    tba
    addb RndCtr
    inc RndCtr
    addb RndA
    lsra
    lsra
    eora RndB
    staa RndA
    ldaa RndC
    asla
    adda RndC
    staa RndB
    ldaa RndC
    rola
    adca #0
    rola
    adca #0
    rola
    adca #0
    aba
    staa RndC
    tba
    rts


;8 bit seed for convenience
srand8:
    ldab #$ED
;16 bit seed in a, b little endian
;trashes A and B, clears X
srand:
    staa RndC
    stab RndB
    clra
    staa RndA
    inca
    staa RndCtr
    ldx #15
    _loop:
    jsr rand
    dex
    bne _loop
    rts
