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

%macro minc 2
    mov eax, %1
    mov edx, %2
    add eax, 1
    adc edx
    mov %1, eax
    mov %2, edx
%endmacro

_start:
    push	0
    push	13
    call	iterate

iterate:
%push
%stacksize flat
%arg lo:dword, hi:dword
    enter
.loop:
    reset
    inc	    dword [lo]
    jnc     .primefactor
    inc	    dword [hi]
.primefactor:
    push	dword [hi]
    push	dword [lo]
    call    largestPrimeFactor
    push    dword [lo]
    push    dword [hi]
    push	eax,
    push    edx
    call	debug
    jmp     .loop
%pop

largestPrimeFactor:
%push
%stacksize flat
%arg lo:dword, hi:dword
%assign %$localsize 0
%local i:dword, max:dword
    enter	%$localsize, 0
    push	dword [hi]
    push	dword [lo]
    call    sqrt
    mov	    [max], eax
    mov     [i], dword 1
.loop:
    reset   %$localsize
    inc     dword [i]
    mov	    eax, [i]
    cmp     eax, [max]
    je	    .finished
    push	dword [i]
    push	dword [hi]
    push    dword [lo]
    call	divisibilityPartner
    mov     ebx, eax
    or      ebx, edx
    jz	    .loop
    return
.finished:
    mov eax, 0
    mov edx, 0
    return
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
    push    dword 0
    push	dword [value]
    call	isDivisible
    cmp	    eax, 1
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
%arg lo:dword, hi:dword, divisor:dword
    enter
    mov	edx, [hi]
    mov eax, [lo]
.loop:
    cmp edx, 0
    jg	.calculateone
.calculatemulti:
    sub eax, [divisor]
    sbb edx, 0
    jc  .fail
    jmp .loop
.calculateone:
    sub eax, [divisor]
    jz	.succeed
    jc	.fail
    jmp	.loop
.fail:
    return 0
.succeed:
    return 1
%pop


divisibilityPartner:
%push
%stacksize flat
%arg lo:dword, hi:dword, divisor:dword
    enter
    mov ebx, [lo]
    mov ecx, [hi]
    mov eax, 0
    mov edx, 0
.loop:
    cmp ecx, 0
    je .solo
    sub	ebx, [divisor]
    sbb	edx, 0
    jc	.fail
    jmp .reloop
.solo:
    sub	ebx, [divisor]
    jz	.succeed
    jc	.fail
    jmp	.reloop
.fail:
    mov eax, 0
    mov edx, 0
    test eax, eax
    return
.reloop:
    add eax, 1
    adc edx, 0
    jmp .loop
.succeed:
    add eax, 1
    adc edx, 0
    return
%pop


sqrt:
%push
%stacksize flat
%arg lo:dword, hi:dword
%assign %$localsize 0
%local i:dword
    enter %$localsize, 0
    mov [i], dword 0
.loop:
    inc dword [i]
    mov eax, [i]
    mul eax
    cmp edx, [hi]
    jg  .toobig
    cmp eax, [lo]
    jg  .toobig
    je  .equal
    jmp .loop
.equal:
    mov eax, [i]
    jmp .end
.toobig:
    mov eax, [i]
    dec eax
.end:
    return
%pop

print:
    enter
    push	dword [ebp + 8]
    push	format
    call	printf
    return

debug:
%push
%stacksize flat
%arg alo:dword, ahi:dword, blo:dword, bhi:dword
    enter
    push	dword [alo]
    push    dword [ahi]
    push	dword [blo]
    push    dword [bhi]
    push	dbgFormat
    call	printf
    return
%pop


section .data
    format    db `%d\n`, 0
    dbgFormat db `[%x, %x]: [%x, %x]\n`, 0
