; ===============================
; Check if a number is prime
; NASM 64-bit (Linux)
; Author: khanfri moussa 
; ===============================


section .data
    msg_prime       db "Prime", 10, 0        ; "Prime" message with newline
    msg_not_prime   db "Not Prime", 10, 0    ; "Not Prime" message with newline

section .text
       global _start   ; Entry point for Linux

    ; ===============================
; Function: isPrime
; Input : RDI = number to check
; Output: RAX = 1 (prime), 0 (not prime)
; ===============================

isPrime:
    cmp rdi, 2          ; Check if number < 2
    jl .not_prime       ; If less than 2, not prime

    mov rcx, 2          ; Initialize divisor to 2

    .loop:
    ; Check if (divisor * divisor) > num
    mov rax, rcx        ; Copy divisor to RAX
    mul rcx             ; RAX = RCX * RCX
    cmp rax, rdi
    ja .prime           ; If divisor^2 > num, it's prime

    ; Check if num % divisor == 0
    mov rax, rdi        ; Copy input number to RAX
    xor rdx, rdx        ; Clear RDX before division
    div rcx             ; Divide RAX by RCX → RAX = quotient, RDX = remainder
    cmp rdx, 0
    je .not_prime       ; If remainder == 0, not prime

    inc rcx             ; divisor++
    jmp .loop           ; Repeat the loop

.prime:
    mov rax, 1          ; Return 1 (true)
    ret

.not_prime:
    mov rax, 0          ; Return 0 (false)
    ret

; ===============================
; Main Function (_start)
; ===============================

_start:
    mov rdi, 29         ; Number to check → Change it to test another number
    call isPrime        ; Call isPrime(number)

    ; After return, RAX contains 1 (prime) or 0 (not prime)
    cmp rax, 1
    je .print_prime     ; If RAX == 1 → Print "Prime"

.print_not_prime:
    ; write(1, msg_not_prime, 10)
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, msg_not_prime
    mov rdx, 10         ; length of message
    syscall
    jmp .exit           ; Exit after printing

.print_prime:
    ; write(1, msg_prime, 6)
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    mov rsi, msg_prime
    mov rdx, 6          ; length of message
    syscall

.exit:
    ; exit(0)
    mov rax, 60         ; syscall: exit
    xor rdi, rdi        ; status code = 0
    syscall
