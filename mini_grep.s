.global _start

.section .data
print_str: .skip 100
print_len: .long 0

search_term: .skip 100
search_len: .long 0

filename: .skip 100
file: .skip 255
file_len: .long 0

search_msg: .string "Enter the search term:\n"
file_msg: .string "Enter the filename:\n"
not_found_msg: .string "File does not contain the search term.\n"
found_msg: .string "File contains the search term.\n"
cur_step: .long 0

.section .text
_start:
    jmp                 prompt_search_term
prompt_search_term:
    mov $1,             %rax
    mov $0,             %rdi
    mov $search_msg,    %rsi
    mov $23,            %rdx
    syscall

    movl $1,            cur_step(%rip)
    jmp                 next_step
prompt_filename:
    mov $1,             %rax
    mov $0,             %rdi
    mov $file_msg,      %rsi
    mov $21,            %rdx
    syscall

    movl $4,            cur_step(%rip)
    jmp                 next_step
next_step:
    cmpl $0,            cur_step(%rip)
    je                  exit
    cmpl $1,            cur_step(%rip)
    je                  read_search_term
    cmpl $2,            cur_step(%rip)
    je                  remove_newline
    cmpl $3,            cur_step(%rip)
    je                  prompt_filename
    cmpl $4,            cur_step(%rip)
    je                  read_filename
    cmpl $5,            cur_step(%rip)
    je                  remove_newline
    cmpl $6,            cur_step(%rip)
    je                  open_file
    cmpl $7,            cur_step(%rip)
    je                  read_file
    cmpl $8,            cur_step(%rip)
    je                  look_for_search_term
    cmpl $9,            cur_step(%rip)
    je                  print_found
    cmpl $10,           cur_step(%rip)
    je                  print_not_found
    cmpl $99,           cur_step(%rip)
    je                  print_file
read_search_term:
    mov $0,             %rax
    mov $1,             %rdi
    mov $search_term,   %rsi
    mov $100,           %rdx
    syscall

    mov %rax,           search_len(%rip)
    movl $2,            cur_step(%rip)
    jmp                 next_step
read_filename:
    mov $0,             %rax
    mov $1,             %rdi
    mov $filename,      %rsi
    mov $100,           %rdx
    syscall
 
    movl $5,            cur_step(%rip)
    jmp                 next_step
remove_newline:
    cmpl $3,            cur_step(%rip)
    je                  replace_from_search_term
    cmpl $5,            cur_step(%rip)
    je                  replace_from_filename
    replace_from_search_term:
        lea search_term,%rdi
        movl $3,        cur_step(%rip)
        xor %rax,       %rax
        jmp             compare
    replace_from_filename:
        lea filename,   %rdi
        movl $6,        cur_step(%rip)
        xor %rax,       %rax
        jmp             compare
    compare:
        cmpb $0,        (%rdi, %rax)
        je              end_compare
        cmpb $0x0A,     (%rdi, %rax)
        je              replace
        inc             %rax
        jmp             compare
    replace:
        movl $0,        (%rdi, %rax)
    end_compare:
        jmp             next_step
open_file:
    mov $2,             %rax
    mov $filename,      %rdi
    mov $0,             %rsi
    syscall

    movl $7,            cur_step
    jmp                 next_step
read_file:
    mov %rax,           %rdi
    mov $0,             %rax
    mov $file,          %rsi
    mov $255,           %rdx
    syscall

    mov %rax,           file_len(%rip)
    movl $8,            cur_step(%rip)
    jmp                 next_step
look_for_search_term:
    mov file_len,       %rdx
    dec                 %rdx
    mov %rdx,           file_len(%rip)
    mov search_len,     %rdx
    dec                 %rdx
    mov %rdx,           search_len(%rip)
    mov $file,          %edi
    mov $search_term,   %ebp
    xor %ebx,           %ebx
    xor %esi,           %esi
    compare_letter:
        cmp %rbx,       file_len(%rip)
        je not_found_search_term
        movb (%edi, %ebx), %al
        movb (%ebp, %esi), %dl
        cmp %dl, %al
        jne next_letter
        je found
        next_letter:
            cmpl $0,     %esi
            jne reset_esi
            inc         %ebx
            jmp         compare_letter
        reset_esi:
            mov $0,     %esi
            jmp         compare_letter
        found:
            inc         %ebx
            inc         %esi
            cmp %esi,  search_len(%rip)
            je found_search_term
            jne         compare_letter
found_search_term:
    movl $9,            cur_step(%rip)
    jmp                 next_step
not_found_search_term:
    movl $10,           cur_step(%rip)
    jmp                 next_step
print_found:
    mov $1,             %rax
    mov $0,             %rdi
    mov $found_msg,     %rsi
    mov $31,            %rdx
    syscall

    movl $99,           cur_step(%rip)
    jmp                 next_step
print_not_found:
    mov $1,             %rax
    mov $0,             %rdi
    mov $not_found_msg, %rsi
    mov $39,            %rdx
    syscall

    movl $99,           cur_step(%rip)
    jmp                 next_step
print_file:
    mov $1,				%rax
    mov $1,				%rdi
    mov $file,		    %rsi
    syscall

    movl $0,            cur_step(%rip)
    jmp                 next_step
exit:
    mov $60,            %rax
    mov $0,             %rdi
    syscall
