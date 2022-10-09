SECTIONS
{
	. = 0x80000,
    _text_boot_start = .;
	.text.boot : { *(.text.boot) }
    _text_boot_end = .;
    _text_start = .;
	.text : { *(.text) }
    _text_end = .;
    _rodata_start = .;
	.rodata : { *(.rodata) }
    _rodata_end = .;
    _data_start = .;
	.data : { *(.data) }
    _data_end = .;
	. = ALIGN(0x8);
	bss_begin = .;
	.bss : { *(.bss*) }
	bss_end = .;
}
