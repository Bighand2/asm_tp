section .bss
    buffer resb 32

section .text
    global _start

_start:
    pop rax
    cmp rax, 3
    jne exit_error_args

    pop rsi

    pop rsi
    call atoi_64
    jc exit_error_invalid
    mov rbx, rax

    pop rsi
    call atoi_64
    jc exit_error_invalid

    add rax, rbx
    jo exit_error_invalid

    call print_int64

    mov rax, 60
    xor rdi, rdi
    syscall

exit_error_args:
    mov rax, 60
    mov rdi, 2
    syscall

exit_error_invalid:
    mov rax, 60
    mov rdi, 1
    syscall

atoi_64:
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

print_int64:
    lea rsi, [buffer + 31]
    mov byte [rsi], 10
    mov rcx, 1
    mov rbx, 10

    xor r8, r8
    test rax, rax
    jns .convert_loop
    mov r8, 1

.convert_loop:
    xor rdx, rdx
    cqo
    idiv rbx
    
    test rdx, rdx
    jns .positive_rem
    neg rdx

.positive_rem:
    add dl, '0'
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