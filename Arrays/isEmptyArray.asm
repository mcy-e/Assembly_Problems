section .data
    ; Test data
    empty_array dd 0
    non_empty_array dd 1, 2, 3
    size_empty dq 0
    size_non_empty dq 3

    ; Output strings
    msg_empty db "Array is empty", 10, 0
    msg_not_empty db "Array is not empty", 10, 0
    msg_test_empty db "Testing array of size 0", 10, 0
    msg_test_non_empty db "Testing array of size 3", 10, 0

section .text
    global _start

; bool isArrayEmpty(int arr[], int size)
; Input: RDI = array pointer (unused), RSI = size
; Output: RAX = 1 if empty (size == 0), 0 otherwise
isArrayEmpty:
    xor eax, eax          ; Clear return value (default to false)
    test rsi, rsi         ; Test size against itself (sets ZF if size == 0)
    setz al               ; Set AL=1 if ZF is set (size == 0)
    ret                   ; Return result in RAX (with upper bits cleared)

; Helper to print test case info
; Uses syscall write(1, msg, len)
print_test_case_empty:
    mov rax, 1            ; syscall: write
    mov rdi, 1            ; fd: stdout
    mov rsi, msg_test_empty
    mov rdx, 24           ; length of string
    syscall
    ret

print_test_case_non_empty:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_test_non_empty
    mov rdx, 26
    syscall
    ret

; Helper to print result
print_result:
    test al, al
    jz .not_empty

    ; Print empty message
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_empty
    mov rdx, 17
    syscall
    ret

.not_empty:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_not_empty
    mov rdx, 23
    syscall
    ret

_start:
    ; Test 1: Empty array
    mov rdi, empty_array
    mov rsi, [size_empty]
    call print_test_case_empty
    call isArrayEmpty
    call print_result

    ; Test 2: Non-empty array
    mov rdi, non_empty_array
    mov rsi, [size_non_empty]
    call print_test_case_non_empty
    call isArrayEmpty
    call print_result

    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall
