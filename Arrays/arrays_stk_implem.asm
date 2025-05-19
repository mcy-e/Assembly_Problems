
; System call macros
; sys_write macro
%macro sys_write 2
    mov rax, 1          
    mov rdi, 1          
    mov rsi, %1         
    mov rdx, %2         
    syscall
%endmacro

; sys_read
%macro sys_read 1
    mov rax, 0          
    mov rdi, 0          
    mov rsi, %1         
    mov rdx, 512        
    syscall
    mov byte [rsi + rax - 1], 0 ;  null terminator
%endmacro

; sys_exit

%macro sys_exit 1
    mov rax, 60         
    mov rdi, %1         
    syscall
%endmacro

section .data
    prompt db "Enter numbers separated by spaces: ", 0xA
    prompt_len equ $ - prompt
    comma db ", ", 0
    left_bracket db "[", 0
    right_bracket db "]", 0xA, 0
    error_msg db "Error: Invalid input", 0xA, 0

section .bss
    input resb 512       ;readed input
    array resq 100       ; array of 64-bit integers
    count resq 1         ; size of the array
    num_buffer resb 32   ; buffer for number conversion

section .text
    global _start

_start:
    ; initialize stack
    mov rbp, rsp
    
    ; display prompt
    sys_write prompt, prompt_len
    
    ; read input
    sys_read input
    
    ; parse numbers
    call parse_numbers
    cmp qword [count], 0
    je .error
    
    ; print array
    call print_array
    jmp .exit
    
.error:
    sys_write error_msg, 20
.exit:
    mov rsp, rbp        ; restore stack
    sys_exit 0

; parse numbers from input 
parse_numbers:
    push rbp
    mov rbp, rsp
    push r12            ; save  register value because we will use it
    
    xor rbx, rbx        ; current number accumulator
    xor rcx, rcx        ; negative flag
    mov rsi, input      ; input pointer
    xor r15, r15        ; array index (count)
    
.next_char:
    mov al, [rsi]
    test al, al         ; check for null terminator
    jz .final_number
    inc rsi
    
    ; check for seperator 'space'
    cmp al, ' '         
    je .process_space
    
    ; check for negative
    cmp al, '-'
    je .set_negative
    
    ; validate digit (array of integer)
    cmp al, '0'
    jb .invalid_char
    cmp al, '9'
    ja .invalid_char
    
    ; add digit to number
    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    jmp .next_char

.set_negative:
    test rbx, rbx       ; only allow '-' at start
    jnz .invalid_char
    mov rcx, 1
    jmp .next_char

.process_space:
    test rbx, rbx       ; skip if no number accumulated
    jz .next_char
    
    ; apply sign if needed
    test rcx, rcx
    jz .store_number
    neg rbx
    
.store_number:
    ; check array bounds
    cmp r15, 100
    jge .array_full
    
    mov [array + r15*8], rbx
    inc r15
    
.reset:
    xor rbx, rbx        ;reset to handle next number
    xor rcx, rcx
    jmp .next_char

.final_number:
    test rbx, rbx       ;skip if no number
    jz .done
    
    ; apply sign if needed
    test rcx, rcx
    jz .store_final
    neg rbx
    
.store_final:
    cmp r15, 100
    jge .array_full
    
    mov [array + r15*8], rbx
    inc r15
    jmp .done

.array_full:
    ; continue without storing
    xor rbx, rbx
    xor rcx, rcx
    jmp .next_char

.invalid_char:
    ; skip to next space or terminator
    mov al, [rsi]
    test al, al
    jz .done
    inc rsi
    cmp al, ' '
    je .reset
    jmp .invalid_char

.done:
    mov [count], r15
    pop r12             ; restore saved register
    mov rsp, rbp
    pop rbp
    ret

; print the array
print_array:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    ; print opening bracket
    sys_write left_bracket, 1
    
    mov r12, [count]    ; get element count
    test r12, r12
    jz .empty_array
    mov r13, array      ; array pointer
    
.print_loop:
    ; convert number to string
    mov rdi, [r13]
    call int_to_str
    
    ; print the number
    sys_write num_buffer, rdx
    
    ; print comma if not last
    dec r12
    jz .end_print
    sys_write comma, 2
    
    add r13, 8 ;next num
    jmp .print_loop

.empty_array:
    sys_write right_bracket, 2
    jmp .done
    
.end_print:
    sys_write right_bracket, 2
    
.done:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret


; input: rdi
int_to_str:
    push rbp
    mov rbp, rsp
    push r12
    push r13
    
    mov rax, rdi
    lea r12, [num_buffer + 31]  ;end of buffer
    mov byte [r12], 0          ; null terminator
    mov r13, 10                ; divisor
    xor rcx, rcx               ; negative flag
    
    ; handle negatives
    test rax, rax
    jns .convert
    neg rax
    mov rcx, 1
    
.convert:
    xor rdx, rdx
    div r13             ; divide by 10
    add dl, '0'         ; convert to ASCII
    dec r12             ; move pointer
    mov [r12], dl       ; store digit
    test rax, rax       ; check if done
    jnz .convert
    
    ; add negative sign if needed
    test rcx, rcx
    jz .calculate_length
    dec r12
    mov byte [r12], '-'
    
.calculate_length:
    lea rdx, [num_buffer + 32]
    sub rdx, r12        ; rdx = string length
    
    cmp r12, num_buffer
    je .done
    xor rcx, rcx          ; clear index counter
.copy_loop:
    mov al, [r12 + rcx]     ; load byte from source
    mov [num_buffer + rcx], al  ; store to destination
    inc rcx               ; move to next byte
    cmp rcx, rdx          ; check if done
    jb .copy_loop         ; continue if not
.done:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret