; Macros for system calls

; syscall number for read
%macro read 1
    mov rax, 0          
    mov rdi, 0          
    mov rsi, %1         
    mov rdx, 100        
    syscall             
%endmacro
; syscall number for write
%macro write 2
    mov rax, 1          
    mov rdi, 1          
    mov rsi, %1         
    mov rdx, %2         
    syscall             
%endmacro
; syscall number for exit
%macro exit 0
    mov rax, 60         
    xor rdi, rdi        
    syscall             
%endmacro

section .data
    prompt db " This file is for reverse string function :  ", 0xA
    len_prompt equ $ - prompt

    greeting db "Welcome! ", 0xA
    len_greeting equ $ - greeting

    input db " enter a string you want to reverse : ", 0xA
    len_input equ $ - input

    result db "result = ",0
    len_res equ $ - result

    buffer times 100 db 0    ; input 
    reversed times 100 db 0  ; output  for reversed string

section .text
    global _start

_start:
    ; display greeting 
    write greeting, len_greeting
    
    ; display prompt
    write prompt, len_prompt
    
    ; display input request to read input
    write input, len_input
    
    ; read  input
    read buffer
    
    ; reverse the string
    call reverse_str
    
    ; display result label
    write result, len_res
    
    ; display reversed string (len in rcx) 
    write reversed, rcx
    
    ; exit program
    exit

reverse_str:
    push rbp            ; save base pointer
    mov rbp, rsp        ; set new base pointer
    
    ; calculate string len first
    mov rsi, buffer     ; point to input string
    xor rcx, rcx        ; len counter
    
.length_loop:
    cmp byte [rsi + rcx], 0 ; check for null 
    je .end_length
    inc rcx             ; inc len counter
    jmp .length_loop
    
.end_length:
    ; rcx has string len    
    
    test rcx, rcx       ; check for empty string
    jz .done
    
    ; push characters onto stack
    
    xor rbx, rbx        ; index

.push_loop:
    movzx rax, byte [buffer + rbx] ; load char
    push rax            ; push onto stack
    inc rbx             ; move to next character
    cmp rbx, rcx        ; check if done
    jne .push_loop
    
    ; pop chars from stack into reversed
    
    xor rbx, rbx        ; reset index

.pop_loop:
    pop rax             ; pop character from stack
    mov byte [reversed + rbx], al ; store in reversed buffer
    inc rbx             ; move to next position
    cmp rbx, rcx        ; check if done
    jne .pop_loop
    
    ; null-terminate the reversed string
    mov byte [reversed + rbx], 0
    
.done:
    mov rsp, rbp        ; restore stack pointer
    pop rbp             ; restore base pointer
    ret                 ; return (rcx still has len)