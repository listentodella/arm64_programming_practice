#include "uart.h"

static inline unsigned long arch_local_irq_save(void)
{
    unsigned long flags = 0;
    asm volatile(
        "mrs %0, daif\n"//read PSTATE.DAIF
        "msr daifset, #2"//disable irq
        : "=r"(flags)
        :
        : "memory"
    );

    return flags;
}

// atomic add val to p
void my_atomic_add(unsigned long val, void *p)
{
    int ret = 0;
    unsigned long tmp = 0;
    asm volatile(
        "1:ldxr %0, [%2]\n"
        "add %0, %0, %3\n"
        "stxr %w1, %0, [%2]\n"
        "cbnz %w1, 1b\n"
        : "+r"(tmp), "+r"(ret)
        : "r"(p), "r"(val)
        : "cc", "memory"
    );
}

// atomic add val to p
void my_atomic_addQ(unsigned long val, void *p)
{
    int ret = 0;
    unsigned long tmp = 0;
    asm volatile(
        "1:ldxr %0, %2\n"
        "add %0, %0, %3\n"
        "stxr %w1, %0, %2\n"
        "cbnz %w1, 1b\n"
        : "+r"(tmp), "+r"(ret), "+Q"(*(unsigned long*)p)
        : "r"(val)
        : "cc"
    );
}


int add(int i, int j)
{
    int ret = 0;

    asm volatile(
        "add %w[result], %w[input_i], %w[input_j]\n"
        :[result] "=r"(ret)
        :[input_i] "r"(i), [input_j]"r"(j)
    );

    return ret;
}


static int test_asm_goto(int a)
{
    asm goto (
        "cmp %w0, 1\n"
        "b.eq %l[test_label]\n"//注意是l不是1
        ://goto时输出部分必须为空
        : "r"(a)
        : "memory"
        : test_label
    );

    return 0;
test_label:
    return 1;
}

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    arch_local_irq_save();

    unsigned long val0 = 10;
    unsigned long val1 = 12;
    unsigned long *p = &val1;
    my_atomic_add(val0, p);
    my_atomic_addQ(val0, p);

    add(val0, val1);

    test_asm_goto(1);


	while (1) {
		uart_send(uart_recv());
	}
}
