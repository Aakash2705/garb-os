org 0x7c00
bits 16

%define endl 0x0D, 0x0A, 0

; BIOS Parameter Block for FAT12
; will use FAT12 in the bootloader
; will switch to ext4 later

jmp short bootl
nop

bootl:
	mov ah, 0x0e
	mov si, hello_msg
	call puts
	
	mov sp, 0x7c00
	mov bp, sp
	
	mov ax, 0x50

	mov es, ax
	xor bx, bx

	mov al, 16
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, 0

	mov ah, 0x02
	int 0x13
	jc .disk_fail

	mov ah, 0x00
	mov al, 0x10
	int 0x10

	call init_pm

.disk_fail:
	mov si, disk_fail_msg
	call puts

	cli
	hlt


%include "src/boot/gdt.asm"
init_pm:
	cli
	lgdt [gdt_descriptor]

	mov eax, cr0
	or eax, 0x1
	mov cr0, eax

	jmp CODE_SEG:begin_pm

	hlt

; prints to screen
; takes si as pointer to string
puts:
	push ax
	push si
.loop:
	cmp al, 0
	je .done

	lodsb
	mov ah, 0x0e
	int 0x10
	jmp .loop
.done:
	pop si
	pop ax
	ret

hello_msg: db "WELCOME TO GARB OS", endl 
disk_fail_msg: db "DISK READ FAILED", endl

[bits 32]
begin_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax

	mov ebp, 0x90000
	mov esp, ebp

	hlt

times 510 - ($ - $$) db 0
dw 0xaa55
