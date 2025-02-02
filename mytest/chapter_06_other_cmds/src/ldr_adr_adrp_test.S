.globl ldr_adr_adrp_test

//8字节对齐
.align 3
my_data1:
    .dword 0x8a
my_test_data:
    .dword 0x12345678abcdabcd


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

    adr x0, my_test_data
    ldr x1, [x0]

    adrp x2, my_test_data
    add x2, x2, #:lo12:my_test_data
    ldr x3, [x2]

    // ldr 直接获取
    ldr x4, my_test_data
    // ldr 先获取地址、再通过地址获取内容
    ldr x5, =my_test_data
    //当运行地址不等于链接地址时,运行到这一句会导致跑飞
    //ldr x6, [x5]

    //比较一下 ldr adrp
    // 加载位于 4MB地址 处的 init_pg_dir
    // 它们的区别在于, 运行地址和链接地址是否相同
    // 先用 aarch64-linux-gnu-readelf -S benos.elf 得到各个段的链接地址,
    // 再基于其信息使用以下命令加载elf,否则gdb单步调试无法使用
    // 例如:add-symbol-file benos.elf 0x80030 -s  .text.boot 0x80000 -s .rodata 0x80758
    // 当运行地址不等于链接地址时,它们的值会相差非常大, 由此可见, ldr伪指令 并不能替代 adrp
    adrp x7, init_pg_dir
    ldr x8, =init_pg_dir

    ret
