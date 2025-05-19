; ================================================
; NASM 64-bit (Linux)
; sumArray: Sums elements of an integer array
; Parameters:
;   [rbp + 16] : pointer to array (int*)
;   [rbp + 24] : size of array (int)
; Return:
;   pushes the sum onto the stack
; ================================================

section .data
    arr dq 5, 10, 20, -3, 7      ; Array of 5 integers
    len dq 5                     ; Length of array
    msg db "Sum = ", 0           ; message to print 

section .bss
    buffer resb 16

section .text
    global _start

; ---------------------------
; int sumArray(int* arr, int size)
; ---------------------------
sumArray:
    push rbp
    mov rbp, rsp

    mov rsi, [rbp + 16]      ; rsi = pointer to array
    mov rcx, [rbp + 24]      ; rcx = size

    xor rax, rax             ; rax will store the sum
    xor rbx, rbx             ; rbx = index = 0

.loop:
    cmp rbx, rcx
    jge .done

    mov rdx, [rsi + rbx*8]   ; load element (64-bit integers)
    add rax, rdx             ; sum += element

    inc rbx
    jmp .loop

.done:
    push rax                 ; return sum on stack
    pop rbp
    ret

; ---------------------------
; _start (main)
; ---------------------------
_start:
    ; Simulate call sumArray(arr, len)
    push qword [len]        ; push size
    push arr                ; push address of array
    call sumArray
    pop rax                 ; get returned sum from stack

    ; Convert rax to string
    mov rsi, buffer + 15
    mov rcx, 10
    mov rbx, rax
    mov byte [rsi], 0

.to_str:
    xor rdx, rdx
    div rcx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    mov rbx, rax
    test rax, rax
    jnz .to_str

    ; Print "Sum = "
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 6
    syscall

    ; Print result
    mov rax, 1
    mov rdi, 1
    mov rdx, buffer + 15
    sub rdx, rsi
    syscall

    ; Exit
    mov rax, 60
    xor rdi, rdi
    syscall