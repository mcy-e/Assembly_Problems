
section .text
global sumArray
global findMax
global findMin
global isEmptyArray
global reverseArray
global sortArray

sumArray:
    push rbp
    mov rbp, rsp
    
    xor rax, rax        ; initialize sum to 0
    
    test rsi, rsi       ; check if array is empty
    jz .done            ; if empty we are done
    
    xor rcx, rcx        ; initialize counter to 0
    
.loop:
    add rax, [rdi + rcx*8]  ; add current element to sum
    inc rcx                 ; increment counter
    cmp rcx, rsi            ; check if we have processed all elements
    jl .loop                ; if not continue loop
    
.done:
    pop rbp
    ret

findMax:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; check if array is empty
    jz .empty           ; if empty return 0
    
    mov rax, [rdi]      ; initialize max to first element
    cmp rsi, 1          ; check if array has only one element
    je .done            ; if so  done
    
    mov rcx, 1          ; Start from second element
    
.loop:
    cmp [rdi + rcx*8], rax ; compare current element with max
    jle .continue       ; if less or equal continue
    
    mov rax, [rdi + rcx*8] ; update max
    
.continue:
    inc rcx             ; increment counter
    cmp rcx, rsi        ; check if we processed all elements
    jl .loop            ; If not loop
    jmp .done
    
.empty:
    xor rax, rax        ; Return 0 for empty array
    
.done:
    pop rbp
    ret

findMin:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; check if array is empty
    jz .empty           ; if empty return 0
    
    mov rax, [rdi]      ; initialize min to first element
    cmp rsi, 1          ; check if array has only one element
    je .done            ; if so we are done
    
    mov rcx, 1          ; start from second element
    
.loop:
    cmp [rdi + rcx*8], rax ; compare current element with min
    jge .continue       ; if greater or equal continue
    
    mov rax, [rdi + rcx*8] ; update min
    
.continue:
    inc rcx             ; increment counter
    cmp rcx, rsi        ; check if we've processed all elements
    jl .loop            ; if not, continue loop
    jmp .done
    
.empty:
    xor rax, rax        ; return 0 for empty array
    
.done:
    pop rbp
    ret

isEmptyArray:
    push rbp
    mov rbp, rsp
    
    test rsi, rsi       ; check if number of elements is 0
    jz .empty           ; if 0 array is empty
    
    xor rax, rax        ; Not empty return 0
    jmp .done
    
.empty:
    mov rax, 1          ; Empty return 1
    
.done:
    pop rbp
    ret

reverseArray:
    push rbp
    mov rbp, rsp
    push rbx            ; save rbx
    push r12            ; save r12
    push r13            ; save r13
    push r14            ; save r14
    
    mov rbx, rdi        ; store array pointer in rbx
    mov r12, rsi        ; store number of elements in r12
    
    test r12, r12       ; check if array is empty
    jz .done            ; if empty we are done
    
    xor r13, r13        ; r13 => first elem 
    dec r12             ; r12 => last elem  
    
.loop:
    cmp r13, r12        ; check if we have processed all elems
    jge .done           ; if so we are done
    
    ; swap elements at r13 and r12
    mov r14, [rbx + r13*8] ;    r14 => first elem
    mov rax, [rbx + r12*8] ;    rax => last elem
    mov [rbx + r13*8], rax ;    first pos => last elem
    mov [rbx + r12*8], r14 ;    last pos => first elem
    
    inc r13             ; Move first index forward
    dec r12             ; Move last index backward
    jmp .loop           ; Continue loop
    
.done:
    pop r14             ; restore registers
    pop r13             
    pop r12             
    pop rbx             
    pop rbp
    ret

sortArray:
    push rbp
    mov rbp, rsp         ; save registers
    push rbx            
    push r12            
    push r13            
    push r14            
    
    mov rbx, rdi        ; store array pointer in rbx
    mov r12, rsi        ; store number of elements in r12
    
    cmp r12, 1          ; check if array has 0 or 1 element
    jle .done           ; if so it is  sorted
    
    mov r13, 0          ; r13 => outer loop counter (first for)
    
.outer_loop:
    mov r14, 0          ; r14 => inner loop counter (second for)
    
.inner_loop:
    mov rax, [rbx + r14*8]       ; current elem
    mov rdx, [rbx + r14*8 + 8]   ; next elem
    
    cmp rax, rdx        ; compare current and next elems
    jle .continue       ; if current <= next continue
    
    ;swap elems
    
    mov [rbx + r14*8], rdx       ; current position = next element
    mov [rbx + r14*8 + 8], rax   ; next position = current element
    
.continue:
    inc r14             ; increment inner loop counter
    mov rax, r12        
    sub rax, r13     
    dec rax             ; rax = number of elements - outer loop counter - 1
    cmp r14, rax        ; check if we processed all elems
    jl .inner_loop      ; if not continue inner loop
    
    inc r13             ; Increment outer loop counter
    cmp r13, r12        ; Check if we've done enough passes
    jl .outer_loop      ; if not continue outer loop
    
.done:
    pop r14             ; restore registers
    pop r13             
    pop r12             
    pop rbx             
    pop rbp
    ret
