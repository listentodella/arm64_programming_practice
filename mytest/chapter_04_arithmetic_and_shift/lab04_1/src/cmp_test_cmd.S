.global cmp_imm_test
.global cmp_b_test

// cmp 指令其实就是 subs 的别名
// cmp <xn|sp>, op2 ==> subs xzr, <xn|sp>, op2
// 相当于 subs 将结果一直往 零寄存器里扔
//零寄存器——一直都是0！
cmp_imm_test:
    mov x0, #0
    mov x1, #1
    mov x2, #2

    cmp x0, #1
    mov x3, xzr
    subs xzr, x0, #1
    mov x3, xzr

    cmp x1, #1
    mov x3, xzr
    subs xzr, x1, #1
    mov x3, xzr

    cmp x2, #1
    mov x3, xzr
    subs xzr, x1, #1
    mov x3, xzr

    ret


cmp_b_test:
    mov x1, #3
    mov x2, #2


label1:
    //实际是subs,可以更新 NZCV
    cmp x1, x2
    mov x1, #2
    mov x2, #3
    //cs: 是否有无符号溢出 如果 C 位为1,则执行
    b.cs label1
    //ls: 无符号 <=
    b.ls label2

label2:


    ret
