section .data
    ; Arrays
    empty_array dd 0
    non_empty_array dd 1, 2, 3

    ; Sizes
    size_empty dq 0
    size_non_empty dq 3

    ; Messages
    msg_empty db "Array is empty", 10
    len_empty equ $ - msg_empty

    msg_not_empty db "Array is not empty", 10
    len_not_empty equ $ - msg_not_empty

    msg_test_empty db "Testing array of size 0", 10
    len_test_empty equ $ - msg_test_empty

    msg_test_non_empty db "Testing array of size 3", 10
    len_test_non_empty equ $ - msg_test_non_empty

section .text
    global _start

; ---------------------------------------
; bool isArrayEmpty(int arr[], int size)
; Input: RDI = array pointer, RSI = size
; Output: RAX = 1 if empty or null, else 0
; ---------------------------------------
isArrayEmpty:
    xor rax, rax            ; Clear RAX = 0 (not empty by default)
    test rdi, rdi           ; If array is null
    jz .empty
    test rsi, rsi           ; If size == 0
    jz .empty
    ret
.empty:
    mov rax, 1
    ret

; ---------------------------------------
; Print test case messages
; ---------------------------------------
print_test_case_empty:
    mov rax, 1              ; syscall: write
    mov rdi, 1              ; stdout
    mov rsi, msg_test_empty
    mov rdx, len_test_empty
    syscall
    ret

print_test_case_non_empty:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_test_non_empty
    mov rdx, len_test_non_empty
    syscall
    ret

; ---------------------------------------
; Print result (based on RAX)
; ---------------------------------------
print_result:
    cmp rax, 0
    jne .empty_result       ; If RAX == 1, it's empty

    ; Not empty
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_empty
    mov rdx, len_not_empty
    syscall
    ret

.empty_result:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_empty
    mov rdx, len_empty
    syscall
    ret

; ---------------------------------------
; Entry Point
; ---------------------------------------
_start:
    ; Test 1: Empty array
    mov rdi, empty_array
    mov rsi, [rel size_empty]
    call print_test_case_empty
    call isArrayEmpty
    call print_result

    ; Test 2: Non-empty array
    mov rdi, non_empty_array
    mov rsi, [rel size_non_empty]
    call print_test_case_non_empty
    call isArrayEmpty
    call print_result

    ; Exit
    mov rax, 60             ; syscall: exit
    xor rdi, rdi            ; exit code 0
    syscall
