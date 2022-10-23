gdt_start:

.null:
	dq 0x0

gdt_code:
	dw 0xffff
	dw 0x0
	db 0x0
	db 0x9a
	db 0b11001111
	db 0x0
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 0x92
	db 0x11001111
	db 0x0

gdt_end:



gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
