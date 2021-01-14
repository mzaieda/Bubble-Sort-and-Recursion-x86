section .data
	array dq 0,1,3,4,7,9
	print_found db "Found in index of: "
	length1 equ $ - print_found
	print_not db "Not found"
	length equ $ - print_not

section .text
	global _start
_start:
	mov rax, array ;pointer to the first element in the array
	mov rbx, rax	; copy of the pinter to apply the logic
	add rbx, 40 ;pointer to the last element in the array
	mov rcx, 6 ; number of elements in the array
	mov rdx, 4 ; the element to besearching for
	
	
	; pushing the values onto the stack
	push rax	
	push rbx
	push rcx
	push rdx
	
	call binarySearch ; using call to be able to get to the ret hence ra
	
	; subroutine to print the string of found
	mov rax, 4
	mov rbx, 1
	mov rcx, print_found
	mov rdx, length1
	syscall
	
	; logic to get the index
	mov rax, r13 ; the middle element
	mov rcx, array ; the first element
	sub rax, rcx
	div rax, 4
	; rdx contains the remainder which i want to print that has the index
	
	; subroutine to print the index number in rdx
	mov rax, 0
	mov rbx, 0
	mov rcx, rdx
	mov rdx, 8
	syscall
	
	; exit syscall
	mov rax, 0x80
	syscall
	
		

	binarySearch:
		pop r9 ; element search
		pop r10	; nsize of the array
		pop r11  ; pointer at the end of the array
		pop r12  ; pointer at the begining of the array
		
		cmp r12, r11 ; base case for the recursion
		jg nono
		
		cmp r12, r9  ;base case for the last element
		je found
		
		cmp r11, r9	; base case for the fisr element 
		je found
		
		cmp r10, 0   ; base case for the size being 0
		je nono
		
		; r13 contains the middle element
		mov r13, r12	
		add r13, r11
		mov r14, 2
		mov rax, r13
		
		div r14 ; integer division to check if the pointer is in the middle of the middle element or not
		mov r13, rax
		mov r8, r13 ; copy of the pointer for the recursive call
			
		cmp rdx, 0 ; the rdx contains the remainder of the division
		jne fix  ; calling fix if the pointer is not alligned
		jmp cont0 ; else continue
		
		fix:
		add r13, 2  ; getting the middle element
		
		cont0:
		mov rax, [r13]	
		cmp rax, r9  ;comparing the element with the middle element
		jg leftSearch   ; if it is greater than then call the recursion with the left side
		jl rightSearch  ; if it is less than then call the recusion with the right side 
		jmp found
		
		found:
		retq ;returning to the first call 
			
		leftSearch:
		push r12 ; pushing the the same pointer in the left 
		push r13 ; pushing the middle poiuinter which will be the end pointer
		push r10 ;pushing the size again
		push r9 ; pushing the element 
		jmp binarySearch  ;recusive call
		
		
		rightSearch:	
		push r13   ; pushing the middle pointer which will be the start pointer
		push r11	; pushing the end pointer 
		push r10   ; size of the array
		push r9   	; pushing the element
		jmp binarySearch  ; recusive call
			


		; subroutine for not found print
		nono: 
		mov rax, 4
		mov rbx, 1
		mov rcx, print_not
		mov rdx, length
		syscall
		mov rax, 0x80
		syscall








