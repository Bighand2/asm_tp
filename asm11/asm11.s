section .bss
    inp resb 4096

section .text
    global _start

_start:
    xor r12, r12

read_loop:
    xor rax, rax
    xor rdi, rdi
    mov rsi, inp
    mov rdx, 4096
    syscall

    test rax, rax
    jle call_exit

    mov rcx, rax
    mov rsi, inp

check_char:
    movzx rax, byte [rsi]
    or al, 0x20
    cmp al, 'a'
    je is_vowel
    cmp al, 'e'
    je is_vowel
    cmp al, 'i'
    je is_vowel
    cmp al, 'o'
    je is_vowel
    cmp al, 'u'
    je is_vowel
    jmp next_char

is_vowel:
    inc r12

next_char:
    inc rsi
    dec rcx
    jnz check_char
    jmp read_loop

call_exit:
    mov rsi, r12
    call print_int
    mov rax, 60
    xor rdi, rdi
    syscall

print_int:
    sub rsp, 32
    lea rdi, [rsp + 31]
    mov byte [rdi], 10
    mov rax, rsi
    mov rcx, 10

convert:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rdi
    mov [rdi], dl
    test rax, rax
    jnz convert

    mov rsi, rdi
    lea rdx, [rsp + 32]
    sub rdx, rdi
    mov rax, 1
    mov rdi, 1
    syscall
    add rsp, 32
    ret


