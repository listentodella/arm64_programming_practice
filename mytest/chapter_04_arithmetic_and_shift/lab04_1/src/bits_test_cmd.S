.global bit_cmd_test
.global bit_field_test

bit_cmd_test:
    mov x1, #0x3
    mov x2, xzr
    msr nzcv, xzr
    mrs x0, nzcv
    // 与and指令相同,只是 ands 可以影响 NZCV
    // 与add那些一样, 第三个操作数可以是立即数,也可以是寄存器{,shift amount}
    // amount 受 寄存器大小影响,w->0~31, x->0~63
    ands x3, x1, x2
    mrs x0, nzcv

    orr x3, x1, x2

    mov x1, #0b10100001
    mov x2, #0b00000110
    // 相同取0，相异取1
    eor x0, x1, x2
    // 异或自己等于设置目标寄存器为0
    eor x0, x1, x1
    //eor x1, x1, x1

    // 交换两个数
    eor x1, x1, x2
    eor x2, x1, x2
    eor x1, x1, x2

    //bic, 位清除操作
    // 第三操作数哪些位是1, 那么第二操作数里的内容对应位就被清零
    // 然后设置到目标寄存器里
    ldr x1, =0xFFFF
    ldr x2, =0x01
    bic x0, x1, x2
    bic x0, x1, x2, lsl #1

    ldr x2, =0x03
    bic x0, x1, x2

    //clz 指令
    //计算出 第一个bit为1的前面有多少个0
    ldr x1, =0x080000000000000F
    clz x0, x1

    ret

bit_field_test:
    //bfi <xd>, <xn>, #<lsb>, #<width>
    // <xn>[0, width-1] -> <xd>[lsb, lsb+width]
    /*
     * val &=~(0xF << 4)
     * val |= ((u64)0x05 << 4)
     * 将 某个寄存器 A 的 bit[7,4]设置 为 0x5
     */
    mov x0, xzr
    mov x1, #0xF
    //用 x1[0, 3] 替换 x0[4, 7]
    bfi x0, x1, #4, #4
    // x1[0, 2] -> x0[4, 6]
    mov x0, xzr
    bfi x0, x1, #4, #3
    // #lsb 和 #width 的取值范围是, 合计不能超出64bit
    mov x0, xzr
    //bfi x0, x1, #0, #65
    //bfi x0, x1, #64, #1
    bfi x0, x1, #62, #2

    //ubfx/sbfx <xd>, <xn>, #<lsb>, #<width>
    //ubfx sbfx(有符号扩展) 提取
    // 提取 <xn>[lsb, lsb+width-1] 到 <xd>[0, width-1]
    mov x2, #0x8a //0b 1000 1010
    ubfx x0, x2, #4, #4// 0b 0000 ... 0000 1000
    sbfx x0, x2, #4, #4// 0b 1111 ... 1111 1000

    // 提取 pmcr_el0 的 N字段(bit[11~15], 共5bits)
    mrs x1, pmcr_el0
    ubfx x0, x1, #11, #5

    ret
