


;  even/odd function for basics in numbers 

    section .text
    global isEven 

    

;bool isEven(int num)
; Input: num in EDI (System V calling convention)
; Output: RAX = 1 if even, 0 if odd
isEven : 

mov rax, rdi     ; Copy input to EAX
and rax, 1       ; Isolate LSB (0=even, 1=odd)
xor rax, 1       ; Flip result (0→1, 1→0)
ret 



; NASM 64-bit program to test isEven with four numbers
; Uses System V ABI, outputs to stdout

section .data
    ; Test cases: {input (dq), expected (db)}
    test_cases:
        dq 4, 1     ; Positive even
        dq 7, 0     ; Positive odd
        dq -2, 1    ; Negative even
        dq -3, 0    ; Negative odd
    test_cases_end:

    ; Strings for output
    fmt_input db "Input: %d, Expected: %d, Got: %d, %s", 10, 0
    pass_str db "PASS", 0
    fail_str db "FAIL", 0

section .text
global _start
extern printf

; isEven function
isEven:
    mov rax, rdi     ; Copy input to RAX
    and rax, 1       ; Isolate LSB (0=even, 1=odd)
    xor rax, 1       ; Flip result (0→1, 1→0)
    ret

; Main test program
_start:
    lea rbx, [test_cases]  ; Point to test cases

test_loop:
    cmp rbx, test_cases_end
    jge done

    mov rdi, [rbx]         ; Load input
    movzx r12, byte [rbx + 8] ; Load expected result
    call isEven            ; Call isEven, result in RAX

    cmp rax, r12
    je pass
    lea r13, [fail_str]    ; Set FAIL
    jmp print_result
pass:
    lea r13, [pass_str]    ; Set PASS

print_result:
    mov rsi, rdi           ; Input
    mov rdx, r12           ; Expected
    mov rcx, rax           ; Actual
    mov r8, r13            ; PASS/FAIL
    lea rdi, [fmt_input]   ; Format string
    xor rax, rax           ; Clear RAX for printf
    call printf

    add rbx, 16            ; Next test case
    jmp test_loop

done:
    mov rax, 60            ; Syscall: exit
    xor rdi, rdi           ; Status: 0
    syscall



