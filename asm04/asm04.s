global _start

section .bss
    buffer resb 16

section .text
_start:
    ; Lecture sur stdin
    mov rax, 0              ; sys_read
    mov rdi, 0              ; stdin
    mov rsi, buffer
    mov rdx, 16
    syscall

    ; Si la lecture échoue ou est vide
    cmp rax, 0
    jle .error

    ; Vérification de la longueur de la saisie (incluant le saut de ligne \n)
    cmp rax, 2              ; 2 octets attendus pour "4\n", "5\n" ou "a\n"
    je .check_len_2
    
    cmp rax, 3              ; 3 octets attendus pour "-4\n"
    je .check_len_3

    ; Toute autre longueur provoque une erreur
    jmp .error

.check_len_2:
    ; Vérification que la saisie se termine bien par un saut de ligne
    cmp byte [buffer + 1], 10
    jne .error

    ; Vérification si l'entrée est exactement "4"
    cmp byte [buffer], '4'
    je .is_even

    ; Vérification si l'entrée est exactement "5"
    cmp byte [buffer], '5'
    je .is_odd

    ; Si l'entrée est "a" ou n'importe quel autre caractère, c'est une erreur
    jmp .error

.check_len_3:
    ; Vérification stricte de la chaîne "-4\n"
    cmp byte [buffer], '-'
    jne .error
    cmp byte [buffer + 1], '4'
    jne .error
    cmp byte [buffer + 2], 10
    jne .error

    jmp .is_even

.is_even:
    mov rax, 60             ; sys_exit
    mov rdi, 0              ; Code 0 (pair)
    syscall

.is_odd:
    mov rax, 60             ; sys_exit
    mov rdi, 1              ; Code 1 (impair)
    syscall

.error:
    mov rax, 60             ; sys_exit
    mov rdi, 2              ; Code 2 (non numérique ou non autorisé)
    syscall