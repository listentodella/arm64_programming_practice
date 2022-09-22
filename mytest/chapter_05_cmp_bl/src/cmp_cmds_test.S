.global cmn_cmd_test
.global csel_cmd_test
.global cset_cmd_test
.global csinc_cmd_test


.global cmn_lab_test
.global cmp_lab_test

cmn_cmd_test:
    mov x1, 2
    mov x2, -2
label1:
    //cmn:比较 op1 与 op2的相反数
    // cmn 等价于 adds(只是op1是零寄存器), 会影响 NZCV
    cmn x1, x2
    mov x1, 1
    b.eq label1
    ret

//x0 = param1, x1 = param2
csel_cmd_test:
    /*
        if a >= b
            return b+2
        else
            return b-1
     */
    //csel op1, op2, op3, <cond>
    // if cond == true, op1 = op2;else op1 = op3
    cmp x0, x1
    add x2, x1, #2
    sub x3, x1, #1
    //ge: unsigned >=
    csel x0, x2, x3, ge

    ret

/* cset op1, cond
 * if cond == true, op1 = 1; else op1 = 0
 */
cset_cmd_test:
    cmp x0, x1
    //if x0 > x1, return true;else return false
    //hi, unsigned >
    cset x0, hi

    ret

/* csinc op1, op2, op3, cond
 * if cond == true, op1 = op2; else op1 = op3+1
 */
csinc_cmd_test:
    cmp x0, x1
    // if x0 > x1, return x0;else return x1+1
    csinc x0, x0, x1, hi
    ret


cmn_lab_test:
    mrs x2, nzcv
    msr nzcv, xzr
    mrs x2, nzcv
loop:
    add x1, x1, #1
    cmn x0, x1
    mrs x2, nzcv
    b.mi loop

    ret

cmp_lab_test:
    mrs x2, nzcv
    msr nzcv, xzr
    mrs x2, nzcv
    b start
loop1:
    add x0, x0, 1
start:
    cmp x1, x0
    mrs x2, nzcv
    b.ge loop1

    ret
