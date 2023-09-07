__random:
    ;temp = hRNGStateCounter, hRNGStateCounter += 1
    ldh a, [hRNGStateCounter]
    ld l, a
    add a, 1
    ldh [hRNGStateCounter], a
    ldh a, [hRNGStateCounter+1]
    ld h, a
    adc a, 0
    ldh [hRNGStateCounter+1], a

    ;temp += hRNGStateA
    ldh a, [hRNGStateA]
    add a, l
    ld l, a
    ldh a, [hRNGStateA+1]
    adc a, h
    ld h, a

    ;temp += hRNGStateB
    ldh a, [hRNGStateB+1]
    ld d, a
    ldh a, [hRNGStateB]
    ld e, a
    add hl, de
    push hl

    ;hRNGStateA = hRNGStateB ^ hRNGStateB >> 3
    ld h, d
    rept 3
        srl h
        rra
    endr
    xor e
    ldh [hRNGStateA], a
    ld a, h
    xor d
    ldh [hRNGStateA+1], a

    ;hRNGStateB = hRNGStateC * 5
    ldh a, [hRNGStateC]
    ld e, a
    ld l, a
    ldh a, [hRNGStateC+1]
    ld d, a
    ld h, a
    add hl, hl
    add hl, hl
    add hl, de
    ld a, l
    ldh [hRNGStateB], a
    ld a, h
    ldh [hRNGStateB+1], a

    ;hRNGStateC = hRNGStateC rol 4 + temp
    ;thank you to calc84maniac for the xor-swap rol 4 code
    ;and other improvements
    swap d
    swap e
    ld a, d
    xor e
    ld d, a
    and $0F
    xor e
    ld e, a
    xor d
    ld d, a
    pop hl
    ld a, l
    add a, e
    ldh [hRNGStateC], a
    ld a, h
    adc d
    ldh [hRNGStateC+1], a
    ret