#include "uart.h"

extern int my_atomic_write_asm(unsigned long val);
extern void atomic_set_asm(int nr, volatile unsigned long *addr);

int my_atomic_write(unsigned long val)
{

    my_atomic_write_asm(val);
    return 0;
}

void atomic_set(int nr, volatile unsigned long *addr)
{
    unsigned long mask = 1UL << nr;
    *addr |= mask;
}


void kernel_main(void)
{
	uart_init();

    my_atomic_write(0x34ul);

    int nr = 3;
    unsigned long val = 0x01ul;
    unsigned long *addr = &val;

    atomic_set(nr, addr);
    val = 0x01ul;
    atomic_set_asm(nr, addr);

	uart_send_string("Welcome BenOS!\r\n");

	while (1) {
		uart_send(uart_recv());
	}
}
