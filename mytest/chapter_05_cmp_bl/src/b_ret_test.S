.global b_ret_cmd_test
.global b_ret_cmd_test2
.global b_ret_cmd_test3
.global csel_test

csel_test:
    cmp x0, 0//pc:0x80360, lr:0x80380
    sub x2, x1, 1//pc:0x80364
    add x3, x1, 2//pc:0x80368
    csel x0, x3, x2, eq//pc:0x8036c
    //pc:0x80370, 执行完 lr 仍然是 0x80380,于是返回到父函数的bl指令的下一条
    ret

b_ret_cmd_test:
    //pc:0x80374, lr(x30):0x802f0->这个地址是b_ret_cmd_test调用者的返回地址
    mov x0, 1
    mov x1, 3//pc:0x80378
    bl csel_test//pc:0x8037c, lr(x30):0x802f0->执行完后变成0x80380
    // 如果跑飞, 无法显示 "Welcome BenOS"的子串
    ret//csel_test返回后, 执行该语句,但此时 lr 里不是它的父函数的地址, 所以跑飞！

    //这里选择备份lr到一个临时寄存器里,子函数调用完成之后恢复到lr
    //这里ret执行结束后, 它还能找到它的父函数
b_ret_cmd_test2:
    mov x6, x30
    mov x0, 1
    mov x1, 3//pc:0x80378
    bl csel_test//pc:0x8037c, lr(x30):0x802f0->执行完后变成0x80380
    mov x30, x6
    ret

// 但是不难发现, 如果一直用临时寄存器也是风险很高的方式
// 因为你无法确定该寄存器是否被父函数占用,随便拿过来用很可能造成污染！
//因此常规做法是把它们(x30-lr, x29-fp) 保存到内存中 —— 也就是栈
b_ret_cmd_test3:
    stp x29, x30, [sp, #-16]!
    mov x0, 1
    mov x1, 3//pc:0x80378
    bl csel_test//pc:0x8037c, lr(x30):0x802f0->执行完后变成0x80380
    ldp x29, x30, [sp], #16
    ret
