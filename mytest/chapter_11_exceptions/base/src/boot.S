#include "mm.h"
#include "sysregs.h"

//.global el_string
//el_string:
//    .string "Booting at EL"
#define label_test 0x20
my_data:
    .word 0x22

.section ".text.boot"

.global _start
_start:
    msr spsel, #1
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
    bl uart_init

    mrs x5, CurrentEL
    cmp x5, #CurrentEL_EL3
    b.eq el3_entry
    b el2_entry

el3_entry:
    bl get_current_el
    eret

el2_entry:
    bl get_current_el

    /* HCR_EL2 是虚拟化管理软件配置寄存器,用来配置EL2
     * RW字段用来控制低异常等级的执行状态
     * 0:EL0 和 EL1都在A32
     * 1:EL1为A64, EL0则会由 PSTATE.nRW来决定
     */
    //设置EL1为 AArch64
    ldr x0, =HCR_RW
    msr hcr_el2, x0

    /* SCTLR_EL1 是系统控制器寄存器
     * bit25->EE字段,用来设置EL1下数据访问的大小端
     * bit24->EOE字段,用来设置EL0下的数据访问的大小端
     * bit0 ->M字段,用来使能MMU
     */
    //关闭MMU
    ldr x0, =SCTLR_VALUE_MMU_DISABLED
    msr sctlr_el1, x0

    /*
     * SPSR_EL2 主要用来保存异常发生时的PSTATE寄存器
     * SPSR.M[3:0] 记录了返回哪个异常等级
     */
    // 关闭DAIF,并且异常返回时的执行等级为EL1h
    ldr x0, =SPSR_EL1
    msr spsr_el2, x0

    /*
     * ELR_EL2 主要用来保存异常返回的地址
     */
    adr x0, el1_entry
    msr elr_el2, x0
    /*
     * eret 指令使用当前异常等级的 ELR 和 SPSR
     * 执行后, PE从SPSR恢复PSTATE,以及ELR里保存的地址
     * 该命令对于EL0是 undefined
     */
    // 因此执行完eret后, 切换至 EL1
    eret

el1_entry:
	mov	sp, #LOW_MEMORY
    bl get_current_el


    /*
     * VBAR_ELx 寄存器,用来设置异常向量表的基地址
     * 早期的ARM处理器的异常向量表固定在0x0地址
     * 有了这个寄存器后可以自定义了, 只要这个异常向量表放在内存里即可
     */
    //设置异常向量表的基地址到vbar寄存器
    ldr x5, =vectors
    msr vbar_el1, x5
    //msr vbar_el2, x5
    isb


	bl	kernel_main
	b 	proc_hang

//.global print_el
//print_el:
//    stp x29, x30, [sp, #-16]!
//
//    ldp x29, x30, [sp], #16
//    ret

//.global print_el
//print_el:
//    stp x29, x30, [sp, #-16]!
//
//    ldp x29, x30, [sp], #16
//    ret
