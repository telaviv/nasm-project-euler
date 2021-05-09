; RDI, RSI, RDX, RCX, R8, and R9 -> RAX, RDX
; XMM0 to XMM7 -> XMM0, XMM1
default rel

global    main
extern    printf

section   .text
main:
    mov rbp, rsp
    mov r12, 1
.loop:
    mov  rsp, rbp
    inc  r12
    mov  rdi, r12
    call isprime
    mov  rdi, format
    mov  rsi, r12
    mov  rdx, rax
    mov  rax, 0
    call printf wrt ..plt
    jmp  .loop

isprime:
    push rbp
    mov  rbp, rsp
    mov  rcx, rdi
    shr  rcx, 1
    mov  rbx, 1
.loop:
    inc  rbx
    cmp  rbx, rcx
    jg	 .isprime
    xor  rdx, rdx
    mov  rax, rdi
    div  rbx
    cmp  rdx, 0
    je   .isnotprime
    jmp  .loop
.isprime:
    mov  rax, 1
    jmp  .finish
.isnotprime:
    mov  rax, 0
.finish:
    mov rbp, rsp
    pop rbp
    ret


section .data
message:
    format    db `%u: %u\n`, 0
