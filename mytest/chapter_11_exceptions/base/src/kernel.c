#include "uart.h"

/*
 * 带参数的宏, # 符号会作为一个预处理运算符, 把记号转换成字符串
 * 因此在预编译阶段, 下面这句话会预编译为:
 * asm volatile("mrs %0 ", "reg" : "=r"(_val));
*/
#define read_sysreg(reg) ({ \
    unsigned long _val; \
    asm volatile ( \
        "mrs %0, " #reg \
        :"=r"(_val) \
    ); \
    _val; \
})

#define write_sysreg(reg, val) ({ \
    unsigned long _val = (unsigned long)val; \
    asm volatile ( \
        "msr " #reg ", %0" \
        : \
        ："rZ"(_val) \
    ); \
})

static const char * bad_mode_handler[] = {
    "Sync Abort",
    "IRQ",
    "FIQ",
    "SError"
};

void bad_mode(struct pt_regs *regs, int reason, unsigned int esr)
{
    printk("Bad mode for %s handler dectected, far = 0x%x, esr = 0x%x\n",
           bad_mode_handler[reason], read_sysreg(far_el1), esr);
}

static void test_sysregs(void)
{
    unsigned long el = read_sysreg(CurrentEL);
    printk("CurrentEL = %d\n", el >> 2);
}



void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    test_sysregs();

	while (1) {
		uart_send(uart_recv());
	}
}
