extern exit
extern printf

global _start

section .text

_start:
    mov ebx,0
    mov ecx,0
    
check:
    inc ebx
    cmp ebx,1000
    je	print

    mov edx,0
    mov eax,ebx
    mov edi,3
    div edi
    cmp edx,0
    je  accumulate

    mov edx,0
    mov eax,ebx
    mov edi,5
    div edi
    cmp edx,0
    je  accumulate

    jmp	check


accumulate:
    add ecx,ebx
    jmp check
    
print:
    push ecx
    push format
    call printf

    push 0
    call exit

section .data
    format db `%d\n`, 0
