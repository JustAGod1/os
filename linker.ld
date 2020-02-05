SECTIONS {
	. = 0x500;
	_stack_start = .;
	. = 0x7C00;
	_stack_end = .;
	.text : { *(.text) }
	.text : { *(.data) }
}
