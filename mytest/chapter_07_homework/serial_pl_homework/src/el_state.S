.global get_el_state

get_el_state:
    stp x29, x30, [sp, #-16]!
    mrs x0, currentEL
    ubfx x0, x0, 2, 2
    ldp x29, x30, [sp], #16
    ret
