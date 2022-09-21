#include "uart.h"

extern unsigned long compare_and_return_asm();
extern void bit_fields_test();

unsigned long compare_and_return(unsigned long a, unsigned long b)
{
    if (a >= b) {
        return 0;
    } else {
        return 0xFFFFFFFFFFFFFFFF;
    }
}

void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    compare_and_return(6ull, 7ull);//return 0xFFF..FF
    compare_and_return_asm(6ull, 7ull);//return 0

    compare_and_return(7ull, 6ull);
    compare_and_return_asm(7ull, 6ull);

    bit_fields_test();


	while (1) {
		uart_send(uart_recv());
	}
}
