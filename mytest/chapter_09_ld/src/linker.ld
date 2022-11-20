TEXT_ROM = 0x90000;

SECTIONS
{
	. = 0x80000,
	.text.boot : {
        _text_boot_start = .;
        *(.text.boot);
        _text_boot_end = .;
    }
	.text : AT(TEXT_ROM) {
        _text_start = .;
        *(.text);
        _text_end = .;
    }

	/* .rodata : { */
	/* 注意 这里, 如果没有下面的表述, map文件里可以看到，
		每个段都将有一个加载地址, 这会影响到后续运行(不仅仅是代码段需要copy了)
		ADDR(section) 则可以返回段的虚拟地址，这样从此开始的段，会继续从虚拟地址开始算起
	*/
	.rodata : AT(ADDR(.rodata)) {
        _rodata_start = .;
        *(.rodata);
        _rodata_end = .;
    }
	.data : {
        _data_start = .;
        *(.data);
        _data_end = .;
    }
    . = ALIGN(0x8);
	.bss : {
        bss_begin = .;
        *(.bss*);
        bss_end = .;
    }
}

/*
default:
BenOS image layout:
    .text.boot: 0x00080000 - 0x00080030 (    48 B)
         .text: 0x00080030 - 0x00081688 (  5720 B)
       .rodata: 0x00081688 - 0x000817f9 (   369 B)
         .data: 0x000817f9 - 0x000819c0 (   455 B)
          .bss: 0x00081a38 - 0x000a1e48 (132112 B)



*/
