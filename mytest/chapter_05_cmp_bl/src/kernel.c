#include "uart.h"

extern void cmn_cmd_test();
extern void csel_cmd_test();
extern void cset_cmd_test();
extern void csinc_cmd_test();
// 参数数据类型非常重要！如果填的不对或不合适、或者没填
//那么最终传到寄存器里的值是会被裁剪的,位数不足,可能会进行无符号扩展
//那么不仅会影响最终的计算结果，PSTATE受到的影响也不会按照预期进行！
extern void cmn_lab_test(int long a, int long b);
extern void cmp_lab_test(int long a, int long b);

extern void b_ret_cmd_test();
extern void b_ret_cmd_test2();
extern void b_ret_cmd_test3();

extern void bl_lab_test();

extern unsigned long csel_test_asm(unsigned long a, unsigned long b);

void cmp_cmds_test()
{
    cmn_cmd_test();
    csel_cmd_test(1, 3);
    cset_cmd_test(2, 3);
    csinc_cmd_test(4, 6);

    cmn_lab_test(1, -3);
    cmp_lab_test(1, 3);

}

unsigned long csel_lab_test(unsigned long a, unsigned long b)
{
    if (a == 0) {
        return b + 2;
    } else {
        return b - 1;
    }
}

void cond_sel_test()
{
    csel_lab_test(0, 3);
    csel_test_asm(0, 3);

    csel_lab_test(1, 3);
    csel_test_asm(1, 3);

}



void kernel_main(void)
{
	uart_init();

    cmp_cmds_test();

    // b_ret_cmd_test();
    b_ret_cmd_test2();
    b_ret_cmd_test3();

    cond_sel_test();

    bl_lab_test();

	uart_send_string("Welcome BenOS!\r\n");

	while (1) {
		uart_send(uart_recv());
	}
}
