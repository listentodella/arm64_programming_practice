#include "uart.h"

typedef unsigned int size_t;

// extern my_memset(void *s, int c, size_t count);
extern void my_memset(void *s, int c, unsigned int count);
extern void my_memset2(void *s, int c, unsigned int count);
// 注意 c 的数据类型, 如果不对, 传递后会被裁剪
// extern void *__memset_16bytes(void *s, int c, size_t count);
extern void *__memset_16bytes(void *s, unsigned long c, unsigned long count);

void *__memset_1bytes(void *s, int c, size_t count)
{
    char *xs = s;

    while (count--) {
        *xs++ = c;
    }

    return s;
}

void *my_memset3(void *s, int c, unsigned int count)
{
    char *p = s;
    unsigned long align = 16;
    size_t size, left_bytes = count;
    int n = 0, i = 0;
    unsigned long addr = (unsigned long)p;
    unsigned long data = 0ull;

    /* 这里 c必须转换成 unsigned long 类型, 因为c变量是int类型 4Bytes
     * 这个循环走完, 构造出一个 data: 0x7777 7777 7777 7777
    */
    for (i = 0; i < 8; i++) {
        data |= (((unsigned long)c) & 0xFF) << (i * 8);
    }

    /* 检查起始地址是否16字节对齐 */
    /* 在 rpi3 中, 内存分配是以 128bits -> 16 字节 为一大组的, 例如：
     * 0x200000 0x200004 | 0x200008 0x200000C
     * 0x200010 0x200014 | 0x200018 0x200001C
     * ...
     *
     * 所以这里用检查是否16字节对齐, 就是检查内存起始地址是否是每一组的开头
     * 那么我们检查最后4个bit,即16进制的最后一个数字是否为0即可
     * 若是0, 则属于16字节对齐, 否则不属于
     * 在非16字节对齐的情况下, 与运算得出的数字, 就是该地址与其起始地址的偏移量
     * 使用 16 - offset, 得到的就是 非16字节对齐的 头 字节数
    */
    if (addr & (align - 1)) {
        size = align - addr & (align - 1);
        __memset_1bytes(p, c, size);
        p = p + size;
        left_bytes = count - size;
    }

    /* align 16 bytes */
    if (left_bytes > align) {
        n = left_bytes / align;
        // 这里可以得到 非16字节对齐的 尾字节数
        left_bytes = left_bytes % align;

        __memset_16bytes(p, data, 16*n);

        if (left_bytes) {
            __memset_1bytes(p + 16*n, c, left_bytes);
        }
    }

    return s;
}



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
     * 从这里的实验也能够看出, stp ldp 命令,不用变种的话每次最少要操作64bit
     * 无法细分操作到一个字节,即便刻意改变内存地址,也会因为一次完整操作64bit而覆盖掉某些值
    */
    // my_memset(buffer, 0x55, 32);

    /* 这种方式 set 的数据, 虽然 Xn/Wn 寄存器远大于一个字节
     * 操作下来并不是一个字节一个字节的set, 但是每次循环都更新了新的地址
     * 而且用的不是 stp 指令 而是 str 指令
     * 0x6666 6666 6666 6666 0xFFFF FFFF FFFF FFFF
     * ...
    */
        // 不应该用for循环切换地址,那样的话这里的memset失去通用性
        my_memset2(buffer, 0x66, 8);


    /* 从上面的实验可以看出,
     * stp ldp 可以用更少的指令/执行次数操作更多的内存, 但是它不能"细分"
     * str ldr 可以细分操作, 但某些场合需要更多的指令/执行次数
     * 因此想要实现真正的 memset , 需要结合二者
     */
    // my_memset3(buffer, 0x77, 102);
    // 这个起始地址是16字节对齐的
    // my_memset3(0x200000, 0x99, 102);
    // 这个起始地址非16字节对齐的
    my_memset3(0x200004, 0x77, 102);
    // my_memset3(0x200008, 0x77, 102);

}


void kernel_main(void)
{
	uart_init();
	("Welcome BenOS!\r\n");

    my_memset_test();

	while (1) {
		uart_send(uart_recv());
	}
}
