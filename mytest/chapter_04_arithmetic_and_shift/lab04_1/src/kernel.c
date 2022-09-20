#include "uart.h"

extern void add_imm_test();
extern void add_reg_test();
extern void add_shift_test();
extern void adds_test();
extern void adc_test();

extern void sub_imm_test();
extern void sub_reg_test();
extern void sub_shift_test();

void add_cmd_test()
{
    add_imm_test();
    add_reg_test();
    add_shift_test();

    adds_test();
    adc_test();
}

void sub_cmd_test()
{
    sub_imm_test();
    sub_reg_test();
    sub_shift_test();
    subs_test();
}


void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    add_cmd_test();

    sub_cmd_test();


	while (1) {
		uart_send(uart_recv());
	}
}
