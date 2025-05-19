
; syscall number for write
%macro sys_write 2
    mov rax, 1
    mov rdi, 1
    mov rsi, %1
    mov rdx, %2
    syscall
%endmacro

; syscall number for read
%macro sys_read 1
    mov rax, 0
    mov rdi, 0
    mov rsi, %1
    mov rdx, 100
    syscall
%endmacro
; syscall number for exit
%macro sys_exit 0
    mov rax, 60
    xor rdi, rdi
    syscall
%endmacro

section .data 
    prompt db "Enter a number : ", 0XA
    len equ $-prompt
    result db "Reversed: ", 0
   

section .bss
    input resb 100      ;input to read 
    output resb 100     ; output to write

section .text
    global _start

_start:
    ; display prompt
    sys_write prompt,len

    ; read input
    sys_read input
    
    ; convert string to number
    call str_to_int      
    
    ; result in rax
    
    ; reverse the number
    call reverse_num
    
    ; convert back to string
    
    mov rsi, output ;rsi point to start of the output
    
    call int_to_str      
    
    ; len in rdx
    
    ; display result
    sys_write result, 9

    sys_write output, rdx
    
    
    ; exit
    sys_exit

str_to_int:
    xor rax, rax        ; clear result
    mov rsi, input      ; input pointer
    mov rbx, 10         ; divisor
    xor rcx, rcx        ; negative flag
    
    ; check for sign
    cmp byte [rsi], '-'
    jne .convert
    inc rsi
    inc rcx
    
.convert:
    movzx rdx, byte [rsi]
    cmp rdx, 10         ; check for newline
    je .done
    cmp rdx, 0          ;check for null
    je .done
    sub rdx, '0'        ;make it an integer
    imul rax, rbx       ; rax = rax*rbx +rdx ie result = result*10 + digit
    add rax, rdx
    inc rsi             ; jump to next digit in the string
    jmp .convert
    
.done:
    test rcx, rcx   ;check if its negative or not
    jz .positive
    neg rax
.positive:
    ret


reverse_num:
    xor rcx, rcx        ; rcx will have the reversed number
    mov rbx, 10         ; divisor
    xor r8, r8          ; negative flag (0 = positive, 1 = negative)
    
    test rax, rax       ;check for negative
    jns .reverse_loop
    neg rax
    inc r8              ; ensure its negative
    
.reverse_loop:
    xor rdx, rdx
    div rbx             ; divide by 10 ie rax=rax/10
    imul rcx, rcx, rbx   ; rcx=rcx*10 +rdx
    add rcx, rdx        ; add remainder
    test rax, rax       ; check if done
    jnz .reverse_loop
    
    mov rax, rcx        ; move result to rax
    test r8, r8         ; check negative flag
    jz .done
    neg rax
    
.done:
    ret


int_to_str:
    mov rdi, rsi        ; save output pointer
    mov rbx, 10         ; divisor
    xor rcx, rcx        ; digit counter
    xor r8, r8          ; negative flag
    test rax, rax
    jns .convert
    neg rax
    inc r8
    
.convert:
    xor rdx, rdx
    div rbx             ; divide by 10
    add dl, '0'         ; convert to ASCII
    push rdx            ; push digit
    inc rcx             ; increment count used in loop
    test rax, rax       ; check if done
    jnz .convert
    
    ; handle negative sign
    test r8, r8
    jz .store
    mov byte [rdi], '-'
    inc rdi
    
.store:
    pop rax
    mov [rdi], al       ; store digit
    inc rdi
    loop .store         ; done if rcx=0
    
    ; calculate len
    mov rdx, rdi
    sub rdx, rsi
    mov byte [rdi], 0   ; null terminate
    ret