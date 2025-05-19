
; STRING !!
; test : Computes operand1 & operand2 (bitwise AND) and discard the result and updates the flags !


section .data
    ; Test strings
    empty_str db 0           ; Empty string (just null terminator)
    non_empty_str db "ABC", 0 ; Non-empty string
    null_str dq 0            ; Null pointer case

    ; Output messages
    msg_empty db "String is empty", 10, 0
    msg_not_empty db "String is not empty", 10, 0
    msg_null db "String is null", 10, 0
    msg_testing db "Testing: ", 0
    msg_register db "[Register Version] ", 0
    msg_stack db "[Stack Version] ", 0

section .text
    global _start
    extern printf

_start:
    ; Test 1: Empty string
    lea rdi, [empty_str]
    call test_both_versions

    ; Test 2: Non-empty string
    lea rdi, [non_empty_str]
    call test_both_versions

    ; Test 3: Null pointer
    mov rdi, [null_str]
    call test_both_versions

    ; Exit
    mov rax, 60         ; sys_exit
    xor rdi, rdi        ; exit code 0
    syscall

; Test both versions with same string
test_both_versions:
    push rdi            ; Save string pointer

    ; Print which string we're testing
    mov rdi, msg_testing
    call printf
    pop rdi
    push rdi
    call print_string
    call printf_newline

    ; Test register version
    mov rdi, msg_register
    call printf
    pop rdi
    push rdi
    call isEmpty
    call print_result

    ; Test stack version
    mov rdi, msg_stack
    call printf
    pop rdi
    push rdi
    push rdi            ; Push parameter for stack version
    call isEmpty_stack
    add rsp, 8          ; Clean stack
    call print_result

    pop rdi             ; Restore
    ret

; Your functions
isEmpty:
    xor eax, eax
    mov al, [rdi]
    test al, al
    sete al
    ret

isEmpty_stack:
    push rbp
    mov rbp, rsp
    mov rdi, [rbp+16]
    
    xor eax, eax
    mov al, [rdi]
    test al, al
    sete al
    
    pop rbp
    ret

; Helper functions
print_result:
    test al, al
    jz .not_empty
    mov rdi, msg_empty
    jmp .print
.not_empty:
    mov rdi, msg_not_empty
.print:
    call printf
    ret

print_string:
    test rdi, rdi
    jz .null
    mov al, [rdi]
    test al, al
    jz .empty
    mov rsi, rdi
    mov rdi, msg_not_empty
    ret
.null:
    mov rdi, msg_null
    ret
.empty:
    mov rdi, msg_empty
    ret

printf_newline:
    mov rdi, 10
    call putchar
    ret

; Needed for printf
putchar:
    push rdi
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, rsp        ; pointer to character
    mov rdx, 1          ; length
    syscall
    pop rdi
    ret
