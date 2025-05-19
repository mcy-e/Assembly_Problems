; ===== Consolidated String Operations in Assembly =====
; This file contains all string-related assembly functions

section .text
global stringLength
global isEmptyString
global reverseString
global concatenateStrings

; ===== stringLength =====
; Calculates the length of a null-terminated string
; Input: RDI - pointer to the string
; Output: RAX - length of the string
stringLength:
    xor rax, rax        ; Initialize counter to 0
    
.loop:
    cmp byte [rdi + rax], 0  ; Check if current character is null terminator
    je .done            ; If null terminator, we're done
    inc rax             ; Increment counter
    jmp .loop           ; Continue loop
    
.done:
    ret

; ===== isEmptyString =====
; Checks if a string is empty (length 0)
; Input: RDI - pointer to the string
; Output: RAX - 1 if empty, 0 if not empty
isEmptyString:
    cmp byte [rdi], 0   ; Check if first character is null terminator
    sete al             ; Set AL to 1 if equal (empty), 0 otherwise
    movzx rax, al       ; Zero-extend AL to RAX
    ret

; ===== reverseString =====
; Reverses a string in-place
; Input: RDI - pointer to the string
; Output: None (string is modified in-place)
; ===== reverseString (stack version) =====
; Reverses a string in-place using a stack
; Input: RDI - pointer to the string
; Output: None (string is modified in-place)
reverseString:
    push rbx            ; Save callee-saved register
    mov rbx, rdi        ; Save original string pointer
    
    ; First, push all characters onto the stack
    xor rcx, rcx        ; RCX will be our length counter
.push_loop:
    mov al, [rdi]       ; Load current character
    test al, al         ; Check for null terminator
    jz .pop_loop_setup  ; If null, start popping
    
    push rax            ; Push character onto stack (using full register)
    inc rdi             ; Move to next character
    inc rcx             ; Increment length counter
    jmp .push_loop
    
.pop_loop_setup:
    mov rdi, rbx        ; Reset pointer to start of string
    
.pop_loop:
    test rcx, rcx       ; Check if we've processed all characters
    jz .done            ; If counter is zero, we're done
    
    pop rax             ; Pop character from stack
    mov [rdi], al       ; Store character back to string
    inc rdi             ; Move to next position
    dec rcx             ; Decrement counter
    jmp .pop_loop
    
.done:
    pop rbx             ; Restore callee-saved register
    ret
; ===== concatenateStrings =====
; Concatenates two strings
; Input: RDI - pointer to destination string (must have enough space)
;        RSI - pointer to source string
; Output: None (destination string is modified)
concatenateStrings:
    push rbx            ; Save rbx (callee-saved)
    
    mov rbx, rdi        ; Store destination pointer in rbx
    
    ; Find end of destination string
    call stringLength
    add rbx, rax        ; rbx now points to the null terminator of destination
    
    ; Copy source string to the end of destination
.loop:
    mov al, [rsi]       ; Load character from source
    mov [rbx], al       ; Store character to destination
    
    test al, al         ; Check if we copied the null terminator
    jz .done            ; If so, we're done
    
    inc rbx             ; Move destination pointer
    inc rsi             ; Move source pointer
    jmp .loop           ; Continue loop
    
.done:
    pop rbx             ; Restore rbx
    ret