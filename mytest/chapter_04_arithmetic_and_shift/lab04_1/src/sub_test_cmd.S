.global sub_imm_test
.global sub_reg_test
.global sub_shift_test
.global subs_test


sub_imm_test:
    mov x0, #0
    mov x1, #11
    mov x2, #12
    //x0 = x1 - 3
    sub x0, x1, #3
    //x0 = x1 - (1 << 0)
    sub x0, x1, #1, LSL #0

    // 奇怪的是,手册 上写只支持 0~4095, 但是4096
    // x0 = x1 - 4096
    sub x0, x1, #4096
    //sub x0, x1, #4097
    // 必须是 0 或者 12
    //shift amount must be 0 or 12 at operand 3 -- `add x0,x1,#1,LSL#1'
    //sub x0, x1, #1, LSL #1
    ret

sub_reg_test:
    mov x1, #1
    mov x2, #0x018A
    sub x0, x1, x2
    sub x0, x1, x2, LSL #2
    //32bit:shift amount out of range 0 to 31 at operand 3
    //sub w0, w1, w2, LSL #31
    //64bit:shift amount out of range 0 to 63 at operand 3
    //sub x0, x1, x2, LSL #64

    //先取x2低8位进行无符号扩展得到x2',然后x0 = x1 - x2'
    sub x0, x1, x2, UXTB
    //先取x2低8位进行有符号扩展得到x2',然后x0 = x1 - x2'
    sub x0, x1, x2, SXTB

    ret

sub_shift_test:
    //x0 = x1 - (x2<<4)
    sub x0, x1, x2, LSL #4
    //64bit:shift amount out of range 0 to 63 at operand 3
    //sub x0, x1, x2, LSL #64

    ret

/*
 * subs 可以影响 NZCV 的状态,但是它的影响逻辑比较特别
 * 它的计算公式是: op1 + NOT(op2) + 1, NOT是指对其按位取反
 * 当结果发生无符号数溢出时, C = 1
 * 当结果为负数时, N = 1
 *
 * 这就可以造成：
 * 两个都是正数/负数情况下:
 * 大数 - 小数 ==>  C = 1
 * 小数 - 大数 ==>  N = 1
 * 两数相等时  ==>  C = 1, Z = 1
 * 正负混合:
 * 正 - 负    ==> 不影响NZCV
 * 负 - 正    ==> N = 1, C = 1

 * 其实以上的结论也不完全正确......因为没考虑到数字可能造成溢出的情况
 * 最准确的结果,还是得依靠该公式得出
 */
subs_test:
// 正：大 - 小
    mov x0, #0
    mov x1, #3
    mov x2, #1
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv

// 正：两数相等
    //清除当前 nzcv 状态并回读确认
    mov x0, #0
    msr nzcv, x0
    mrs x3, nzcv

    mov x1, #3
    mov x2, #3
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv
// 正：小 - 大
    mov x0, #0
    mov x1, #1
    mov x2, #3
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv

// 负：大 - 小
    mov x0, #0
    mov x1, #-1
    mov x2, #-3
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv

// 负：相等
    mov x0, #0
    mov x1, #-3
    mov x2, #-3
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv
// 负：小 - 大
    mov x0, #0
    mov x1, #-3
    mov x2, #-1
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv

// 正负混合: 正-负、负-正
    mov x0, #0
    mov x1, #1
    mov x2, #-1
    //清除当前 nzcv 状态并回读确认
    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x1, x2
    mrs x3, nzcv

    msr nzcv, x0
    mrs x3, nzcv
    //x0 = x1 - x2
    subs x0, x2, x1
    mrs x3, nzcv

    ret
