section .data
    arr dq 5, 10, 20, -3, 7      ; Array of 5 integers
    len dq 5                      ; Length of array
    msg db "Sum = ", 0            ; message to print 
    newline db 10                 ; Newline character

section .bss
    buffer resb 16                ; Buffer for number conversion

section .text
    global _start

; ---------------------------
; int sumArray(int* arr, int size)
; Input: 
;   rdi = pointer to array
;   rsi = size of array
; Return:
;   rax = sum of array elements
; ---------------------------
sumArray:
    xor rax, rax             ; rax will store the sum
    xor rcx, rcx             ; rcx = index = 0

.loop:
    cmp rcx, rsi
    jge .done

    add rax, [rdi + rcx*8]   ; sum += arr[index]
    inc rcx
    jmp .loop

.done:
    ret

; ---------------------------
; _start (main)
; ---------------------------
_start:
    ; Call sumArray(arr, len)
    mov rdi, arr             ; First arg: array pointer
    mov rsi, [len]           ; Second arg: array length
    call sumArray            ; rax now contains the sum

    ; Convert rax to ASCII string
    mov r8, buffer + 15      ; Point to end of buffer
    mov byte [r8], 0         ; Null-terminate string
    mov rcx, 10              ; Divisor for conversion

    ; Handle negative numbers
    test rax, rax
    jns .positive
    neg rax                  ; Make number positive
    mov byte [buffer], '-'   ; Store minus sign
    mov r9, buffer           ; Remember start position
    jmp .convert

.positive:
    mov r9, r8               ; Remember start position

.convert:
.to_str:
    dec r8                   ; Move pointer backward
    xor rdx, rdx             ; Clear upper part of dividend
    div rcx                  ; rax = quotient, rdx = remainder
    add dl, '0'              ; Convert to ASCII
    mov [r8], dl             ; Store digit
    test rax, rax            ; Check if quotient is zero
    jnz .to_str              ; Continue if not zero

    ; Print "Sum = "
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, msg
    mov rdx, 6               ; Length of "Sum = "
    syscall

    ; Print the number
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, r8              ; Start of number string
    mov rdx, buffer + 16     ; Calculate length
    sub rdx, r8              ; Length = end - start
    syscall

    ; Print newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; exit code 0
    syscall