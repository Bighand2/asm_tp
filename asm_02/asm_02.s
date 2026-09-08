global _start

section .bss
    input resb 256
section .data
    msg db "1337", 10

section .text
_start:
    ;sys_read()
    mov rax, 0
    mov rdi, 0
    mov rsi, input
    mov rdx, 256
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