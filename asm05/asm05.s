global _start

section .data
    newline db 10

section .text
_start:
    cmp qword [rsp], 2      
    jne .error             

    mov rsi, [rsp + 16]     
    mov rdx, 0              

.count:
    cmp byte [rsi + rdx], 0 
    je .print
    inc rdx
    jmp .count

.print:
    mov rax, 1              
    mov rdi, 1              
    syscall                 

    mov rax, 1              
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60           
    mov rdi, 0
    syscall

.error:
    mov rax, 60
    mov rdi, 2
    syscall