.section .data
my_data:
    .dword 0x0A
    .dword 0x0B
    .dword 0x0C
    .dword 0x0D

my_data_count:
    .quad 4

put_string:
    .string "the max is %d\n"


.section .text

.global get_max_asm
get_max_asm:
    ldr x0, =my_data
    ldr x1, my_data_count
    //ldp x1, x2, [x0, #0]!
    //ldp x3, x4, [x0, #16]!

    mov x2, #0
    mov x4, #0//as count
1:
    ldr x3, [x0], #8
    cmp x3, x2
    csel x2, x3, x2, hi

    add x4, x4, #1
    cmp x4, x1
    //b.le 1b//有符号数 <=
    b.lt 1b//有符号数 <

    ldr x0, =put_string
    mov x1, x3

    //bl printf//整体似乎无法编译过去,单独可以

    ret
