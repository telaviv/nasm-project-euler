extern exit
extern printf

global _start
    
section .text

_start:
    push	3
    mov     ebp, esp
.loop:
    inc	    dword [esp]
    call    largestPrimeFactor
    push	eax
    call	debug
    mov     esp, ebp
    jmp     .loop

    push	0
    call	exit

largestPrimeFactor:
%push mycontext
%stacksize flat
%arg value:dword
%assign %$localsize 0 
%local i:dword, largest:dword
    enter	%$localsize, 0
    mov [i], dword 1
    mov [largest], dword 0
.loop:                           
    inc     dword [i]
    mov     ecx, [i]
    cmp     ecx, [value]
    je      .finish
    push	dword [i]
    push	dword [value]
    call	isDivisible
    cmp	    eax, 0
    jne     .loop
    push	dword [i]
    call	isPrime
    cmp     eax, 1
    jne     .loop
    mov     ecx, [i]
    mov     [largest], ecx
    jmp     .loop
.finish:
    mov     eax, [largest]
    leave
    ret
    

isPrime:
    enter	0, 0
    mov     edi, [ebp + 8]
    mov     ecx, 1
.loop:                           
    inc     ecx
    cmp     ecx, edi
    je      .succeed
    push	ecx
    push	edi
    call	isDivisible
    cmp	eax, 0
    je .fail
    sub esp, 8
    jmp .loop
.fail:
    mov eax, 0
    jmp .end
.succeed:
    mov eax, 1
    jmp .end
.end:
    leave
    ret
    

isDivisible:
    enter	0, 0
    push dword [ebp + 8]
    push dword [ebp + 12]
    xor	    edx, edx
    mov     eax, [ebp + 8]
    div     dword [ebp + 12]
    mov	    eax, edx
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
    push	dbgFormat
    call	printf
    leave
    ret
    

section .data
    format db `%d\n`, 0
    dbgFormat db `%d: %d\n`, 0
