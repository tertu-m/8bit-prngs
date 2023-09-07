@NOT TESTED
@SFC32 for ARMv4T (ARM7TDMI specifically)
@This is optimized for the Game Boy Advance, which has a slightly weird memory
@architecture that makes using LDMIA/STMIA quite good for performance.
@Compilers generally don't know about this One Weird Trick.
@Meant to be used with libseven.

.syntax         unified
.cpu            arm7tdmi

.include        "macros.s"

data SFC32_STATE
    .word 0, 0, 0, 1
endd

@ void sfc32_seed_one(uint32_t seed)
@ Only supports 1 word of seed but is faster and simpler
fn sfc32_seed_one thumb
    push {r4}
    movs r2, r0
    movs r0, #0
    movs r1, #0
    movs r3, #1
    ldr r4, =SFC32_STATE
    stmia r4!, {r0, r1, r2, r3}
    movs r4, #16
seed_loop
    bl sfc32_rand
    subs r4, #1
    bne seed_loop
    pop {r4}
    bx lr
endfn

@ void sfc32_seed_many(uint32_t count, uint32_t *seed_data)
@ 1-3 words of seed are supported
@ if count is 0, it returns without doing anything
@ This probably needs more optimization work
fn sfc32_seed_many thumb
    cmp r0, #0
    beq return
    push {r4}
    cmp r0, #4
    bhs limit
start_copy
    ldr r3, =SFC32_STATE
    adds r3, r3, #12
    movs r2, #1
    str r3, r2
    subs r3, r3, #4
    movs r4, #0
copy_loop
    ldr r2, [r1]
    str r2, [r3]
    adds r1, r1, #4
    subs r3, r3, #4
    adds r4, r4, #1
    cmps r0, r4
    bne copy_loop
    cmps r4, #3
    beq seed
    movs r1, #0
zero_fill_loop
    subs r3, #4
    str r1, [r3]
    adds r4, r4, #1
    cmps r4, #3
    bne zero_fill_loop
seed
    movs r4, #18
seed_loop
    bl sfc32_rand
    subs r4, #1
    bne seed_loop
    pop {r4}
return
    bx lr
limit
    movs r0, #3
    b start_copy
endfn


@ uint32_t sfc32_rand(void)
fn sfc32_rand thumb
    push {r4, r5, r6}
    ldr r5, =SFC32_STATE
    ldmia r5!, {r1, r2, r3, r4}
    @ e (result) = a + b + d++
    adds r1, r1, r2
    adds r0, r1, r4
    adds r4, r4, #1
    @ a = b ^ (b >> 9)
    lsrs r1, r2, #9
    eors r1, r1, r2
    @ b = c + (c << 3) [c * 9]
    lsls r2, r3, #3
    adds r2, r2, r3
    @ c = rol(c, 21) + e
    movs r6, #11
    rors r3, r3, r6
    adds r3, r3, r0
    subs r5, r5, #16
    stmia r5!, {r1, r2, r3, r4}
    pop {r4, r5, r6}
    bx lr
endfn
