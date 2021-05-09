; RDI, RSI, RDX, RCX, R8, and R9 -> RAX, RDX
; XMM0 to XMM7 -> XMM0, XMM1
default rel

global    main
extern    printf

section   .text
main:
    mov rdi, 600851475143
    call maxprimefactor
    mov  rdi, format
    mov  rsi, 600851475143
    mov  rdx, rax
    mov  rax, 0
    call printf wrt ..plt
    ret

maxprimefactor:
    push rbp
    mov  rbp, rsp
    push rdi
    shr  rdi, 1
    push rdi
    mov  r13, 1
    mov  r14, 0
.loop:
    inc   r13,
    cmp   r13, [rbp - 0x10]
    jg    .finish
    xor	  rdx, rdx
    mov   rax, [rbp - 0x8]
    div   r13
    cmp   rdx, 0
    jne	  .loop
    mov   rdi, r13
    call  isprime
    cmp   rax, 1
    cmove r14, r13
    jmp   .loop
.finish:
    mov rax, r14
    mov rsp, rbp
    pop rbp
    ret

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
