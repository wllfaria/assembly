.global _start

.section .data
input:          .skip   100
input_l:        .long   0

name:           .skip   100
file:           .skip   255
file_l:         .long   0

search_msg:     .string "Enter the search term:\n"
file_msg:       .string "Enter the filename:\n"
not_found_msg:  .string "File does not contain the search term.\n"
found_msg:      .string "File contains the search term.\n"

.section .text
_start:
    # prompt for the grep string
    mov $1,             %rax
    mov $0,             %rdi
    mov $search_msg,    %rsi
    mov $23,            %rdx
    syscall

    # read the grep string
    mov $0,             %rax
    mov $1,             %rdi
    mov $input,         %rsi
    mov $100,           %rdx
    syscall 

    # remove newline (\n)
    mov $input,         %rdi
    dec                 %rax
    movb $0,            (%rdi, %rax)
    mov %rax,           input_l

    # prompt for the filename
    mov $1,             %rax
    mov $0,             %rdi
    mov $file_msg,      %rsi
    mov $21,            %rdx
    syscall

    # read filename
    mov $0,             %rax
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
    mov $0,             %rsi
    syscall

    # read file into buffer
    mov %rax,           %rdi
    mov $0,             %rax
    mov $file,          %rsi
    mov $255,           %rdx
    syscall

    dec                 %rax
    mov %rax,           file_l(%rip) # store the actual file length

    # we start using 32 bits registers as we are performing 32 bits operations
    mov $file,          %edi
    mov $input,         %ebp
    xor %ebx,           %ebx # this indexes are just counters
    xor %esi,           %esi
compare_char:
    cmp %esi,           input_l(%rip) # if we got to the end of input
    je                  found

    cmp %rbx,           file_l(%rip) # we check if we reached EOF
    je                  not_found

    movb (%edi, %ebx),  %al # we get one byte from the strings (1 char)
    movb (%ebp, %esi),  %dl
    cmp %dl,            %al # compare if it is the same
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
    mov $0,             %rdi
    mov $found_msg,     %rsi
    mov $31,            %rdx
    syscall
    jmp                 exit
not_found:
    mov $1,             %rax
    mov $0,             %rdi
    mov $not_found_msg, %rsi
    mov $39,            %rdx
    syscall
    jmp                 exit


exit:
    # we exit happy :)
    mov $60,            %rax
    mov $0,             %rdi
    syscall
