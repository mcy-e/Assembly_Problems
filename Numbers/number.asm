; syscall number for read
%macro read 1
    mov rax,0        
    mov rdi,0        
    mov rsi,%1       
    mov rdx,100          
    syscall         
%endmacro

; syscall number for write
%macro write 2
    mov rax,1        
    mov rdi,1        
    mov rsi,%1       
    mov rdx,%2       
    syscall          
%endmacro
; syscall number for exit
%macro exit 0
    mov rax,60       
    xor rdi,rdi      ; exit code 0
    syscall          
%endmacro

section .data
    prompt db " This file is for reverse number function :  ", 0xA
    len_prompt equ $ - prompt

    greeting db "Welcome! ", 0xA
    len_greeting equ $ - greeting

    input db " enter a number you want to reverse : ", 0xA
    len_input equ $ - input

    result db "result = ",0
    len_res equ $ - result

    buffer times 100 db 0  ; buffer to store entered string 

section .text
    global _start 

_start:
    ; example : reverse -15 and print result
    mov rax,-15       ; load number to reverse
    call reverse      ; call reverse function (result in rax)
    call int_to_str   ; convert result to string (stored in buffer)
    write result, len_res  ; print 'result = '
    call strlen         ; get length of string in buffer (result in rdx)
    write buffer, rdx   ; print the reversed number
    exit                ; exit program

reverse:
    xor r11,r11       ; sign flag (0 = positive, 1 = negative)
    xor rcx,rcx       ; clear rcx (will store reversed number)
    mov rbx,10        ; divisor  
    test rax,rax      ; test if number is negative
    js .positiveIt    ; if so jump to make it positive
    jmp .rev          ; else start reversing

.positiveIt:
    neg rax           ; make number positive
    inc r11           ; set sign flag 

.rev:
    xor rdx,rdx       ; clear every iteration to hold  digits
    div rbx           ; divide rax by 10 (rdx = remainder)
    imul rcx,rbx      ; multiply current reversed number by 10
    add rcx,rdx       ; add remainder to reversed number
    cmp rax,0         ; check if rax is zero which means we are done
    jnz .rev          ; if not continue 
    test r11,r11      ; check original sign
    jnz .retneg       ; if it was negative we negate it
    xor rax,rax       ; clear rax to hold result
    mov rax,rcx       ; move result to rax
    ret               

.retneg:
    neg rcx           ; negate the result
    xor rax,rax       ; clear rax to hold result
    mov rax,rcx       ; move result to rax
    ret               


int_to_str:
    mov rcx, buffer   ; point to start of buffer
    cmp rax, 0        ; check if number is negative
    jge convert       ; if positive skip
    mov byte [rcx], '-' ; add minus sign
    inc rcx           ; move buffer pointer forward
    neg rax           ; make number positive

convert:
    mov rbx, 10       ; divisor
    lea rsi, [rcx + 99] ; point to end of buffer 
   
.loop:
    xor rdx, rdx      ; clclear every iteration to hold  digits
    div rbx           ; divide by 10 (rdx = reminder)
    add dl, '0'       ; convert digit to ASCII
    dec rsi           ; move pointer backward
    mov [rsi], dl     ; store ASCII digit
    test rax, rax     ; check if rax is zero
    jnz .loop         ; if not continue

.copy:
    mov al, [rsi]     ; copy digit from temporary position
    mov [rcx], al     ; to final position in buffer
    inc rsi           ; advance source pointer
    inc rcx           ; advance destination pointer
    cmp al, 0         ; check for null 
    jne .copy         ; continue if not n
    mov byte [rcx], 0 ; ensure adding null     
    ret

strlen:
    mov rsi, buffer   ; point to start of buffer
    xor rdx, rdx      ; clear length counter
.loop:
    cmp byte [rsi + rdx], 0 ; check for null terminator
    je .done          ; if found we're done :)
    inc rdx           ; else increment len
    jmp .loop         ; loop
.done:
    ret               ; return len in rdx