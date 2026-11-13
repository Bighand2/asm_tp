section .bss
    buffer resb 64

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 63
    syscall

    cmp rax, 0
    jle exit_error

    mov byte [buffer + rax], 0
    mov rsi, buffer

    mov cl, [rsi]
    cmp cl, '-'
    je handle_negative
    cmp cl, '+'
    jne parse_loop
    inc rsi
    jmp parse_loop

handle_negative:
    inc rsi
    mov cl, [rsi]
    cmp cl, 10
    je exit_error
    cmp cl, 0
    je exit_error

neg_loop:
    mov cl, [rsi]
    cmp cl, 10
    je exit_not_prime
    cmp cl, 0
    je exit_not_prime
    cmp cl, '0'
    jb exit_error
    cmp cl, '9'
    ja exit_error
    inc rsi
    jmp neg_loop

parse_loop:
    xor rax, rax
    xor rcx, rcx
    xor r8, r8

read_digits:
    mov cl, [rsi]
    cmp cl, 10
    je check_empty
    cmp cl, 0
    je check_empty

    cmp cl, '0'
    jb exit_error
    cmp cl, '9'
    ja exit_error

    sub cl, '0'
    imul rax, 10
    jo exit_error
    add rax, rcx
    jo exit_error

    inc r8
    inc rsi
    jmp read_digits

check_empty:
    test r8, r8
    jz exit_error

    cmp rax, 2
    jl exit_not_prime
    je exit_prime

    test rax, 1
    jz exit_not_prime

    mov rbx, 3
    mov r9, rax

prime_loop:
    mov rax, rbx
    mul rbx
    jc exit_prime
    cmp rax, r9
    ja exit_prime

    mov rax, r9
    xor rdx, rdx
    div rbx
    test rdx, rdx
    jz exit_not_prime

    add rbx, 2
    jmp prime_loop

exit_prime:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

exit_error:
    mov rax, 60
    mov rdi, 2
    syscall


