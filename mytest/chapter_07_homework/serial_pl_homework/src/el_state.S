.global get_el_state

get_el_state:
    mrs x0, currentEL
    ubfx x0, x0, 2, 2
    ret
