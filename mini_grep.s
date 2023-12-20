.global _start

.section .data
input:          .skip   100
name:           .skip   100
file:           .skip   255

search_msg:     .string "Enter the search term:\n"
file_msg:       .string "Enter the filename:\n"
not_found_msg:  .string "File does not contain the search term.\n"
found_msg:      .string "File contains the search term.\n"

.section .text
_start:
    # prompt for the grep string
    mov $1,             %rax
    xor %rdi,           %rdi
    mov $search_msg,    %rsi
    mov $23,            %rdx
    syscall

    # read the grep string
    xor %rax,           %rax
    mov $1,             %rdi
    mov $input,         %rsi
    mov $100,           %rdx
    syscall 
    lea -1(%rax),       %r10 # we store the actual input length on r10
    # this is a compile hack, essentially we are subtracting 1 from rax

    # prompt for the filename
    mov $1,             %rax
    xor %rdi,           %rdi
    mov $file_msg,      %rsi
    mov $21,            %rdx
    syscall

    # read filename
    xor %rax,           %rax
    mov $1,             %rdi
    mov $name,          %rsi
    mov $100,           %rdx
    syscall

    # same thing here
    mov $name,          %rdi
    dec                 %rax
    movl $0,            (%rdi, %rax)
 
    # open file
    mov $2,             %rax
    mov $name,          %rdi
    xor %rsi,           %rsi
    syscall

    # read file into buffer
    mov %rax,           %rdi
    xor %rax,           %rax
    mov $file,          %rsi
    mov $255,           %rdx
    syscall
    lea -1(%rax),       %r11 # we store the actual file length on r11

    # we start using 32 bits registers as we are performing 32 bits operations
    mov $file,          %edi
    mov $input,         %ebp
    xor %ebx,           %ebx # this indexes are just counters
    xor %rsi,           %rsi
compare_char:
    cmp %rsi,           %r10 # if we got to the end of input
    je                  found

    cmp %rbx,           %r11 # we check if we reached EOF
    je                  not_found

    movb (%edi, %ebx),  %al # we get one byte from the strings (1 char)
    cmpb %al,           (%ebp, %esi) # compare if it is the same
    jne                 no_match

    inc                 %ebx
    inc                 %esi
    jne                 compare_char
no_match:
    cmpl $0,            %esi # check if we never found a char
    jne                 reset_counter # reset if we did found
    inc                 %ebx
    jmp                 compare_char
reset_counter:
    mov $0,             %esi # reset esi to start looking for the first char
    jmp                 compare_char

found:
    mov $1,             %rax
    xor %rdi,           %rdi
    mov $found_msg,     %rsi
    mov $31,            %rdx
    syscall
    jmp                 exit
not_found:
    mov $1,             %rax
    xor %rdi,           %rdi
    mov $not_found_msg, %rsi
    mov $39,            %rdx
    syscall
exit:
    # we exit happy :)
    mov $60,            %rax
    xor %rdi,           %rdi
    syscall
