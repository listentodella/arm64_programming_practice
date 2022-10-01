//如果不声明段,尽管编译后它们属于.data段,但是并不会按照下面的对齐方式
.section .data
.align 5, 0, 100

my_data0:
    .byte  0x00//8bit
my_data1:
    .hword 0x1111//16bit
my_data2:
    .short 0x2222//16bit
my_data3:
    .long  0x33333333//32bit
my_data4:
    .int   0x44444444//32bit
my_data5:
    .word  0x55555555//32bit
my_data6:
    .quad  0x6666666666666666//64bit
my_data7:
    .float 3.14159265
my_data8:
    .string "hello world"
my_data9:
    //.ascii "hello world\0"//需要手动加'\0',否则会有以下结果
    .ascii "hello world"//需要手动加'\0',否则会有以下结果
my_data10:
    .asciz "hello world"//它会自动加'\0'
/*
╰─ aarch64-linux-gnu-readelf  data_type_s.o -p .data
String dump of section '.data':
[    1b]  I@hello world
[    29]  hello worldhello world

aarch64-linux-gnu-readelf data_type_s.o -x .data
“.data”节的十六进制输出：
0x00000000 00111122 22333333 33444444 44555555 ...""3333DDDDUUU
0x00000010 55666666 66666666 66db0f49 4068656c Uffffffff..I@hel
0x00000020 6c6f2077 6f726c64 0068656c 6c6f2077 lo world.hello w
0x00000030 6f726c64 68656c6c 6f20776f 726c6400 orldhello world.
0x00000040 cdab0000 cdab0000 cdab0000 cdab0000 ................
 */
my_data11://必须成对出现,rept ... endr 之间的操作会执行N次
    .rept 4
    .long 0xABCD
    .endr

//看似和直接定义一个symbol相同,实际还是略有不同
//如果没有其他命令调用它们,readelf命令会发现它们并没有被放到 .data 段
.equ my_data12, 0xFFFF
.equ my_data13, 0xAAAA

//.global fun
//fun:
//    ldr x0, =my_data12
//    ldr x1, =my_data13
