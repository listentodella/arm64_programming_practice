#include "uart.h"

extern void get_max_asm();
extern unsigned long get_bigger_asm(unsigned long a, unsigned long b);
extern void c_call_me();

unsigned long get_bigger(unsigned long a, unsigned long b)
{
    return a > b ? a:b;
}

void kernel_main(void)
{
	uart_init();

    get_max_asm();
    get_bigger_asm(2, 3);

    c_call_me();

	uart_send_string("Welcome BenOS!\r\n");
	while (1) {
		uart_send(uart_recv());
	}
}
