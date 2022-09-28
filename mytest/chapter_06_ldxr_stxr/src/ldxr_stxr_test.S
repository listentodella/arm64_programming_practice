.align 3
.global my_data
my_data:
    .dword 0x0

.global my_atomic_write_asm
my_atomic_write_asm:
    adr x6, my_data

1:
    //ldxr ~ stxr 之间的操作是不能单步调试的,因为它们是原子的!
    //操作完成后可以使用 x/xg mem_addr 查看目标内存地址里的值
    ldxr x2, [x6]
    mov x2, x0
    stxr w3, x2, [x6]
    cbnz w3, 1b

    //mov x0, 0
    mrs x0, currentEL
    ret

.global atomic_set_asm
//nr->x0, addr->x1
atomic_set_asm:
2:
    ldxr x4, [x1]
    mov x2, x0
    mov x3, 1
    lsl x2, x3, x2
    orr x2, x2, x4
    stxr w5, x2, [x1]
    cbnz w5, 2b

    ret
