#include "uart.h"

extern void ldr_cmd_test();

void my_ldr_str_cmd_test()
{
    // ldr cmd test
    ldr_cmd_test();
}

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    //my test
    my_ldr_str_cmd_test();

	while (1) {
		uart_send(uart_recv());
	}
}
