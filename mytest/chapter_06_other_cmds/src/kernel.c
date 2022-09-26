#include "uart.h"

extern void ldr_adr_adrp_test();

void kernel_main(void)
{
	uart_init();

    ldr_adr_adrp_test();
	uart_send_string("Welcome BenOS!\r\n");


	while (1) {
		uart_send(uart_recv());
	}
}
