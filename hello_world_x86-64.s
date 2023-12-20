; This is a simple Hello, World! asm program!
; this is the translation of my first asm
; program to x86-64 (64 bits) format.

.global _start

.text
_start:
		mov $1,		%rax
		mov $1, 	%rdi
		mov $msg,	%rsi
		mov $14,	%rdx
		syscall
		mov $60,	%rax
		mov $0,		%rdi
		syscall

.data
msg:
	.ascii "Hello, World!\n"
