;A port of SFC8 with constants by M. E. O'Neill based on Chris
;Doty-Humphrey's SFC PRNG scheme.
;Returns a random 8-bit number in RndResult and A
;Carry is indeterminate
;Period is variable, see below.
;74 cycles (less jsr/rts), 46 bytes

.zeropage
RndA: .res 1
RndB: .res 1
RndC: .res 1
RndD: .res 1
RndResult: .res 1

.code
rand:
    ;note: all arithmetic is unsigned
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
    lda RndResult ; optional (otherwise a=RndC, which you shouldn't use)
    rts

; This is an alternative implementation.
; It takes 64 cycles and 40 bytes for the main routine,
; but requires a 256 byte page-aligned lookup table (Rol3Lut)
; consisting of bytes rotated left by 3.
rand_lut:
    ;note: all arithmetic is unsigned
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
    tax
    asl a
    clc
    adc RndC
    sta RndB
    ;c' = rol8(c, 3) + temp
    lda Rol3Lut, X
    clc
    adc RndResult
    sta RndC
    lda RndResult ; optional (otherwise a=RndC, which you shouldn't use)
    rts

; Pass the seed in A, X.
; srand_8 only uses A and srand_16 adds X to that.
; srand_8 guarantees a period of at least 56929536 (~2^25.8)
; srand_16 guarantees a period of at least 175616 (~2^17.4)
; The largest cycle is length 2976151296; about 70% of seeds are on that cycle.
; For srand_16, the following A, X pairs should be avoided for a better minimum
; bound of 2461696:
; ($4E, $AB), ($5E, $22), ($5E, $4B), ($C8, $A4), ($EC, $6F), ($FB, $CE)
; Note that if you set all of RndC, RndB, and RndA to 0, that seed is on the
; longest cycle, so if you want a constant seed, that's not a bad choice.
; You still should set RndD to 1 though regardless.
srand_8:
    ldx #$FF
srand_16:
    ldy #$ED
    sta RndA
    stx RndB
    sty RndC
    lda #1
    sta RndD
    ldy #12
:
    jsr rand
    dey
    bne :-
    rts


; Pass a seed in A.
; The GoodSeeds table is a table of 9 bit seed values with their high bit cut off.
; The high bit of the seed is appended to the 8 bit value loaded from the table to form the whole seed.
; This allows a guaranteed long-period seed.
; Clobbers X.
srand_8_goodseeds:
    tax
    asl a
    lda #0
    sta RndA
    adc #0
    sta RndB
    lda GoodSeeds, X
    sta RndC
    lda #1
    sta RndD
    ldx #12
:
    jsr rand ;or rand_lut if you're using that
    dex
    bne :-
    rts