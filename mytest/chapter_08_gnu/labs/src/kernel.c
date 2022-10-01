#include "uart.h"
extern unsigned long add_1(unsigned long a, unsigned long b);
extern unsigned long add_2(unsigned long a, unsigned long b);
extern void add_macro_test(unsigned long a, unsigned long b);
extern void get_max_asm();
extern unsigned long get_bigger_asm(unsigned long a, unsigned long b);
extern void c_call_me();


extern unsigned long my_kallsyms_cnt;
extern unsigned long my_kallsyms_addr[];
extern char my_kallsyms_string[];

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

/*
“.data”节的十六进制输出：
  0x00080608 00088000 00000000 60088000 00000000 ........`.......
  0x00080618 80088000 00000000 66756e63 5f610066 ........func_a.f
  0x00080628 756e635f 62006675 6e635f63 00000000 unc_b.func_c....
  0x00080638 03000000 00000000 0a000000 00000000 ................
  0x00080648 0b000000 00000000 0c000000 00000000 ................
  0x00080658 0d000000 00000000 04000000 00000000 ................

*/

    //p = my_kallsyms_string[i];
    p = &my_kallsyms_string;

    if (i == 0) {
        string = p;
        goto done;
    }

    while (1) {
        p++;
        if (*p == '\0') {
            i--;
        }
        if (i == 0) {
            p++;
            string = p;
            break;
        }
    }

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

    add_macro_test(1, 1);
    add_macro_test(2, 2);

	uart_send_string("Welcome BenOS!\r\n");
	while (1) {
		uart_send(uart_recv());
	}
}
