.global csel_test_asm


csel_test_asm:
    eor x2, x2, x2
    eor x3, x3, x3
    add x2, x1, #2
    sub x3, x1, #1
    cmp x0, 0
    csel x0, x2, x3, eq
    ret
