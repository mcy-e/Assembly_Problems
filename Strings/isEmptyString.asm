section .data
    ; Test strings
    empty_str db 0               ; Empty string (null terminator only)
    non_empty_str db "ABC", 0    ; Non-empty string
    null_str dq 0                ; Simulated null pointer

    ; Messages
    msg_testing db "Testing: ", 10, 0
    msg_register db "[Register Version]: ", 0
    msg_stack db "[Stack Version]: ", 0
    msg_empty db "String is empty", 10, 0
    msg_not_empty db "String is not empty", 10, 0
    msg_null db "String is null", 10, 0

section .text
    global _start

; Main program
_start:
    ; Test 1: Empty string
    lea rdi, [empty_str]
    call test_both_versions

    ; Test 2: Non-empty string
    lea rdi, [non_empty_str]
    call test_both_versions

    ; Test 3: Null pointer (rdi = 0)
    mov rdi, [null_str]
    call test_both_versions

    ; Exit program
    mov rax, 60        ; syscall: exit
    xor rdi, rdi
    syscall

; ---------------------------------------
; Test both versions (register & stack)
; ---------------------------------------
test_both_versions:
    push rdi                  ; Save input string

    ; Print test header
    mov rsi, msg_testing
    mov rdx, 10
    call print_message

    pop rdi
    push rdi
    call print_string

    ; --- Register version ---
    mov rsi, msg_register
    mov rdx, 22
    call print_message

    pop rdi
    push rdi
    call isEmpty
    call print_result

    ; --- Stack version ---
    mov rsi, msg_stack
    mov rdx, 20
    call print_message

    pop rdi
    push rdi
    push rdi
    call isEmpty_stack
    add rsp, 8
    call print_result

    pop rdi
    ret

; ---------------------------------------
; isEmpty (Register version)
; Input: RDI = string pointer
; Output: AL = 1 if null or empty, 0 otherwise
; ---------------------------------------
isEmpty:
    xor eax, eax
    test rdi, rdi       ; Check for null pointer
    jz .empty_or_null
    mov al, [rdi]
    test al, al         ; Check for empty string
    sete al
    ret
.empty_or_null:
    mov al, 1
    ret

; ---------------------------------------
; isEmpty_stack (Stack version)
; Input: [RBP+16] = string pointer
; Output: AL = 1 if null or empty, 0 otherwise
; ---------------------------------------
isEmpty_stack:
    push rbp
    mov rbp, rsp
    mov rdi, [rbp+16]
    xor eax, eax
    test rdi, rdi
    jz .empty_or_null
    mov al, [rdi]
    test al, al
    sete al
    pop rbp
    ret
.empty_or_null:
    mov al, 1
    pop rbp
    ret

; ---------------------------------------
; print_result
; Uses AL as result flag
; ---------------------------------------
print_result:
    test al, al
    jz .not_empty

    mov rsi, msg_empty
    mov rdx, 17
    call print_message
    ret
.not_empty:
    mov rsi, msg_not_empty
    mov rdx, 23
    call print_message
    ret

; ---------------------------------------
; print_string
; Input: RDI = string pointer
; ---------------------------------------
print_string:
    test rdi, rdi
    jz .null_string
    mov al, [rdi]
    test al, al
    jz .empty_string
    ; Non-empty: print "String is not empty"
    mov rsi, msg_not_empty
    mov rdx, 23
    call print_message
    ret
.null_string:
    mov rsi, msg_null
    mov rdx, 17
    call print_message
    ret
.empty_string:
    mov rsi, msg_empty
    mov rdx, 17
    call print_message
    ret

; ---------------------------------------
; print_message
; Inputs:
;   RSI = pointer to string
;   RDX = length of string
; ---------------------------------------
print_message:
    mov rax, 1          ; syscall: write
    mov rdi, 1          ; file descriptor: stdout
    syscall
    ret
