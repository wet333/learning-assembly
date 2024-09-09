section .data
    hello_msg db 'Hello, World!', 0xA   ; Null-terminated string

section .text
    global _start                 ; Entry point for the linker

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello_msg
    mov rdx, 14
    syscall                       ; Make the system call

    ; Exit syscall (syscall number 60)
    mov rax, 60                   ; System call for exit
    xor rdi, rdi                  ; Exit code 0
    syscall                       ; Make the system call
