.global compare_and_return_asm
.global bit_fields_test

//param1->x0, param2->x1
compare_and_return_asm:
/* 可以达到目的, 但并没有利用好C标志位
    cmp x0, x1
    b.ls out1
    bne  out2
out1:
    ldr x0, =0xFFFFFFFFFFFFFFFF
    ret
out2:
    mov x0, xzr
    ret
 */
    cmp x0, x1//subs xzr, x0, x1 => xzr=x0+!(x1)+1 可以更新NZCV
    // 如果 x0 < x1, 那么不会产生无符号溢出,则C=0,结果就是0xFFF..FF
    // 如果 x0 >= x1, 那么C=1, 结果就是 0
    sbc x0, xzr, xzr//x0 = 0 + !(0) + C = 0+0xFFF..FF + C
    ret

bit_fields_test:
    mov x0, xzr
    mov x1, xzr
    mov x2, xzr
    msr nzcv, xzr
    mov x1, -1
    mov x2, -1
    ands x0, x1, x2
    mrs x3, nzcv

    mov x4, xzr
    ubfx x4, x3, #28, #4
    sbfx x4, x3, #28, #4

    eor x0, x0, x0
    mov x1, #0x345
    // 用 x1 [0:3] 替换 x0[8:11]
    bfi x0, x1, #8, #4

    eor x3, x3, x3
    ldr x2, =0x5678abcd//0b ... bc..
    ubfx x3, x2, #4, #8// bc
    sbfx x4, x2, #4, #8//fff..bc

    //ubfx x0, ID_AA64ISAR0_EL1, #20, #4
    //ubfx x0, ID_AA64ISAR0_EL1, #4, #4
    mrs x1, id_aa64isar0_el1
    /*
     * 0b0000	No Atomic instructions implemented.
     * 0b0010	LDADD, LDCLR, LDEOR, LDSET, LDSMAX,
                LDSMIN, LDUMAX, LDUMIN, CAS, CASP,
                and SWP instructions implemented.
     */
    ubfx x0, x1, #20, #4
    /*
     * 0b0000 No AES instructions implemented.
     * 0b0001 AESE, AESD, AESMC, and AESIMC instructions implemented.
     * 0b0010, 在1的基础上, PMULL/PMULL2 instructions
                operating on 64-bit data quantities.
     */
    ubfx x0, x1, #4, #4


    ret
