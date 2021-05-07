extern exit
extern printf

global _start

section .text

_start:
    push dword 0
    push dword 1
    mov ebx, 0  ; sum of evens
    
fib:
    call debug
    mov eax, [esp]
    add eax, [esp + 4]
    cmp eax,4000000
    jg print
    test eax, 1
    jnz next
    add ebx, eax

next:
    mov ecx, [esp]
    mov [esp + 4], ecx
    mov [esp], eax
    jmp fib

debug:
    mov ebp, esp
    mov ecx, [esp + 4]
    mov edx, [esp + 8]
    push	ebx
    push	eax
    push	ecx
    push	edx
    push	dbgFormat
    call	printf
    mov esp, ebp
    ret

print:
    push ebx
    push format
    call printf

    push 0
    call exit

section .data
    format db `%d\n`, 0
    dbgFormat db `(%d, %d): %d, %d\n`, 0
    fibStr db `fib`
    debugStr db `debug`
