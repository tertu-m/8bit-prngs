;SFC8 for 6502
;Returns a random 8-bit number in RndResult and A
;Carry is indeterminate
;A port of SFC8 with constants by M. E. O'Neill based on Chris
;Doty-Humphrey's SFC PRNG scheme.
;Takes 75 cycles if state is in zpg, 90 if it is not.
_random:
    ;note: all arithmetic should be unsigned
    ;a, b, c, and d are the input variables
    ;a', b', c', d' are the outputs
    
    ;temp (the result) = a + b + d
    lda RndD
    clc
    adc RndA
    clc
    adc RndB
    sta RndResult
    ;d' = d++
    inc RndD
    ;a' = b eor (b >> 2)
    lda RndB
    lsr a
    lsr a
    eor RndB
    sta RndA
    ;b' = c + (c << 1)
    lda RndC
    asl a
    clc
    adc RndC
    sta RndB
    ;c' = rol8(c, 3) + temp
    lda RndC
    asl a
    adc #0
    asl a
    adc #0
    asl a
    adc #0
    adc RndResult
    sta RndC
    lda RndResult
    rts
;If you're okay with blowing 256 bytes of space on it and trashing X you could
;replace the rotation with
;ldx RndC
;lda Rol3Lut, X
;clc
;which saves 6 cycles assuming Rol3Lut is page-aligned (5-6 if it is not)
