#this program does the bubble sort
.data 
	array: .space 100
	ask: .asciiz "\nEnter the number of elements in the array: "
	ask_num: .asciiz "\nEnter the integers to be sorted: "
	space: .asciiz " "
	
.text
	#print the ask string
	li $v0, 4
	la $a0, ask
	syscall
	
	#read an integer from the user
	li $v0, 5
	syscall
	
	#sotre the value in $t0
	move $t0, $v0	#t0 contains the size of the array
	la $t1, array	#pointer to the array
	move $t9, $t1	#copy of the begining of the pointer in t9
	
	#print the ask num to be stored in the array. 
	li $v0, 4
	la $a0, ask_num
	syscall
	
	#loop to store the items in the array
	li $t3, 0		#counter
	loop:	
	li $v0, 5		#syscall for reading an integer from the user
	syscall
	sw $v0, ($t1)		#storing the value in the array 
	add $t1, $t1, 4		#incrementing the pointer of the array by 4 
	addi $t3, $t3, 1	#increment the counter
	cont1:			#to be called by another labe
	bne $t3, $t0, loop	#if the counter is equal to the size then continue in the loop
	move $t4, $t1		#store the end pointer in t4
	
	li $t8, 0		
	la $s1, array($t8)	#retreiving the first pointer of the array
	
	
	addiu $sp, $sp, -8	#reserving space in the stack
	sw $t0, 0($sp)		#size of the array
	sw $t9, 4($sp)		#address of the array
	

	jal function 	#jump to function and store the ra in nline 49
	
	li $t3, 0	#counter to reset the pointer t1 
	reset_pointer_array:	#label to reset the pointer of the array
	sub $t1, $t1, 4		#decrementing the t1, by 4 until it reaches the first of the array
	add $t3, $t3, 1		#incrementing the counter
	bne $t3, $t0, reset_pointer_array
	
	li $t3, 0		#label to print the content of the array
	add $t1, $t1, 4		#increment the t1 by one 
	loop2:	
	lw $t4, ($t1)		#storing the content from t1 to t4
	li $v0, 1		#system call to print the integer
	la $a0, ($t4)	
	syscall
	li $v0, 4		#to have a space between the numbers to print
	la $a0, space
	syscall
	add $t1, $t1, 4		#keep incrementing the pointer
	add $t3, $t3, 1		#increment the counter
	bne $t3, $t0, loop2	#until it hits the end pointer
	
	addiu $sp, $sp, 8	#close of the stack 
	
	
	
	li $v0, 10		#syscall for exiting the prograqm 
	syscall
		
	function:
	lw $s6, 0($sp)	#storing the array size in s6
	lw $s7, 4($sp)	#storing the address of the array in s7
	loop1:
	lw $t5, ($s7)	#retreiving the contenet of s7 in t5
	add $s7, $s7, 4	#increment it 
	lw $t6, ($s7)	#retreive the second element in t6
	bgt $t5, $t6, swap	#swap if the t5 is bigger than t6
	cont:
	bne $t4, $s7, loop1	#checking if the last pointer is equal to the current pointer
	sub $t4, $t4, 4		#decrement the end pointer of the bubble sort
	beq $t4, $s1, sorted	#if the t4 is equal to the second address then it has to be sorted
	
	li $t3, 0		#counter to reset pointer
	reset_point_array:
	sub $s7, $s7, 4		#decrement the current pointer
	add $t3, $t3, 1		#increment the counter
	bne $t3, $s6, reset_point_array
	j loop1			#branch to the loop1 whenever im done with the resetting pointer
	
	swap:
	sw $t5, ($s7)		#function to swap 
	sub $s7, $s7, 4		#decrement the cureen
	sw $t6, ($s7)		#storing the value in the pointer in t6
	add $s7, $s7, 4		#increment the pointer by 4
	j cont 			#branch to cont
	
	sorted:			#sorted go to the printing 
	jr $ra
	
	exit:			#exit syscall
	li $v0, 10
	syscall
	
	
