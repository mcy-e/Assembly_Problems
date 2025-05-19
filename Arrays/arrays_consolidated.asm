; ===== Consolidated Array Operations in Assembly =====
; This file contains all array-related assembly functions

section .text
global sumArray
global findMax
global findMin
global isEmptyArray
global reverseArray
global sortArray

; ===== sumArray =====
; Calculates the sum of elements in an array
; Input: RDI - pointer to the array
;        RSI - number of elements
; Output: RAX - sum of elements
sumArray:
    push rbp
    mov rbp, rsp
    
    xor rax, rax        ; Initialize sum to 0
    
    test rsi, rsi       ; Check if array is empty
    jz .done            ; If empty, we're done
    
    xor rcx, rcx        ; Initialize counter to 0
    
.loop:
    add rax, [rdi + rcx*8] ; Add current element to sum
    inc rcx             ; Increment counter
    cmp rcx, rsi        ; Check if we've processed all elements
    jl .loop            ; If not, continue loop
    
.done:
    pop rbp
    ret

; ===== findMax =====
; Finds the maximum element in an array
; Input: RDI - pointer to the array
;        RSI - number of elements
; Output: RAX - maximum element
findMax:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; Check if array is empty
    jz .empty           ; If empty, return 0
    
    mov rax, [rdi]      ; Initialize max to first element
    cmp rsi, 1          ; Check if array has only one element
    je .done            ; If so, we're done
    
    mov rcx, 1          ; Start from second element
    
.loop:
    cmp [rdi + rcx*8], rax ; Compare current element with max
    jle .continue       ; If less or equal, continue
    
    mov rax, [rdi + rcx*8] ; Update max
    
.continue:
    inc rcx             ; Increment counter
    cmp rcx, rsi        ; Check if we've processed all elements
    jl .loop            ; If not, continue loop
    jmp .done
    
.empty:
    xor rax, rax        ; Return 0 for empty array
    
.done:
    pop rbp
    ret

; ===== findMin =====
; Finds the minimum element in an array
; Input: RDI - pointer to the array
;        RSI - number of elements
; Output: RAX - minimum element
findMin:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; Check if array is empty
    jz .empty           ; If empty, return 0
    
    mov rax, [rdi]      ; Initialize min to first element
    cmp rsi, 1          ; Check if array has only one element
    je .done            ; If so, we're done
    
    mov rcx, 1          ; Start from second element
    
.loop:
    cmp [rdi + rcx*8], rax ; Compare current element with min
    jge .continue       ; If greater or equal, continue
    
    mov rax, [rdi + rcx*8] ; Update min
    
.continue:
    inc rcx             ; Increment counter
    cmp rcx, rsi        ; Check if we've processed all elements
    jl .loop            ; If not, continue loop
    jmp .done
    
.empty:
    xor rax, rax        ; Return 0 for empty array
    
.done:
    pop rbp
    ret

; ===== isEmptyArray =====
; Checks if an array is empty
; Input: RSI - number of elements
; Output: RAX - 1 if empty, 0 if not empty
isEmptyArray:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; Check if number of elements is 0
    jz .empty           ; If 0, array is empty
    
    xor rax, rax        ; Not empty, return 0
    jmp .done
    
.empty:
    mov rax, 1          ; Empty, return 1
    
.done:
    pop rbp
    ret

; ===== reverseArray =====
; Reverses an array in-place
; Input: RDI - pointer to the array
;        RSI - number of elements
; Output: None (array is modified in-place)
reverseArray:
    push rbp
    mov rbp, rsp
    push rbx            ; Save rbx
    push r12            ; Save r12
    push r13            ; Save r13
    push r14            ; Save r14
    
    mov rbx, rdi        ; Store array pointer in rbx
    mov r12, rsi        ; Store number of elements in r12
    
    test r12, r12       ; Check if array is empty
    jz .done            ; If empty, we're done
    
    xor r13, r13        ; r13 = first element index (0)
    dec r12             ; r12 = last element index (n-1)
    
.loop:
    cmp r13, r12        ; Check if we've processed all elements
    jge .done           ; If so, we're done
    
    ; Swap elements at r13 and r12
    mov r14, [rbx + r13*8] ; r14 = first element
    mov rax, [rbx + r12*8] ; rax = last element
    mov [rbx + r13*8], rax ; first position = last element
    mov [rbx + r12*8], r14 ; last position = first element
    
    inc r13             ; Move first index forward
    dec r12             ; Move last index backward
    jmp .loop           ; Continue loop
    
.done:
    pop r14             ; Restore r14
    pop r13             ; Restore r13
    pop r12             ; Restore r12
    pop rbx             ; Restore rbx
    pop rbp
    ret

; ===== sortArray =====
; Sorts an array in ascending order (bubble sort)
; Input: RDI - pointer to the array
;        RSI - number of elements
; Output: None (array is modified in-place)
sortArray:
    push rbp
    mov rbp, rsp
    push rbx            ; Save rbx
    push r12            ; Save r12
    push r13            ; Save r13
    push r14            ; Save r14
    
    mov rbx, rdi        ; Store array pointer in rbx
    mov r12, rsi        ; Store number of elements in r12
    
    cmp r12, 1          ; Check if array has 0 or 1 element
    jle .done           ; If so, it's already sorted
    
    mov r13, 0          ; r13 = outer loop counter
    
.outer_loop:
    mov r14, 0          ; r14 = inner loop counter
    
.inner_loop:
    mov rax, [rbx + r14*8]       ; rax = current element
    mov rdx, [rbx + r14*8 + 8]   ; rdx = next element
    
    cmp rax, rdx        ; Compare current and next elements
    jle .continue       ; If current <= next, continue
    
    ; Swap elements
    mov [rbx + r14*8], rdx       ; current position = next element
    mov [rbx + r14*8 + 8], rax   ; next position = current element
    
.continue:
    inc r14             ; Increment inner loop counter
    mov rax, r12        ; rax = number of elements
    sub rax, r13        ; rax = number of elements - outer loop counter
    dec rax             ; rax = number of elements - outer loop counter - 1
    cmp r14, rax        ; Check if we've processed all elements in this pass
    jl .inner_loop      ; If not, continue inner loop
    
    inc r13             ; Increment outer loop counter
    cmp r13, r12        ; Check if we've done enough passes
    jl .outer_loop      ; If not, continue outer loop
    
.done:
    pop r14             ; Restore r14
    pop r13             ; Restore r13
    pop r12             ; Restore r12
    pop rbx             ; Restore rbx
    pop rbp
    ret
