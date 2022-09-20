.global push_pop_stack

push_pop_stack:
    // 栈往下扩展16字节
    stp x29, x30, [sp, #-16]!

    // 把栈继续往下扩展 8 字节
    add  sp, sp, #-8

    mov x8,  #1

    // x8 保存到SP 指向的位置上
    str x8, [sp]


    // 释放刚才扩展的8字节栈空间
    // 经过实验只是单纯的释放, 并不等于出栈到X8
    mov x8, #8
    add sp, sp, #8
    // 这句才算出栈到 X8
    ldr x8, [sp, #-8]

    // push_pop_stack 返回 0
    mov w0, 0

    // 恢复 x29 x30 寄存器的值, 并使 SP 指向原位置
    mov x29, #0
    mov x30, #0
    ldp x29, x30, [sp], #16

    ret
