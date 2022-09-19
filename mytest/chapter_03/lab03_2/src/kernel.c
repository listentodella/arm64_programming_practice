#include "uart.h"

// extern my_memset(void *s, int c, size_t count);
extern void my_memset(void *s, int c, unsigned int count);
extern void my_memset2(void *s, int c, unsigned int count);


void my_memset_test()
{
    unsigned char buffer[16] = {0x00};
    for (int i = 0; i < 16; i++) {
        buffer[i] = 0xFF;
    }
    /* bufferr -> x0
    *  0x55 -> x1
    *  16 -> x2
    */
    /* 这种方式 set 的数据, 由于 Xn/Wn 寄存器远大于一个字节
     * 操作下来并不是一个字节一个字节的set, 结果为
     * 0x5500 0000 0000 0000 0x5500 0000 0000 0000
     * 0x5500 0000 0000 0000 0x5500 0000 0000 0000
     * ...
    */
    // my_memset(buffer, 0x55, 32);

    /* 这种方式 set 的数据, 虽然 Xn/Wn 寄存器远大于一个字节
     * 操作下来并不是一个字节一个字节的set, 但是每次循环都更新了新的地址
     * 而且用的不是 stp 指令 而是 str 指令
     * 0x6666 6666 6666 6666 0xFFFF FFFF FFFF FFFF
     * ...
    */
    for (int i = 0; i < 8; i++) {
        my_memset2(&buffer[i], 0x66, 1);
    }

}


void kernel_main(void)
{
	uart_init();
	uart_send_string("Welcome BenOS!\r\n");

    my_memset_test();

	while (1) {
		uart_send(uart_recv());
	}
}
