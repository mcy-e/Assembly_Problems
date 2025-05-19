; macros for system calls

; syscall number for read
%macro read 1
    mov rax, 0          
    mov rdi, 0         
    mov rsi, %1        
    mov rdx, 512       
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
    xor rdi, rdi        ; exit code 0
    syscall             
%endmacro

%macro print_array 0
    xor rbx, rbx        ; first array index is  0
    write left, 1       ; Print opening bracket '['
    
.print_loop:
    cmp rbx, [count]    ; check if we processed all elements
    je .done
    
    ; print current number
    
    mov rdi, [array + rbx*8]    ; load number from array
    call int_to_str             ; convert to string (result in rsi, len in r8)
    write rsi, r8               ; print the number string
    
    ; print comma if not last element
    
    inc rbx             ; move to next index
    cmp rbx, [count]    ; check if this was the last element
    je .no_comma
    write comma, 1      ; print comma separator
    
.no_comma:
    jmp .print_loop     ; continue with next element
    
.done:
    write right, 2      ; print closing bracket "]" and newline
%endmacro

section .data
    msg db "Enter numbers separated by spaces ' ', press 'Enter' to finish:", 0xA
    len_msg equ $-msg
    comma db ',',0      ; comma to separate
    
    left db "[",0       ; left bracket
    right db "]",0xA    ; right bracket and newline

section .bss
    input_buffer resb 512   ; buffer for user input
    array resq 100      ; array to store numbers 8 bytes (64-bit)
    count resq 1        ; number of elements in array ie size
    buffer resb 100     ; buffer to hold the converted string

section .text
    global _start

_start:
    ; display  message
    write msg, len_msg
    
    ; read  input
    read input_buffer
    
    ; convert input string to array of numbers
    call toArray
    
    ; print the array
    print_array
    
    ; exit program
    exit

toArray:
    xor rbx, rbx        ; array index (starts at 0)
    xor rdi, rdi        ; holder for current number
    xor r9, r9          ; parsing flag (0 = not parsing, 1 = parsing) to see if we have  a number to save
    mov r10, 1          ; sign multiplier (1 = positive, -1 = negative)
    lea rsi, [input_buffer] ; pointer to input string

.next_char:
    mov al, [rsi]       ; load next character
    inc rsi             ; move to next character
    cmp al, 0xA         ; check for newline 
    je .save_last       ; if newline save last number and exit

    cmp al, '-'         ; check for negative sign
    je .negative_sign

    cmp al, ' '         ; check for space separator
    je .save_number     ; if space save current number

    ; build number: rdi = rdi * 10 + (al - '0')
    sub al, '0'         ; convert ASCII to digit
    imul rdi, rdi, 10   ; multiply current number by 10
    add rdi, rax        ; add new digit
    mov r9, 1           ; set parsing flag
    jmp .next_char      ; process next character

.negative_sign:
    mov r10, -1         ; set sign to negative we could also use neg
    jmp .next_char

.save_number:
    cmp r9, 1           ; check if we were parsing a number which means we have a number to save
    jne .skip_space     ; else skip
    
    imul rdi, r10               ; apply sign to number
    mov [array + rbx*8], rdi    ; store in array
    inc rbx                     ; increment array index
    
.skip_space:
    xor rdi, rdi        ; reset number holder
    mov r10, 1          ; reset sign to positive
    xor r9, r9          ; reset parsing flag
    jmp .next_char      ; process next character

.save_last:
    cmp r9, 1           ; check if we have a final number to save
    jne .store_count    ; skip if not
    
    imul rdi, r10               ; apply sign to last number
    mov [array + rbx*8], rdi    ; store in array
    inc rbx                     ; increment array index
    
.store_count:
    mov [count], rbx    ; store array size
    ret




int_to_str:

    ;rsi = string pointer || r8 = string len

    mov rax, rdi        ; move number to rax for division
    lea rsi, [buffer + 99] ; point to end of buffer
    mov byte [rsi], 0   ; null-terminate the string
    mov rcx, 10         ; holde 10 for devision
    xor r8, r8          ; initialize len counter

    ; handle negatives 
    test rax, rax
    jns .convert        ; skip if positive
    neg rax             ; make number positive (for devision and conversion)
    

.convert:
    xor rdx, rdx        ; clear at every iterarion to save a naw digit
    div rcx             ; divide rax by 10 (rdx = remainder)
    add dl, '0'         ; convert remainder to ASCII
    dec rsi             ; move buffer pointer backward
    mov [rsi], dl       ; store digit
    inc r8              ; increment len counter
    test rax, rax       ; check if rax  is zero
    jnz .convert        ; Continue if not

    ; if negative, add '-'
    cmp rdi, 0
    jge .done
    dec rsi             ; move back to add '-'
    mov byte [rsi], '-'
    inc r8              ;increament the len
    
.done:
    mov rdi, rsi        ; return pointer to start of string
    ret