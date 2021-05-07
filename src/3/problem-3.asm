extern exit
extern printf

global _start
    
section .text

_start:
    mov ebp, esp
    push 2
.loop:
    inc	    dword [ebp]
    push	dword [ebp]
    push	dword 100
    call	isDivisible
    push	edx
    call	debug
    sub     esp, 12
    jmp     .loop

    push	0
    call	exit

isDivisible:
    enter	0, 0
    xor	    edx, edx
    mov     eax, [ebp + 8]
    div     dword [ebp + 12]
    test	edx, edx
    leave
    ret

print:
    enter	8, 0
    push	dword [ebp + 8]
    push	format
    call	printf
    leave
    ret

debug:
    enter   0, 0
    push	dword [ebp + 8]
    push	dword [ebp + 12]
    push	dword [ebp + 16]    
    push	dbgFormat
    call	printf
    leave
    ret
    

section .data
    format db `%d\n`, 0
    dbgFormat db `(%d, %d): (%d)\n`, 0

