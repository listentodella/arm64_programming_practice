#include "uart.h"

extern unsigned char get_el_state();


void kernel_main(void)
{
	uart_init();

    unsigned char el = get_el_state();
	uart_send_string("Booting at EL");
	uart_send(el + '0');
	uart_send_string("\r\n");

	uart_send_string("Welcome BenOS!\r\n");

	while (1) {
		uart_send(uart_recv());
	}
}
