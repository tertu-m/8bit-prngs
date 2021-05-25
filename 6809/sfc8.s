;SFC8 for 6809
;A port of SFC8 with constants by M. E. O'Neill based on Chris
;Doty-Humphrey's SFC PRNG scheme.
;I don't really know how the 6809 works so this might not compile.

;Returns a random 8-bit number in A
;Other registers untouched, carry indeterminate.
;This could be made slightly quicker by using a direct page variable to hold
;the temporary value, which is the decision I made on the 6502.
_random:
    ;a, b, c, and d are the input variables
    ;a', b', c', d' are the outputs
    
    ;temp (the result) = a + b + d
    lda RndA
    adda RndD
    adda RndB
    pshu a
    ;d' = d++
    inc RndD
    ;a' = b eor (b >> 2)
    lda RndB
    lsra
    lsra
    eora RndB
    sta RndA
    ;b' = c + (c << 1)
    lda RndC
    asla
    adda RndC
    sta RndB
    ;c' = rol8(c, 3) + temp
    lda RndC
    asla
    adca #0
    asla
    adca #0
    asla
    adca #0
    adda ,s
    sta RndC
    lda ,s+
    rts
