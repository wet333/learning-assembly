section .data
    print_res db 'The result is: ', 0
    new_line db 0xA
    counter db 1
    string_buffer_size db 24

section .bss
    string_buffer resb 24 ; Reserve 24 bytes, 1 byte per character
    digit resb 1

    dividend resq 1
    divisor resq 1
    result resq 1
    remainder resq 1

section .text
    global _start

_start:

    mov rax, 12
    mov rbx, 5
    add rax, rbx
    mov [result], rax

    ; Printing the result string
    mov rax, 1
    mov rdi, 1
    mov rsi, print_res
    mov rdx, 16
    syscall

    call build_up_string

    ; Print result number
    mov rax, 1
    mov rdi, 1
    mov rsi, string_buffer
    mov rdx, [string_buffer_size]
    syscall

    ; Print new line
    mov rax, 1
    mov rdi, 1
    mov rsi, new_line
    mov rdx, 1
    syscall

    ; Exit syscall
    mov rax, 60
    xor rdi, rdi
    syscall

build_up_string:
    mov rax, [result]   ; Load the result in rax, and extract each digit

    ; Extract digit and append it into string_buffer
    .loop:
        mov rbx, 10     ; Divide by 10, to get the digit value
        xor rdx, rdx    ; Clear rdx before division

        div rbx         ; rax / rbx = result: rax - remainder: rdx
        call save_division_results
        call append_digit_into_string
        cmp rax, 0      ; Check if the result is zero (it means no more digits)

        ; rax = result of the previous division
        jnz .loop

    ret

append_digit_into_string:
    push rax
    push rdx
    push rbx
    push rcx

    mov rax, [remainder]
    add rax, '0'                        ; Convert remainder number to ASCII
    movzx rbx, byte [string_buffer_size]; mov-zero-extended, adds 0s to the non written bytes of the register (rbx=8bytes)
    movzx rcx, byte [counter]           ; Same as avobe
    sub rbx, rcx
    ; mov [digit], al                     ; Save ASCII value into digit (DEBBUG)
    mov [string_buffer + rbx], al       ; Push ASCII digit to string
    inc byte [counter]                  ; Advance counter

    ; Print result number (DUBBUG)
    ; mov rax, 1
    ; mov rdi, 1
    ; mov rsi, digit
    ; mov rdx, 1
    ; syscall

    pop rcx
    pop rbx
    pop rdx
    pop rax
    ret

save_division_results:
    mov qword [result], rax
    mov qword [remainder], rdx
    ret