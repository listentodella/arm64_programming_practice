#define BAD_SYNC     (0)
#define BAD_IRQ      (1)
#define BAD_FIQ      (2)
#define BAD_ERROR    (3)


// 处理无效的异常向量
.macro inv_entry el, reason
    mov x0, sp
    mov x1, #\reason
    //ESR_ELx 异常综合信息寄存器, Exception Syndrome Register
    //[63:32] - reserved
    //[31:26] - EC段,异常类型
    //[25]    - IL段,同步异常的指令长度
    //[24:0]  - ISS段,具体的异常指令综合编码信息
    mrs x2, esr_el1
    //x0,x1,x2在这里只是 bad_mode函数的3个参数而已,不属于"保存中断现场"
    b bad_mode
.endm

/*
 * vector table entry
 * 每个表项是128字节, align 7 即为 2^7
 */
.macro vtentry label
    .align 7
    b \label
.endm

/*
 * Vector Table
 * ARM64的异常向量表一共占2048字节
 * 分为4组, 每组4个表项, 每个表项128字节
 * 参考ARMv8 spec v8.6 - D1.10节
 * align 11 表示 2048字节对齐
 */
.align 11
.global vectors
vectors:
    /*
     * CurrentEL with SP0
     * 当前系统运行在EL1时, 使用 EL0的栈指针SP
     */
    vtentry el1_sync_invalid
    vtentry el1_irq_invalid
    vtentry el1_fiq_invalid
    vtentry el1_error_invalid

    /*
     * CurrentEL with SPx
     * 当前系统运行在EL1时, 使用 EL1的栈指针SP
     * 说明系统在内核态发生了异常
     * NOTE: 暂时只实现了IRQ中断
     */
    vtentry el1_sync_invalid
    vtentry el1_irq_invalid
    vtentry el1_fiq_invalid
    vtentry el1_error_invalid

    /*
     * Lower EL using AArch64
     * 在用户态的 aarch64 程序发生了异常
     */
    vtentry el0_sync_invalid
    vtentry el0_irq_invalid
    vtentry el0_fiq_invalid
    vtentry el0_error_invalid

    /*
     * Lower EL using AArch32
     * 在用户态的 aarch32 程序发生了异常
     */
    vtentry el0_sync_invalid
    vtentry el0_irq_invalid
    vtentry el0_fiq_invalid
    vtentry el0_error_invalid


el1_sync_invalid:
    inv_entry 1, BAD_SYNC
el1_irq_invalid:
    inv_entry 1, BAD_IRQ
el1_fiq_invalid:
    inv_entry 1, BAD_FIQ
el1_error_invalid:
    inv_entry 1, BAD_ERROR

el0_sync_invalid:
    inv_entry 0, BAD_SYNC
el0_irq_invalid:
    inv_entry 0, BAD_IRQ
el0_fiq_invalid:
    inv_entry 0, BAD_FIQ
el0_error_invalid:
    inv_entry 0, BAD_ERROR

.global string_test
string_test:
    .string "t"

.global trigger_alignment
trigger_alignment:
    ldr x0, =0x80002
    ldr x1, [x0]
    ret
