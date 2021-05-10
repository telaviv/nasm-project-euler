; RDI, RSI, RDX, RCX, R8, and R9 -> RAX, RDX
; XMM0 to XMM7 -> XMM0, XMM1
default rel

global    main
extern    printf, snprintf, strlen

%define true 1
%define false 0

%assign strlength 2
%assign buffersize 16

%macro enter 0
    enter 0, 0
%endmacro

%macro reset 0-1 0
    mov esp, ebp + $1
%endmacro

%macro ccall 1
    call $1 wrt ..plt
%endmacro

%macro return 0
    leave
    ret
%endmacro

%macro return 1
    mov rax, $1
    return
%endmacro

%macro return 2
    mov rdx, $2
    return $1
%endmacro

section   .text
main:
    mov r12, 0
.loop:
    inc r12
    mov rdi, r12
    call length
    mov rdi, dbgfmt
    mov rsi, r12
    mov rdx, rax
    mov rax,  0
    call printf wrt ..plt
    jmp .loop

length:
    enter
    call  stringify
    mov   rdi, buffer
    call  strlen wrt ..plt
    return

stringify:
    enter
    mov   rax,  0
    push  0                     ; i have no idea why this is necessary
    mov   rcx, rdi
    mov   rdi, buffer
    mov   rsi, buffersize
    mov   rdx, fmt
    call  snprintf wrt ..plt
    return

section .data
    fmt    db `%u`, 0
    dbgfmt db `%u: %u\n`, 0

section .bss
    alignb 16
    buffer resb buffersize
