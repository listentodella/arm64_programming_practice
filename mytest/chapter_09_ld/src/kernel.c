#include "uart.h"

extern char _text_boot_start[], _text_boot_end[];
extern char _text_start[], _text_end[];
extern char _rodata_start[], _rodata_end[];
extern char _data_start[], _data_end[];
extern char bss_begin[], bss_end[];


void print_mem_layout()
{
    printk("BenOS image layout:\n");
    printk("    .text.boot: 0x%08x - 0x%08x (%6ld B)\n",
           (unsigned long)_text_boot_start,
           (unsigned long)_text_boot_end,
           (unsigned long)(_text_boot_end - _text_boot_start));
    printk("         .text: 0x%08x - 0x%08x (%6ld B)\n",
           (unsigned long)_text_start,
           (unsigned long)_text_end,
           (unsigned long)(_text_end - _text_start));
    printk("       .rodata: 0x%08x - 0x%08x (%6ld B)\n",
           (unsigned long)_rodata_start,
           (unsigned long)_rodata_end,
           (unsigned long)(_rodata_end - _rodata_start));
    printk("         .data: 0x%08x - 0x%08x (%6ld B)\n",
           (unsigned long)_data_start,
           (unsigned long)_data_end,
           (unsigned long)(_data_end - _data_start));
    printk("          .bss: 0x%08x - 0x%08x (%6ld B)\n",
           (unsigned long)bss_begin,
           (unsigned long)bss_end,
           (unsigned long)(bss_end - bss_begin));
}


void kernel_main(void)
{
	uart_init();
    print_mem_layout();
	uart_send_string("Welcome BenOS!\r\n");

	while (1) {
		uart_send(uart_recv());
	}
}
