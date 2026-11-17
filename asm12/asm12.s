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
    jz exit_program

    xor r13, r13
    cmp byte [buffer + r12 - 1], 10
    jne setup_reverse
    dec r12
    mov r13, 1

setup_reverse:
    mov rsi, buffer
    lea rdi, [buffer + r12 - 1]

reverse_loop:
    cmp rsi, rdi
    jge print_result

    mov al, [rsi]
    mov bl, [rdi]
    mov [rsi], bl
    mov [rdi], al

    inc rsi
    dec rdi
    jmp reverse_loop

print_result:
    test r13, r13
    jz write_out
    mov byte [buffer + r12], 10
    inc r12

write_out:
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, r12
    syscall

exit_program:
    mov rax, 60
    xor rdi, rdi
    syscall

