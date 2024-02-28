;Probably NOT TESTED
;Should work under the standard C calling convention.
;Assumes the random state is stored in the lds area.
;Uses 25 words and ~39 cycles (including ret).
.DEVICE ATmega328P
.dseg
RndA: .BYTE 1
RndB: .BYTE 1
RndC: .BYTE 1
RndD: .BYTE 1
.cseg
rand:
    lds r24, RndA
    lds r18, RndB
    add r24, r18
    lds r0, RndD
    add r24, r0
    inc r0
    sts RndD, r0
    mov r0, r18
    lsr r0
    lsr r0
    eor r18, r0
    sts RndA, r18
    lds r18, RndC
    mov r0, r18
    lsl r0
    add r0, r18
    sts RndB, r0
    ;rotate left by 3 by swapping and rotating right by 1 (slightly faster and smaller)
    swap r18
    ror r18
    ;extract carry from SREG and replace bit 7 of r18 with it
    lds r0, 0x3F
    bst r0, 0
    bld r18, 7
    add r18, r24
    sts RndC, r18
    ret
