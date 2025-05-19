; ===== Consolidated String Operations in Assembly =====
; This file contains all string-related assembly functions

section .text
global stringLength
global isEmptyString
global reverseString
global concatenateStrings

stringLength:
    xor rax, rax        ; initialize counter to 0
    
.loop:
    cmp byte [rdi + rax], 0   ; check if current character is null 
    je .done            ; if null  done
    inc rax             ; increment counter
    jmp .loop           ; continue loop
    
.done:
    ret

isEmptyString:
    cmp byte [rdi], 0   ; check if first character is null terminator
    je .true
    xor rax,rax
    ret
.true:
    mov rax,1
    ret
reverseString:
    push rbx            ; save  register
    mov rbx, rdi        ; save original string pointer
    
    ; push all chars onto the stack
    xor rcx, rcx        ; RCX will be our len counter
.push_loop:
    mov al, [rdi]       ; load current char
    test al, al         ; check for null 
    jz .pop_loop_setup  ; if null start popping
    
    push rax            ; push character onto stack (using full register)
    inc rdi             ; move to next character
    inc rcx             ; increment length counter
    jmp .push_loop
    
.pop_loop_setup:
    mov rdi, rbx        ; reset pointer to start of string
    
.pop_loop:
    test rcx, rcx       ; check if we processed all chars
    jz .done            ; if counter is zero we are done
    
    pop rax             ; pop character from stack
    mov [rdi], al       ; store character back to string
    inc rdi             ; move to next position
    dec rcx             ; decrement counter
    jmp .pop_loop
    
.done:
    pop rbx             ; restore registers
    ret
concatenateStrings:
    push rbx            ; save 
    
    mov rbx, rdi        ; store destination pointer in rbx
    
    ; find end of destination string
    call stringLength
    add rbx, rax        ; rbx now points to the null terminator of destination
    
    ; copy source string to the end of destination
.loop:
    mov al, [rsi]       ; load character from source
    mov [rbx], al       ; store character to destination
    
    test al, al         ; check if we copied the null terminator
    jz .done            ; if so we are done
    
    inc rbx             ; move destination pointer
    inc rsi             ; move source pointer
    jmp .loop           ; continue loop
    
.done:
    pop rbx             ; restore rbx
    ret