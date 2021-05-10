; RDI, RSI, RDX, RCX, R8, and R9 -> RAX, RDX
; XMM0 to XMM7 -> XMM0, XMM1
default rel

global    main
extern    printf, snprintf, strlen

%define true 1
%define false 0

%assign strlength 2
%assign minvalue 10
%assign maxvalue 99
%assign buffersize 16

%macro enter 0-1 0
    enter %1, 0
%endmacro

%macro reset 0-1 0
    mov esp, ebp + %1
%endmacro

%macro ccall 1
    call %1 wrt ..plt
%endmacro

%macro return 0
    leave
    ret
%endmacro

%macro return 1
    mov rax, %1
    leave
    ret
%endmacro

%macro return 2
    mov rdx, %2
    mov rax, %1
    leave
    ret
%endmacro

section   .text
main:
    call largestpalindrome
    mov rdi, fmt
    mov rsi, rax
    mov rax,  0
    call printf wrt ..plt
    ret

largestpalindrome:
    enter
    mov rdi, 111
    call ispalindrome
    return


ispalindrome:
%push
%stacksize flat64
%assign %$localsize 0
%local lo:qword, hi:qword
    enter 0x10
    mov  r13, rdi
    call length
    mov  r8, qword 0
    mov  [lo],  r8
    mov  [hi], rax
    dec  qword [hi]
    mov  rdi, r13
    call stringify
.loop:
    mov    rax, [lo]
    mov    rbx, [hi]
    cmp    rax, rbx
    jge    .succeed
    mov    r9, buffer
    movzx  rcx, byte [r9 + rax]
    movzx  rdx, byte [r9 + rbx]
    cmp    rcx, rdx
    jne    .fail
    inc    qword [lo]
    dec    qword [hi]
    jmp    .loop
.succeed:
    return true
.fail:
    return false


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
