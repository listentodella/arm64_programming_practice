#include "mm.h"

.section ".text.boot"

//.global _text_start
//.global _text_end

.global _start
_start:
	mrs	x0, mpidr_el1
	and	x0, x0,#0xFF		// 检查处理器核心ID
	cbz	x0, master		// 除了CPU0，其他CPU都会在这里死循环等待
	b	proc_hang

proc_hang:
	b 	proc_hang

master:
    //copy text section from LMA to VMA
    adr x0, TEXT_ROM
    adr x1, _text_start
    adr x2, _text_end
1:
    ldr x3, [x0], #8
    str x3, [x1], #8
    cmp x1, x2
    b.cc 1b


	adr	x0, bss_begin
	adr	x1, bss_end
	sub	x1, x1, x0
	bl 	memzero

	mov	sp, #LOW_MEMORY
	bl	kernel_main
	b 	proc_hang
