.global add_1
add_1:
    add x0, x0, x1
    ret

.global add_2
add_2:
    add x0, x0, x1
    ret


.macro add_func a, b, label
    stp x29, x30, [sp, #-16]!
mov x0, \a
mov x1, \b
bl add_\()\label
    ldp x29, x30, [sp], #16
.endm

.global add_macro_test
add_macro_test:
    add_func x0, x1, 1
    add_func x0, x1, 2
    ret
