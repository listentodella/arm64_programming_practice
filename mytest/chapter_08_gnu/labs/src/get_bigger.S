.global get_bigger_asm

get_bigger_asm:
    cmp x0, x1
    csel x0, x0, x1, hi
    ret
