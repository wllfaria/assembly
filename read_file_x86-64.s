; This program opens a file called test.txt
; on the same directory of the caller and
; reads and writes a 255 bytes buffer to stdout
; this is written in x86-64 (64 bits)

.global _start

.section .text
_start:
		mov $2,					%rax
		mov $filename,	        %rdi
		mov $0,					%rsi
		syscall

		mov %rax,				%rdi
		mov $0,					%rax
		mov $buffer,		    %rsi
		mov $255,				%rdx
		syscall

		mov $1,					%rax
		mov $1,					%rdi
		mov $buffer,		    %rsi
		syscall

		mov $60,				%rax
		mov $0,					%rdi
		syscall

.section .data
filename:
		.ascii "test.txt"

buffer:
	.skip 255
