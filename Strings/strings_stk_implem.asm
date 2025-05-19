; syscall string for read
%macro sys_read 1
    mov rax, 0          
    mov rdi, 0          
    mov rsi, %1         
    mov rdx, 100        
    syscall
%endmacro
; syscall string for write
%macro sys_write 2
    mov rax, 1          
    mov rdi, 1          
    mov rsi, %1         
    mov rdx, %2         
    syscall
%endmacro
; syscall for exit
%macro sys_exit 0
    mov rax, 60         
    xor rdi, rdi        
    syscall
%endmacro

section .data
    prompt db "Enter a string to reverse: ", 0
    prompt_len equ $ - prompt
    result db "Reversed: ", 0
    result_len equ $ - result
    newline db 10, 0

section .bss
    input resb 100      ; input to read the string 
    output resb 100     ; output to write the reversed string

section .text
    global _start

_start:
    ; display prompt
    sys_write prompt, prompt_len
    
    ; read input
    sys_read input
    
    ; reverse the string
    call reverse_string_stack
    
    ; display result
    sys_write result, result_len
    sys_write output, rcx           ; rcx contains len 
    sys_write newline, 1
    
    ; exit
    sys_exit

reverse_string_stack:
    ; find string len
    mov rsi, input
    xor rcx, rcx
.len_loop:
    cmp byte [rsi + rcx], 0
    je .end_len
    cmp byte [rsi + rcx], 10  ;  stop at newline
    je .end_len
    inc rcx
    jmp .len_loop
.end_len:
    
    ; push characters onto stack
    
    xor rbx, rbx ; to get chars

.push_loop:
    mov al, [input + rbx]
    push rax
    inc rbx
    cmp rbx, rcx
    jne .push_loop
    
    ; pop characters into output 

    xor rbx, rbx

.pop_loop:
    pop rax
    mov [output + rbx], al  ; bacause we will have a byte  
    inc rbx                 ; next char to move
    cmp rbx, rcx             ; end of string ? no continue yes skip
    jne .pop_loop
    
    ; null-terminate  output 
    mov byte [output + rbx], 0
    ret