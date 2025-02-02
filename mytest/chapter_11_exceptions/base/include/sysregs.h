// EL1 下为 AArch64 状态
#define HCR_RW  (1 << 31)

//EL1下为小端
#define SCTLR_EE_LITTLE_ENDIAN  (0 << 25)
//EL0下为小端
#define SCTLR_EOE_LITTLE_ENDIAN (0 << 24)

#define SCTLR_MMU_DISABLED      (0 << 0)

#define SCTLR_VALUE_MMU_DISABLED (SCTLR_MMU_DISABLED | SCTLR_EE_LITTLE_ENDIAN | SCTLR_EOE_LITTLE_ENDIAN)

#define SPSR_MASK_ALL   (7 << 6)
#define SPSR_EL1h       (5 << 0)
#define SPSR_EL2h       (9 << 0)
#define SPSR_EL1        (SPSR_MASK_ALL | SPSR_EL1h)
#define SPSR_EL2        (SPSR_MASK_ALL | SPSR_EL2h)

#define CurrentEL_EL1   (1 << 2)
#define CurrentEL_EL2   (2 << 2)
#define CurrentEL_EL3   (3 << 2)

#ifndef __ASSEMBLER__
void get_current_el();
#endif
