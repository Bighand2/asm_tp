section .bss
    buffer resb 70

section .text
    global _start

_start:
    pop rax
    pop rsi

    mov r12, 16

    cmp rax, 2
    je .one_arg
    cmp rax, 3
    je .two_args
    jmp exit_error_usage

.one_arg:
    pop rsi
    jmp .parse_num

.two_args:
    pop rsi
    cmp byte [rsi], '-'
    jne exit_error_usage
    cmp byte [rsi + 1], 'b'
    jne exit_error_usage
    cmp byte [rsi + 2], 0
    jne exit_error_usage

    mov r12, 2
    pop rsi

.parse_num:
    call parse_int64
    jc exit_error_invalid

    mov rbx, r12
    call print_base

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error_usage:
    mov rax, 60
    mov rdi, 2
    syscall

exit_error_invalid:
    mov rax, 60
    mov rdi, 1
    syscall

parse_int64:
    xor rax, rax
    xor rcx, rcx
    mov r8, 1

    mov cl, [rsi]
    test cl, cl
    jz .error

    cmp cl, '-'
    jne .check_plus
    mov r8, -1
    inc rsi
    jmp .check_empty

.check_plus:
    cmp cl, '+'
    jne .loop
    inc rsi

.check_empty:
    mov cl, [rsi]
    test cl, cl
    jz .error

.loop:
    mov cl, [rsi]
    test cl, cl
    jz .done

    cmp cl, '0'
    jb .error
    cmp cl, '9'
    ja .error

    sub cl, '0'

    mov r9, 10
    imul rax, r9
    jo .error

    cmp r8, -1
    je .sub_digit

    add rax, rcx
    jo .error
    jmp .next

.sub_digit:
    sub rax, rcx
    jo .error

.next:
    inc rsi
    jmp .loop

.done:
    clc
    ret

.error:
    stc
    ret

print_base:
    lea rsi, [buffer + 69]
    mov byte [rsi], 10
    mov rcx, 1

    xor r8, r8
    test rax, rax
    jns .convert_loop
    mov r8, 1

.convert_loop:
    cqo
    idiv rbx

    test rdx, rdx
    jns .pos_rem
    neg rdx

.pos_rem:
    cmp dl, 10
    jb .digit
    add dl, 'A' - 10
    jmp .store

.digit:
    add dl, '0'

.store:
    dec rsi
    mov [rsi], dl
    inc rcx

    test rax, rax
    jnz .convert_loop

    cmp r8, 1
    jne .write_syscall
    dec rsi
    mov byte [rsi], '-'
    inc rcx

.write_syscall:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall
    ret

