section .bss
    buffer resb 65536

section .text
    global _start

_start:
    xor r12, r12

read_loop:
    mov rdx, 65535
    sub rdx, r12
    jle end_read

    xor rax, rax
    xor rdi, rdi
    lea rsi, [buffer + r12]
    syscall

    test rax, rax
    jle end_read

    add r12, rax
    jmp read_loop

end_read:
    test r12, r12
    jz is_palindrome

    cmp byte [buffer + r12 - 1], 10
    jne setup_check
    dec r12

setup_check:
    test r12, r12
    jz is_palindrome

    mov rsi, buffer
    lea rdi, [buffer + r12 - 1]

check_loop:
    cmp rsi, rdi
    jge is_palindrome

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne not_palindrome

    inc rsi
    dec rdi
    jmp check_loop

is_palindrome:
    mov rax, 60
    xor rdi, rdi
    syscall

not_palindrome:
    mov rax, 60
    mov rdi, 1
    syscall


