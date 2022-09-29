#include "asm/pl_uart.h"
#include "asm/gpio.h"
#include "io.h"

void uart_send(char c)
{
	/* wait for transmit FIFO to have an available slot*/
    //3b datasheet, p181 FR register
	while (readl(U_FR_REG) & (1<<5))
		;

    //3b datasheet, p178 DR register
	writel(c, U_DATA_REG);
}

char uart_recv(void)
{
	/* wait for receive FIFO to have data to read */
	while (readl(U_FR_REG) & (1<<4))
		;

	return(readl(U_DATA_REG) & 0xFF);
}

void uart_send_string(char *str)
{
	int i;

	for (i = 0; str[i] != '\0'; i++)
		uart_send((char) str[i]);
}

void uart_init(void)
{
	unsigned int selector;
    /* 参考 bcm datasheet, 例如bcm2837->rpi3b
     * 3b 的gpio,功能选择的寄存器共有6组, 每组32bit
     * 每3bit对应一个gpio
     *  FSELxx - Function Select xx
        000 = GPIO Pin xx is an input
        001 = GPIO Pin xx is an output
        100 = GPIO Pin xx takes alternate function 0
        101 = GPIO Pin xx takes alternate function 1
        110 = GPIO Pin xx takes alternate function 2
        111 = GPIO Pin xx takes alternate function 3
        011 = GPIO Pin xx takes alternate function 4
        010 = GPIO Pin xx takes alternate function 5
     */
    /* pl uart 为 gpio14,15, 功能寄存器隶属于 FSEL1
     * 12~14 为 gpio14, 15~17为 gpio15
     * uart 功能为 function0, 因此写 0b100
    */
	/* clean gpio14 */
	selector = readl(GPFSEL1);
	selector &= ~(7<<12);
	/* set alt0 for gpio14 */
	selector |= 4<<12;
	/* clean gpio15 */
	selector &= ~(7<<15);
	/* set alt0 for gpio15 */
	selector |= 4<<15;
	writel(selector, GPFSEL1);

#ifdef CONFIG_BOARD_PI3B
	writel(0, GPPUD);//GPIO Pin Pull-up/down Enable
	delay(150);
	writel((1<<14) | (1<<15), GPPUDCLK0);//GPIO Pin Pull-up/down Enable Clock 0
	delay(150);
	writel(0, GPPUDCLK0);
#else
	/*set gpio14/15 pull down state*/
	selector = readl(GPIO_PUP_PDN_CNTRL_REG0);
	selector |= (0x2 << 30) | (0x2 << 28);
	writel(selector, GPIO_PUP_PDN_CNTRL_REG0);
#endif
    //3b datasheet p117
	/* disable UART until configuration is done */
	writel(0, U_CR_REG);

	/*
	 * baud divisor = UARTCLK / (16 * baud_rate)
	= 48 * 10^6 / (16 * 115200) = 26.0416666667
	integer part = 26
	fractional part = (int) ((0.0416666667 * 64) + 0.5) = 3
	generated baud rate divisor = 26 + (3 / 64) = 26.046875
	generated baud rate = (48 * 10^6) / (16 * 26.046875) = 115177
	error = |(115177 - 115200) / 115200 * 100| = 0.02%
	*/

	/* baud rate divisor, integer part */
	writel(26, U_IBRD_REG);
	/* baud rate divisor, fractional part */
	writel(3, U_FBRD_REG);

	/* enable FIFOs and 8 bits frames */
	writel((1<<4) | (3<<5), U_LCRH_REG);

	/* mask interupts */
	writel(0, U_IMSC_REG);
	/* enable UART, receive and transmit */
	writel(1 | (1<<8) | (1<<9), U_CR_REG);
}
