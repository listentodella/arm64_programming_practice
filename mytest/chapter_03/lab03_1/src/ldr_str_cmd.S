#define MY_LABEL 0x20

.global ldr_cmd_test //不写这个 global, C函数无法找到它
.global my_memcpy

ldr_cmd_test:
    //1. 测试 ldr 地址偏移模式
    mov x1, 0x80000
    mov x3, 16

    // 读取 0x80000 地址里的值到 x0
    //ldr x0, x1, 编译器也不识别这种写法
    mov x0, 0
    /* 基址寻址 */
    // 由于是从内存 0x80000 里取数据到 x0,所以无法直接得知 0x80000地址里的具体数据
    // 在 gdb cmdline 里 输入 x 0x80000 或者 x/x 0x80000, 即可查看4字节的内容
    // 输入 x/xg 0x80000 即可查看 8字节的内容
    ldr x0, [x1]
    str x3, [x1]

    /* 基址+偏移量 寻址 */
    // 读取 0x80008地址里的 值到 x2
    //ldr x2, [0x80000, #8], 这种写法编译器会拦截
    //ldr x2, [=0x80000, #8], 这种写法编译器会拦截
    ldr x2, [x1, #8]
    ldr x2, [x1, #9]

    /* 基址扩展模式 */
    // 读取 x1 + x3 地址的值
    ldr x4, [x1, x3]

    // 读取 x1 + x3 << 3 地址的值
    ldr x5, [x1, x3, lsl #3]
    //ldr x5, [x1, x3, lsl #1], 会有编译错误, 手册里有写 只支持 0 或 3

    /* 变基模式 */
    // 前变基模式
    ldr x6, [x1, #8]!

    mov x2, 0x400000
    ldr x6, =0x1234abce//ldr 伪指令, 因为有 "="
    str x6, [x2, #8]!

    // 后变基模式
    mov x1, 0x80000
    ldr x7, [x1], #8

    mov x2, 0x500000
    str x6, [x2], #8

    /* PC相对地址模式 */
    // 这个方式, 同样是加载 以 PC+0x20 的值的内存地址的值到x6
    ldr x6, 0x20//内存访问指令
    mov x6, 0x00
    ldr x6, MY_LABEL
    // 这个方式, 是立即数, 相当于 mov x7, 0x20
    ldr x7, =MY_LABEL//ldr 伪指令, 编译器会去将它翻译为ARM指令

my_memcpy:
    mov x0, 0x80000
    mov x1, 0x200000
    add x2, x0, #32
loop:
    ldr x4, [x0], #8
    str x4, [x1], #8
    cmp x0, x2
    bcc loop


    ret
