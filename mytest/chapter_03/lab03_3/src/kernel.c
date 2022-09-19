#include "uart.h"

extern void push_pop_stack();

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    push_pop_stack();

	while (1) {
		uart_send(uart_recv());
	}
}
