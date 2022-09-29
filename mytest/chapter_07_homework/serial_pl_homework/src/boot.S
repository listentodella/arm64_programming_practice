#include "mm.h"


.global el_string
el_string:
    .string "BOOTING at EL"


.section ".text.boot"

.globl _start
_start:
	mrs	x0, mpidr_el1
	and	x0, x0,#0xFF		// 检查处理器核心ID
	cbz	x0, master		// 除了CPU0，其他CPU都会在这里死循环等待
	b	proc_hang

proc_hang:
	b 	proc_hang

master:
	adr	x0, bss_begin
	adr	x1, bss_end
	sub	x1, x1, x0
	bl 	memzero

	mov	sp, #LOW_MEMORY

    bl init_pl_uart_asm
    bl print_el

	bl	kernel_main
	b 	proc_hang

print_el:
    stp x29, x30, [sp, #-16]!
    adrp x0, el_string
    add x0, x0, :lo12:el_string
    bl uart_send_string_asm

    bl get_el_state
    mov w4, w0
    mov w1, '0'
    add w4, w1, w4
    bl uart_send_asm
    mov w4, '\n'
    bl uart_send_asm

    ldp x29, x30, [sp], #16
    ret
