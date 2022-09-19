.global my_memset
.global my_memset2
.global __memset_16bytes


// x0 -> buffer
// x1 -> val
// x2 -> count
my_memset:
    mov x4, #0
loop1:
    // 将 x1 (val) 存储到 x0 对应的内存地址 buffer 中
    // 然后再将 x1 (val) 存储到  x0+8 对应的内存地址 buffer 中
    // 之后再给 x0 变址 +16 ,因为stp 正好 store 了 8+8=16字节的数据到内存里
    // 所以 +16 跳到下一格内存地址
    //stp x1, x1, [x0], #16
    stp x1, x1, [x0], #16
    // tmp counter
    add x4, x4, #16
    // 比较 已复制的字节数 和 需要复制的字节数
    // cmp x4, [x2]
    cmp x4, x2
    bcc loop1
    ret

my_memset2:
    str x1, [x0]
    ret

__memset_16bytes:
    mov x4, #0
loop3:
    stp x1, x1, [x0], #16
    add x4, x4, #16
    cmp x4, x2
    bne loop3
    ret
