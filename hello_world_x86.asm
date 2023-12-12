; This is a simple Hello, World! asm program!
; this is the first program i wrote, it is in
; x86 (32 bits) format.

.global _start

.text
_start:
		movl 	$4, 		%eax
		movl 	$1, 		%ebx
		movl 	$msg, 	%ecx
		movl 	$0xE, 	%edx
		int 	$0x80
		movl 	$1, 		%eax
		movl 	$0, 		%ebx
		int 	$0x80
.data
msg:
		.ascii "Hello, World!\n"
