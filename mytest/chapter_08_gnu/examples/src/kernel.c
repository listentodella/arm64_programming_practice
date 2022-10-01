#include "uart.h"

extern void add_macro();

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    add_macro();

	while (1) {
		uart_send(uart_recv());
	}
}
