#include "asm/pl_uart.h"
#include "asm/gpio.h"



.global init_pl_uart_asm
.global uart_send_asm
.global uart_send_string_asm


init_pl_uart_asm:
    stp x29, x30, [sp, #-16]!
    ldr x0, =GPFSEL1
    ldr w1, [x0]
    mov w1, wzr//clear GPFSEL1
    mov w2, #0b100
    bfi w1, w2, 12, 3//gpio14, alt0
    bfi w1, w2, 15, 3//gpio15, alt0
    str w1, [x0]

#ifdef CONFIG_BOARD_PI3B
    //gpio pin pull-up/down enable
    ldr x0, =GPPUD
    str wzr, [x0]
    //fake deley
    mov x0, #150
1:
    sub x0, x0, #1
    cmp x0, #0
    bne 1b

    ldr x0, =GPPUDCLK0
    ldr x1, =((1 << 14) | (1 << 15))
    str x1, [x0]

    mov x0, #150
2:
    sub x0, x0, #1
    cmp x0, #0
    bne 2b

    ldr x0, =GPPUDCLK0
    str wzr, [x0]

#else
#error "please implement rpi4"
#endif
    //disable uart until config done
    ldr x0, =U_CR_REG
    str wzr, [x0]

    ldr x0, =U_IBRD_REG
    ldr w1, =26
    str w1, [x0]

    // baud rate divisor, integer part
    ldr x0, =U_FBRD_REG
    ldr w1, =3
    str w1, [x0]

    // baud rate divisor, fractional part
    ldr x0, =U_LCRH_REG
    ldr w1, =((1 << 4) | (3 << 5))
    str w1, [x0]

    //enable FIFOs and 8bits frames
    ldr x0, =U_IMSC_REG
    str wzr, [x0]

    //enable uart, recv and transfer
    ldr x0, =U_CR_REG
    ldr w1, =((1 | (1 << 8) | (1 << 9)))

    ldp x29, x30, [sp], #16
    ret

uart_send_asm:
    stp x29, x30, [sp, #-16]!
wait_fifo_ready:
    ldr x0, =U_FR_REG
    ldr w1, [x0]
    ldr w2, =(1 << 5)
    ands w1, w1, w2
    b.ne wait_fifo_ready

    //write data to DR register
    ldr x0, =U_DATA_REG
    str w4, [x0]

    ldp x29, x30, [sp], #16
    ret


uart_send_string_asm:
    stp x29, x30, [sp, #-16]!
    mov x5, x0
loop:
    ldrb w4, [x5], #1
    bl uart_send_asm
    cmp w4, #0
    b.ne loop

    ldp x29, x30, [sp], #16
    ret
