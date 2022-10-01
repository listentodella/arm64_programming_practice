.global get_bigger_asm

get_bigger_asm:
    cmp x0, x1
    csel x0, x0, x1, hi
    ret

.global c_call_me
c_call_me:
    stp x29, x30, [sp, #-16]!

    mov x0, #11
    mov x1, #12
    bl get_bigger

    ldp x29, x30, [sp], #16
    ret
