extern exit
extern printf

global _start

section .text


%macro reset 0-1 0
    mov esp, ebp
    sub	esp, %1
%endmacro


%macro return 1
    mov     eax, %1
    leave
    ret
%endmacro


%macro return 0
    leave
    ret
%endmacro


%macro enter 0
    enter 0, 0
%endmacro


%macro div 2
    xor	    edx, edx
    mov     eax, %1
    div     dword %2
%endmacro


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
    mov     [i], dword 1
    mov     [largest], dword 0
.loop:
    reset %$localsize
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
    return [largest]
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
    reset %$localsize
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
    return
%pop


isDivisible:
%push
%stacksize flat
%arg dividend:dword, divisor:dword
    enter
    div     [dividend], [divisor]
    mov	    eax, edx
    return
%pop

print:
    enter
    push	dword [ebp + 8]
    push	format
    call	printf
    return

debug:
    enter
    push	dword [ebp + 8]
    push	dword [ebp + 12]
    push	dbgFormat
    call	printf
    return


section .data
    format    db `%d\n`, 0
    dbgFormat db `%d: %d\n`, 0
