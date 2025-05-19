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
    push rbp
    mov rbp, rsp
    
    xor rax, rax        ; Initialize counter to 0
    
.loop:
    cmp byte [rdi + rax], 0  ; Check if current character is null terminator
    je .done            ; If null terminator, we're done
    inc rax             ; Increment counter
    jmp .loop           ; Continue loop
    
.done:
    pop rbp
    ret

; ===== isEmptyString =====
; Checks if a string is empty (length 0)
; Input: RDI - pointer to the string
; Output: RAX - 1 if empty, 0 if not empty
isEmptyString:
    push rbp
    mov rbp, rsp
    
    cmp byte [rdi], 0   ; Check if first character is null terminator
    je .empty           ; If null terminator, string is empty
    
    xor rax, rax        ; Not empty, return 0
    jmp .done
    
.empty:
    mov rax, 1          ; Empty, return 1
    
.done:
    pop rbp
    ret

; ===== reverseString =====
; Reverses a string in-place
; Input: RDI - pointer to the string
; Output: None (string is modified in-place)
reverseString:
    push rbp
    mov rbp, rsp
    push rbx            ; Save rbx
    push r12            ; Save r12
    push r13            ; Save r13
    
    mov rbx, rdi        ; Store string pointer in rbx
    
    ; Calculate string length
    call stringLength
    mov r12, rax        ; r12 = string length
    
    test r12, r12       ; Check if string is empty
    jz .done            ; If empty, we're done
    
    dec r12             ; r12 = last character index
    xor r13, r13        ; r13 = first character index (0)
    
.loop:
    cmp r13, r12        ; Check if we've processed all characters
    jge .done           ; If so, we're done
    
    ; Swap characters at r13 and r12
    mov al, [rbx + r13] ; al = first character
    mov ah, [rbx + r12] ; ah = last character
    mov [rbx + r13], ah ; first position = last character
    mov [rbx + r12], al ; last position = first character
    
    inc r13             ; Move first index forward
    dec r12             ; Move last index backward
    jmp .loop           ; Continue loop
    
.done:
    pop r13             ; Restore r13
    pop r12             ; Restore r12
    pop rbx             ; Restore rbx
    pop rbp
    ret

; ===== concatenateStrings =====
; Concatenates two strings
; Input: RDI - pointer to destination string (must have enough space)
;        RSI - pointer to source string
; Output: None (destination string is modified)
concatenateStrings:
    push rbp
    mov rbp, rsp
    push rbx            ; Save rbx
    push r12            ; Save r12
    
    mov rbx, rdi        ; Store destination pointer in rbx
    mov r12, rsi        ; Store source pointer in r12
    
    ; Find end of destination string
    call stringLength
    add rbx, rax        ; rbx now points to the null terminator of destination
    
    ; Copy source string to the end of destination
.loop:
    mov al, [r12]       ; Load character from source
    mov [rbx], al       ; Store character to destination
    
    test al, al         ; Check if we copied the null terminator
    jz .done            ; If so, we're done
    
    inc rbx             ; Move destination pointer
    inc r12             ; Move source pointer
    jmp .loop           ; Continue loop
    
.done:
    pop r12             ; Restore r12
    pop rbx             ; Restore rbx
    pop rbp
    ret
