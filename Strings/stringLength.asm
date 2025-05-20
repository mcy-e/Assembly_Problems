section .data
    myStr db "Assembly is fun!", 0
    lenMsg db "Length: ", 0
    newline db 10           ; Added for proper output formatting

section .bss
    outbuf resb 16

section .text
    global _start

; -------------------------------
; stringLength (stack-based)
; input: [rbp + 16] = pointer to string
; output: rax = string length
; -------------------------------
stringLength:
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]     ; get string pointer from stack
    xor rax, rax            ; counter = 0 (using rax instead of rcx)

.loop:
    mov cl, [rsi + rax]     ; load byte
    cmp cl, 0
    je .done
    inc rax
    jmp .loop

.done:
    mov rsp, rbp            ; restore stack pointer
    pop rbp
    ret

; -------------------------------
; _start (main)
; -------------------------------
_start:
    ; call stringLength(myStr)
    push myStr
    call stringLength
    add rsp, 8              ; clean up stack (remove pushed argument)

    ; rax now contains the string length

    ; convert number to string for printing
    mov rdi, outbuf + 15    ; point to end of buffer
    mov byte [rdi], 0       ; null-terminate
    mov rcx, 10             ; divisor for conversion

    ; Handle case where length is 0
    test rax, rax
    jnz .convert
    mov byte [outbuf + 14], '0'
    mov rsi, outbuf + 14
    jmp .print

.convert:
    mov rsi, rdi            ; remember start position
    mov rbx, rax            ; save length

.to_str:
    dec rdi                 ; move backward in buffer
    xor rdx, rdx            ; clear upper dividend
    div rcx                 ; rax = quotient, rdx = remainder
    add dl, '0'             ; convert to ASCII
    mov [rdi], dl           ; store digit
    test rax, rax           ; check if done
    jnz .to_str

    mov rsi, rdi            ; point to start of number string

.print:
    ; print "Length: "
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rdx, 8              ; length of "Length: "
    mov rsi, lenMsg
    syscall

    ; print number
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rdx, outbuf + 15    ; calculate length
    sub rdx, rsi            ; length = end - start
    syscall

    ; print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; exit
    mov rax, 60             ; sys_exit
    xor rdi, rdi            ; exit code 0
    syscall