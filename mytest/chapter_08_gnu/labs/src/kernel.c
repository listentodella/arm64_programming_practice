#include "uart.h"

extern void get_max_asm();
extern void get_bigger_asm(unsigned long a, unsigned long b);

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    get_max_asm();
    get_bigger_asm(2, 3);

	while (1) {
		uart_send(uart_recv());
	}
}
