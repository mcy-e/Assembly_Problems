
section .text
global isPrime
global isEven
global factorial
global gcd
global fibonacci

isPrime:
    push rbp
    mov rbp, rsp
    
    ; handle special cases
    cmp rdi, 1          ; check if number is 1
    jle .not_prime      ; if number <= 1 it's not prime
    
    cmp rdi, 2          ; check if number is 2
    je .prime           ; if number = 2it's prime
    
    test rdi, 1         ; check if number is even
    jz .not_prime       ; if even it's not prime
    
    mov rcx, 3          ; start checking from 3
    
.loop:
    mov rax, rcx        ; prepare for multiplication
    mul rax             ; rax = rcx * rcx
    
    cmp rax, rdi        ; compare square of divisor with number
    jg .prime           ; if square > number it's prime
    
    mov rax, rdi        ; prepare for division
    xor rdx, rdx        ; clear rdx for division
    div rcx             ; rax = rdi / rcx && rdx = rdi % rcx
    
    test rdx, rdx       ; check if remainder is 0
    jz .not_prime       ; if divisible it's not prime
    
    add rcx, 2          ; move to next odd number
    jmp .loop           ; continue loop
    
.prime:
    mov rax, 1          ; return 1 
    jmp .done
    
.not_prime:
    xor rax, rax        ; return 0 
    
.done:
    pop rbp
    ret


isEven:
    push rbp
    mov rbp, rsp
    
    test rdi, 1         ; test least significant bit
    jz .even            ; if bit is 0  number is even
    
    xor rax, rax        ; return 0 
    jmp .done
    
.even:
    mov rax, 1          ; return 1 
    
.done:
    pop rbp
    ret

factorial:
    push rbp
    mov rbp, rsp
    
    ; handle special case
    cmp rdi, 0          ; check if number is 0
    je .zero_case       ; If 0 return 1
    
    mov rax, 1          ; initialize result to 1
    
.loop:
    mul rdi             ; rax = rax * rdi
    dec rdi             ; decrement counter
    jnz .loop           ; continue if counter is not 0
    jmp .done
    
.zero_case:
    mov rax, 1          ; 0! = 1
    
.done:
    pop rbp
    ret

gcd:
    push rbp
    mov rbp, rsp
    
.loop:
    test rsi, rsi       ; check if second number is 0
    jz .done            ; if 0 first number is the GCD
    
    mov rax, rdi        ; prepare for division
    xor rdx, rdx        ; clear rdx for division
    div rsi             ; rax = rdi / rsi, rdx = rdi % rsi
    
    mov rdi, rsi        ; First number = second number
    mov rsi, rdx        ; Second number = remainder
    jmp .loop           ; continue looping 
    
.done:
    mov rax, rdi        ; return GCD
    pop rbp
    ret

fibonacci:
    push rbp
    mov rbp, rsp
    
    ; Handle special cases
    cmp rdi, 0          ; check if n is 0
    je .zero_case       ; if 0 return 0
    
    cmp rdi, 1          ; check if n is 1
    je .one_case        ; if 1 return 1
    
    ; calculate Fibonacci numbers
    
    mov rcx, rdi        ; inti counter
    mov rax, 0          ; init first Fibonacci number
    mov rbx, 1          ; init second Fibonacci number
    
.loop:
    cmp rcx, 1          ; Check if we have calculated enough terms
    jle .done           ; if so we are done
    
    mov rdx, rax        ; save first number
    add rax, rbx        ; calculate next Fibonacci number
    mov rbx, rdx        ; update second number
    
    dec rcx             ; decrement counter
    jmp .loop           ; continue loop
    
.zero_case:
    xor rax, rax        ; return 0
    jmp .done
    
.one_case:
    mov rax, 1          ; return 1
    
.done:
    pop rbp
    ret
