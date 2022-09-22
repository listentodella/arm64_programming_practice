.global bl_lab_test

bl_lab_test:
    stp x29, x30, [sp, #-16]!
    mov x0, 12
    mov x1, 8
    bl csel_test_asm
    ldp x29, x30, [sp], #16

    ret
