#include "uart.h"

extern void cmn_cmd_test();
extern void csel_cmd_test();
extern void cset_cmd_test();
extern void csinc_cmd_test();

extern void b_ret_cmd_test();
extern void b_ret_cmd_test2();
extern void b_ret_cmd_test3();

void cmp_cmds_test()
{
    cmn_cmd_test();
    csel_cmd_test(1, 3);
    cset_cmd_test(2, 3);
    csinc_cmd_test(4, 6);
}

void kernel_main(void)
{
	uart_init();

    cmp_cmds_test();

    // b_ret_cmd_test();
    b_ret_cmd_test2();
    b_ret_cmd_test3();

	uart_send_string("Welcome BenOS!\r\n");

	while (1) {
		uart_send(uart_recv());
	}
}
