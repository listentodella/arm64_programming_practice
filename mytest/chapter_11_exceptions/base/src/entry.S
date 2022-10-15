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
    b bad_mode
.endm


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
