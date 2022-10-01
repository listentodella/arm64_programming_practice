#include "uart.h"

extern void get_max_asm();
extern unsigned long get_bigger_asm(unsigned long a, unsigned long b);
extern void c_call_me();


extern unsigned long my_kallsyms_cnt;
extern unsigned long my_kallsyms_addr[];
extern char* my_kallsyms_string[];

unsigned long get_bigger(unsigned long a, unsigned long b)
{
    return a > b ? a:b;
}

void print_func_name(unsigned long addr)
{
    int i = 0;
    char *p, *string;
    for (i = 0; i < my_kallsyms_cnt; i++) {
        if (addr == my_kallsyms_addr[i]) {
            goto found;
        }
    }

    goto out;

found:

    p = my_kallsyms_string;
    if (i == 0) {
        string = p;
        goto done;
    }

    while (*p != '\0') {
        p--;
    }
    string = p;

done:

    uart_send_string(string);
    uart_send('\n');


out:
    return;
}

void kernel_main(void)
{
	uart_init();

    get_max_asm();
    get_bigger_asm(2, 3);

    c_call_me();

    for (int i = 0; i < my_kallsyms_cnt; i++) {
        print_func_name(my_kallsyms_addr[i]);
    }
        // print_func_name(0x800880);
        // print_func_name(0x800860);
        // print_func_name(0x800800);

	uart_send_string("Welcome BenOS!\r\n");
	while (1) {
		uart_send(uart_recv());
	}
}
