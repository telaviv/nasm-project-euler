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
%push
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
%pop


isPrime:
%push
%stacksize flat
%arg value:dword
%assign %$localsize 0 
%local i:dword
    enter	%$localsize, 0
    mov     [i], dword 1
.loop:                           
    inc     dword [i]
    mov	    ebx, [value]
    cmp     ebx, [i]
    je      .succeed
    push	dword [i]
    push	dword [value]
    call	isDivisible
    cmp	    eax, 0
    je      .fail
    jmp     .loop
.fail:
    mov     eax, 0
    jmp     .end
.succeed:
    mov eax, 1
    jmp .end
.end:
    leave
    ret
%pop
    

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
