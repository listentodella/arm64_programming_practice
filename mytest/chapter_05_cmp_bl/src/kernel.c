#include "uart.h"

extern void cmn_cmd_test();
extern void csel_cmd_test();
extern void cset_cmd_test();

void cmp_cmds_test()
{
    cmn_cmd_test();
    csel_cmd_test(1, 3);
    cset_cmd_test(2, 3);
}

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    cmp_cmds_test();


	while (1) {
		uart_send(uart_recv());
	}
}
