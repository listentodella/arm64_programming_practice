.globl ldr_adr_adrp_test

//8字节对齐
.align 3
my_data1:
    .dword 0x8a



ldr_adr_adrp_test:
    adr x0, my_data1
    ldr x1, [x0]

    //会发现adrp加载的地址是按4KB对齐的
    adrp x2, my_data1
    ldr x3, [x2]

    adrp x2, my_data1
    //利用GNU汇编器中的 "#:lo12:"功能,它表示4K大小的偏移量
    add x2, x2, #:lo12:my_data1
    ldr x3, [x2]


    ret
