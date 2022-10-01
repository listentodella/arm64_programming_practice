.align 3
.section .data
.global my_kallsyms_addr
my_kallsyms_addr:
    .quad 0x800800
    .quad 0x800860
    .quad 0x800880

.align 3
.global my_kallsyms_string
my_kallsyms_string:
    .asciz "func_a"
    .asciz "func_b"
    .asciz "func_c"

.align 3
.global my_kallsyms_cnt
my_kallsyms_cnt:
    .quad 3

//.section .text
//.global get_my_kallsyms
