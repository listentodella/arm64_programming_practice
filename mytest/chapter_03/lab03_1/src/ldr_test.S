#define label_test 0x30

.global string1
string1:
    .string "Boot at EL"

.align 3
.global my_data
my_data:
    .word 0x44

.align 3
.global access_label_test
access_label_test:
    /* 1. 加载一个很大的数 */
    ldr x1, =0xffff0000ffff0000

    /* 2. 初始化寄存器的值, 位操作 */
    ldr x2, =(1 << 0) | (1 << 2) | (1 << 20) | (1 << 40) | (1 << 55)
    // 编译器会报错, 不是所有数都可以作为立即数给mov指令操作
    //mov x2, (1 << 0) | (1 << 2) | (1 << 20) | (1 << 40) | (1 << 55)

    /* 3. 访问一个宏定义 */
    ldr x0, =label_test
    ldr x1, label_test

    /* 4. 访问一个字符串 */
    ldr x0, string1
    ldr x1, =string1

    /* 5. 访问一个 data */
    ldr x0, my_data
    ldr x1, =my_data

    ret
