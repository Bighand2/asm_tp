global _start

section .bss
    buffer resb 16

section .text
_start:
    mov rax, 0              
    mov rdi, 0              
    mov rsi, buffer
    mov rdx, 16
    syscall

    cmp rax, 0
    jle .error

    cmp rax, 2            
    je .check_len_2
    
    cmp rax, 3              
    je .check_len_3

    jmp .error

.check_len_2:
    cmp byte [buffer + 1], 10
    jne .error

    cmp byte [buffer], '4'
    je .is_even

    cmp byte [buffer], '5'
    je .is_odd

    jmp .error

.check_len_3:

    cmp byte [buffer], '-'
    jne .error
    cmp byte [buffer + 1], '4'
    jne .error
    cmp byte [buffer + 2], 10
    jne .error

    jmp .is_even

.is_even:
    mov rax, 60             
    mov rdi, 0              
    syscall

.is_odd:
    mov rax, 60             
    mov rdi, 1              
    syscall

.error:
    mov rax, 60             
    mov rdi, 2              
    syscall