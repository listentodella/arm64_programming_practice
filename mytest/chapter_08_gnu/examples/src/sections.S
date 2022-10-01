.section .data
.align 3
.global my_atomic_data
my_atomic_data:
    .dword 0x0

.section .diy.text
.global atomic_set
atomic_set:
1:
    ldxr x2, [x1]
    orr x2, x2, x0
    stxr w3, x2, [x1]
    cbnz w3, 1b
    ret

.section .text
.global my_atomic_write
my_atomic_write:
    adr x6, my_atomic_data
1:
    ldxr x2, [x6]
    orr x2, x2, x0
    stxr w3, x2, [x6]
    cbnz w3, 1b

    mov x0, x2
    ret

.pushsection ".diy.text"
.global fun1
fun1:
    ret
.popsection


.global fun2
fun2:
    ret

/*
 * 通过 objdump -x 命令来查看细节
 * 可以发现只有 .pushsection ... .popsection 之间的会被链接到指定的段
...
 SYMBOL TABLE:
 0000000000000000 g       .data	0000000000000000 my_atomic_data
 0000000000000000 g       .diy.text	0000000000000000 atomic_set
 0000000000000000 g       .text	0000000000000000 my_atomic_write
 0000000000000014 g       .diy.text	0000000000000000 fun1
 000000000000001c g       .text	0000000000000000 fun2
...
 */
