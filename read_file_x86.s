; This program opens a file called test.txt
; on the same directory of the caller and
; reads and writes a 255 bytes buffer to stdout
; this is written in x86 (32 bits)

.global _start

.section .text
_start:
		movl $5, 			  %eax
		movl $filename, %ebx
		movl $0, 				%ecx
		int  $0x80

		movl %eax,			%ebx
		movl $3,				%eax
		movl $buffer,		%ecx
		movl $255,			%edx
		int  $0x80

		movl $4,				%eax
		movl $1,				%ebx
		movl $buffer,		%ecx
		int  $0x80

		movl $1, 		 		%eax
		movl $0, 		 		%ebx
		int  $0x80

.section .data
filename:
		.ascii "test.txt"

buffer:
	.skip 255
