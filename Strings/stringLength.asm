; ======================================
; NASM 64-bit Linux
; stringLength: stack-based string length
; Parameters: pushed on stack (char* str)
; Returns: value pushed on stack (int)
; ======================================

section .data
    myStr db "Assembly is fun!", 0
    lenMsg db "Length: ", 0

section .bss
    outbuf resb 16

section .text
    global _start

; -------------------------------
; stringLength (stack-based)
; input: [rbp + 16] = return address
;        [rbp + 8]  = pointer to string
; output: pushes length on stack
; -------------------------------
stringLength:
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]     ; get string pointer from stack

    xor rcx, rcx            ; counter = 0

.loop:
    mov al, [rsi + rcx]     ; load byte
    cmp al, 0
    je .done
    inc rcx
    jmp .loop

.done:
    push rcx                ; return value on stack

    pop rbp
    ret

; -------------------------------
; _start (main)
; -------------------------------
_start:
    ; simulate call to stringLength(myStr) with stack
    push myStr
    call stringLength

    ; result is on top of the stack
    pop rax                ; rax = string length

    ; convert number to string for print
    mov rsi, outbuf + 15
    mov rcx, 10
    mov rbx, rax
    mov byte [rsi], 0

.conv:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    test rax, rax
    jnz .conv

    ; print "Length: "
    mov rax, 1
    mov rdi, 1
    mov rsi, lenMsg
    mov rdx, 8
    syscall

    ; print number
    mov rax, 1
    mov rdi, 1
    mov rdx, outbuf + 15
    sub rdx, rsi
    syscall

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall