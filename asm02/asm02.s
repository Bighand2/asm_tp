global _start

section .bss
    input resb 16
section .data
    msg db "1337", 10

section .text
_start:
    
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 16
    syscall

    cmp byte [input], 0x34
    jne _error

    cmp byte [input + 1], 0x32
    jne _error

    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 5
    syscall

_end:
    mov rax, 60
    mov rdi, 0
    syscall

_error:
    mov rax, 60
    mov rdi, 1
    syscall