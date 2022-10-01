.macro add_data p1=0 p2
mov x5, \p1
mov x6, \p2
add x1, x5, x6
.endm

.macro add_test p1 p2
add x0, \p1, \p2
.endm

.macro add_data_2 p1:req p2
mov x5, \p1
mov x6, \p2
add x1, x5, x6
.endm




.global add_macro
add_macro:
    mov x2, #3
    mov x3, #4
    add_test x2, x3
    //add_test #1, #2
    add_data x2, x3
    add_data , x3
    add_data #6, #7
    //add_data_2 , 5//req修饰了p1,必须传参数
    add_data_2 5, 5

    ret
