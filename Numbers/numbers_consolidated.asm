; ===== Consolidated Number Operations in Assembly =====
; This file contains all number-related assembly functions

section .text
global isPrime
global isEven
global factorial
global gcd
global fibonacci

; ===== isPrime =====
; Checks if a number is prime
; Input: RDI - number to check
; Output: RAX - 1 if prime, 0 if not prime
isPrime:
    push rbp
    mov rbp, rsp
    
    ; Handle special cases
    cmp rdi, 1          ; Check if number is 1
    jle .not_prime      ; If number <= 1, it's not prime
    
    cmp rdi, 2          ; Check if number is 2
    je .prime           ; If number = 2, it's prime
    
    test rdi, 1         ; Check if number is even
    jz .not_prime       ; If even (except 2), it's not prime
    
    mov rcx, 3          ; Start checking from 3
    
.loop:
    mov rax, rcx        ; Prepare for multiplication
    mul rax             ; rax = rcx * rcx
    
    cmp rax, rdi        ; Compare square of divisor with number
    jg .prime           ; If square > number, it's prime
    
    mov rax, rdi        ; Prepare for division
    xor rdx, rdx        ; Clear rdx for division
    div rcx             ; rax = rdi / rcx, rdx = rdi % rcx
    
    test rdx, rdx       ; Check if remainder is 0
    jz .not_prime       ; If divisible, it's not prime
    
    add rcx, 2          ; Move to next odd number
    jmp .loop           ; Continue loop
    
.prime:
    mov rax, 1          ; Return 1 (prime)
    jmp .done
    
.not_prime:
    xor rax, rax        ; Return 0 (not prime)
    
.done:
    pop rbp
    ret

; ===== isEven =====
; Checks if a number is even
; Input: RDI - number to check
; Output: RAX - 1 if even, 0 if odd
isEven:
    push rbp
    mov rbp, rsp
    
    test rdi, 1         ; Test least significant bit
    jz .even            ; If bit is 0, number is even
    
    xor rax, rax        ; Return 0 (odd)
    jmp .done
    
.even:
    mov rax, 1          ; Return 1 (even)
    
.done:
    pop rbp
    ret

; ===== factorial =====
; Calculates the factorial of a number
; Input: RDI - number
; Output: RAX - factorial of the number
factorial:
    push rbp
    mov rbp, rsp
    
    ; Handle special case
    cmp rdi, 0          ; Check if number is 0
    je .zero_case       ; If 0, return 1
    
    mov rax, 1          ; Initialize result to 1
    
.loop:
    mul rdi             ; rax = rax * rdi
    dec rdi             ; Decrement counter
    jnz .loop           ; Continue if counter is not 0
    jmp .done
    
.zero_case:
    mov rax, 1          ; 0! = 1
    
.done:
    pop rbp
    ret

; ===== gcd =====
; Calculates the greatest common divisor of two numbers
; Input: RDI - first number
;        RSI - second number
; Output: RAX - GCD of the two numbers
gcd:
    push rbp
    mov rbp, rsp
    
.loop:
    test rsi, rsi       ; Check if second number is 0
    jz .done            ; If 0, first number is the GCD
    
    mov rax, rdi        ; Prepare for division
    xor rdx, rdx        ; Clear rdx for division
    div rsi             ; rax = rdi / rsi, rdx = rdi % rsi
    
    mov rdi, rsi        ; First number = second number
    mov rsi, rdx        ; Second number = remainder
    jmp .loop           ; Continue loop
    
.done:
    mov rax, rdi        ; Return GCD
    pop rbp
    ret

; ===== fibonacci =====
; Calculates the nth Fibonacci number
; Input: RDI - n
; Output: RAX - nth Fibonacci number
fibonacci:
    push rbp
    mov rbp, rsp
    
    ; Handle special cases
    cmp rdi, 0          ; Check if n is 0
    je .zero_case       ; If 0, return 0
    
    cmp rdi, 1          ; Check if n is 1
    je .one_case        ; If 1, return 1
    
    ; Calculate Fibonacci number iteratively
    mov rcx, rdi        ; Initialize counter
    mov rax, 0          ; Initialize first Fibonacci number
    mov rbx, 1          ; Initialize second Fibonacci number
    
.loop:
    cmp rcx, 1          ; Check if we've calculated enough terms
    jle .done           ; If so, we're done
    
    mov rdx, rax        ; Save first number
    add rax, rbx        ; Calculate next Fibonacci number
    mov rbx, rdx        ; Update second number
    
    dec rcx             ; Decrement counter
    jmp .loop           ; Continue loop
    
.zero_case:
    xor rax, rax        ; Return 0
    jmp .done
    
.one_case:
    mov rax, 1          ; Return 1
    
.done:
    pop rbp
    ret
