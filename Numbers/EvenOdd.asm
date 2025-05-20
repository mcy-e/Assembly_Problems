section .data
    even_msg db 'Even', 0xA
    even_len equ $ - even_msg
    odd_msg db 'Odd', 0xA
    odd_len equ $ - odd_msg

section .text
    global _start

; bool isEven(int num)
; Input: num in EDI
; Output: RAX = 1 if even, 0 if odd
isEven:
    mov rax, rdi     ; Copy input to RAX
    and rax, 1       ; Isolate LSB (0=even, 1=odd)
    xor rax, 1       ; Flip result (0→1, 1→0)
    ret

_start:
    mov rdi, 42      ; Test this number (change to any value you want)
    call isEven

    ; Print result (using sys_write)
    cmp rax, 1
    je print_even

print_odd:
    mov rax, 1       ; sys_write
    mov rdi, 1       ; stdout
    mov rsi, odd_msg
    mov rdx, odd_len
    syscall
    jmp exit

print_even:
    mov rax, 1       ; sys_write
    mov rdi, 1       ; stdout
    mov rsi, even_msg
    mov rdx, even_len
    syscall

exit:
    ; Exit program
    mov rax, 60      ; sys_exit
    xor rdi, rdi     ; exit code 0
    syscall