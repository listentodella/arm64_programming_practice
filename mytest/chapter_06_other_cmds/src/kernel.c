#include "uart.h"

extern void ldr_adr_adrp_test();

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    ldr_adr_adrp_test();


	while (1) {
		uart_send(uart_recv());
	}
}
