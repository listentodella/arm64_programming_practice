SECTIONS
{
	. = 0x80000,
	.text.boot : {
        _text_boot_start = .;
        *(.text.boot);
        _text_boot_end = .;
    }
	.text : {
        _text_start = .;
        *(.text);
        _text_end = .;
    }
	.rodata : {
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
