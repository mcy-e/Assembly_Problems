


section .text
global isArrayEmpty

; bool isArrayEmpty(int arr[], int size)
; Input: RDI = array pointer (unused), RSI = size
; Output: RAX = 1 if empty (size == 0), 0 otherwise
isArrayEmpty:
    xor eax, eax          ; Clear return value (default to false)
    test rsi, rsi         ; Test size against itself (sets ZF if size == 0)
    setz al               ; Set AL=1 if ZF is set (size == 0)
    ret                   ; Return result in RAX (with upper bits cleared)
 ; test
  section .data
    ; Test data
    empty_array dd 0
    non_empty_array dd 1, 2, 3
    size_empty dq 0
    size_non_empty dq 3
    
    ; Output strings
    msg_empty db "Array is empty", 10, 0
    msg_not_empty db "Array is not empty", 10, 0
    msg_test db "Testing array of size ", 0
    msg_colon db ": ", 0

section .text
    global _start
    extern printf

_start:
    ; Test 1: Empty array
    mov rdi, empty_array
    mov rsi, [size_empty]
    call print_test_case
    call isArrayEmpty
    call print_result
    
    ; Test 2: Non-empty array
    mov rdi, non_empty_array
    mov rsi, [size_non_empty]
    call print_test_case
    call isArrayEmpty
    call print_result
    
    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall

; Your function
isArrayEmpty:
    xor eax, eax
    test rsi, rsi
    setz al
    ret

; Helper to print test case info
print_test_case:
    push rdi
    push rsi
    
    ; Print "Testing array of size X: "
    mov rdi, msg_test
    xor eax, eax
    call printf
    
    mov rdi, [rsp]      ; Get size from stack
    mov rsi, msg_colon
    xor eax, eax
    call printf
    
    pop rsi
    pop rdi
    ret

; Helper to print result
print_result:
    test al, al
    jz .not_empty
    
    ; Print empty message
    mov rdi, msg_empty
    jmp .print
    
.not_empty:
    mov rdi, msg_not_empty
    
.print:
    xor eax, eax
    call printf
    ret