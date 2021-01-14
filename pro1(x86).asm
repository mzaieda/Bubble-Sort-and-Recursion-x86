﻿section .data
        array dq 1, 0, 7,4,9
        size dq 5
section  .text
global _start

_start:
	mov rax, array
        push size
        push rax

        mov rbx, [size]
        jmp Sort

BubSort:
        pop rax	;address of the first elment in the array
        pop rbx ;size of the array

        mov r12, [size]	;at the end store the size in this reg
        dec r12	;decrement 
        mov rbx, r12	; mov the r12 in rbx
        cmp r12, 0	; if it is equal to zero then the sort is done
        je doneSort	; done sort to print the array
        sub rax, 56	; 8*7 which indicates the end of the array
        push rbx	; restore the values again
        push rax	; for next sort loop
Sort:
        cmp rbx, 0	; for the first loop
        je BubSort

        pop rax ;address of the first element
        pop rcx ;size of the array

        mov rdx, [rax + 8]	;retreiving the two numbers 
        mov r10, [rax]	; the first
        cmp r10, rdx	;comparing it 

        jg swap	;swapping when needed

        cont:
        add rax, 8	;increment the pointer
        dec rbx		; decrement the loop counter

        push rbx	; restore the values in the stack again
        push rax

        jmp Sort	; looping again
swap:
;logic for swap
        mov [rax], rdx	
        mov [rax+8], r10
        jmp cont

doneSort:
; printing the arrray at the end
mov rax, 4
mov rbx, 1
mov rcx, array
mov rdx, 7

mov rax, 0x80	; exit syscal
syscall
