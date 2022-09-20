.global add_imm_test
.global add_reg_test
.global add_shift_test
.global adds_test
.global adc_test



add_imm_test:
    mov x0, #0
    mov x1, #0
    // x0 + 1 -> x0
    add x0, x0, #1
    // (1 << 12) + x1 -> x0
    add x0, x1, #1, LSL #12

    // 奇怪的是,手册 上写只支持 0~4095, 但是4096
    add x0, x1, #4096
    //add x0, x1, #4098
    // 必须是 0 或者 12
    //shift amount must be 0 or 12 at operand 3 -- `add x0,x1,#1,LSL#1'
    //add x0, x1, #1, LSL #1
    ret

add_reg_test:
    mov x0, #1
    mov x1, #2
    mov x2, #3
    add x0, x1, x2
    add x0, x1, x2, LSL #2
    //   不能混用 X 和 W
    //add x0, x1, w2, LSL #31
    //32bit:shift amount out of range 0 to 31 at operand 3
    //add w0, w1, w2, LSL #32
    //64bit:shift amount out of range 0 to 63 at operand 3
    // add x0, x1, x2, LSL #64

    mov x1, #1
    mov x2, #0x108A
    // 8位数据 无符号扩展,先对x2的低8bit 无符号扩展,然后用x1+这个数据
    add x0, x1, x2, UXTB
    // 8位数据 有符号扩展,先对x2的低8bit有符号扩展,然后用x1+这个数据
    add x0, x1, x2, SXTB

    ret

add_shift_test:
    add x0, x1, x2, LSL #3
    //64bit:shift amount out of range 0 to 63 at operand 3
    //add x0, x1, x2, LSL #64
    ret


adds_test:
    mov x1, #0xFFFFFFFFFFFFFFFF
    // 可以影响 NZCV
    adds x0, x1, #2
    mrs x2, nzcv
    ret

adc_test:
    mov x0, #0
    mov x1, #1
    mov x2, #2
    mrs x3, nzcv
    // 先清除当前PSTATE里的 nzcv
    msr nzcv, x0
    mrs x3, nzcv
    // 从结果来看 此时adc只是普通的 add 指令
    adc x0, x1, x2

    mov x1, #0xFFFFFFFFFFFFFFFF
    mov x2, #2
    // x0 = x1 + x2 + C
    // 从结果来看, adc 指令产生了溢出, 但是不能影响标志位
    // 因此 C = 0, adc 仍然等于 add
    adc x0, x1, x2
    // 回读 NZCV 确实也没有更新标志位
    mrs x3, nzcv
    // adcs 是 先执行 x0 = x1+x2+C,
    // 再根据结果决定是否更新标志位
    adcs x0, x1, x2
    // 检查 NZCV 会有更新
    mrs x3, nzcv
    // 再次执行, C已经是1了, 所以结果会有所不同
    adcs x0, x1, x2
    mrs x3, nzcv

    mov x1, #1
    mov x2, #2
    //从结果看,adc 只看当前的C位, 但这个C并不是由adc产生
    adc x0, x1, x2

    ret
