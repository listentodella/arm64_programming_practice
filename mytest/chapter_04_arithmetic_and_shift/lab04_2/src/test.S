.global compare_and_return_asm

//param1->x0, param2->x1
compare_and_return_asm:
/* 可以达到目的, 但并没有利用好C标志位
    cmp x0, x1
    b.ls out1
    bne  out2
out1:
    ldr x0, =0xFFFFFFFFFFFFFFFF
    ret
out2:
    mov x0, xzr
    ret
 */
    cmp x0, x1//subs xzr, x0, x1 => xzr=x0+!(x1)+1 可以更新NZCV
    // 如果 x0 < x1, 那么不会产生无符号溢出,则C=0,结果就是0xFFF..FF
    // 如果 x0 >= x1, 那么C=1, 结果就是 0
    sbc x0, xzr, xzr//x0 = 0 + !(0) + C = 0+0xFFF..FF + C
    ret
