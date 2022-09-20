.global sub_imm_test
.global sub_reg_test
.global sub_shift_test


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
