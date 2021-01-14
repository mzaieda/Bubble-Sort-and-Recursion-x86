#t0: the size of the array
#t1: the address of the sorted array
#t4: the element to search for
.data 
	array: .space 100
	ask: .asciiz "\nEnter the number of elements in the array: "
	ask_num: .asciiz "\nEnter the integers (sorted): "
	ask_val: .asciiz "\nEnter the number you are searching for: "
	
.text
main:
	li $v0, 4	#system call to print the ask string
	la $a0, ask
	syscall
	
	li $v0, 5	#system call to read an integer
	syscall
	
	move $t0, $v0	#t0 contains the size of the array
	move $t8, $t0	#copy the same pointer into t8 as well
	la $t1, array	#pointer to the array
			
	li $v0, 4	#system call to print the ask num to be stored in the array
	la $a0, ask_num
	syscall
	
	#counter to sotre the inputs into the array
	li $t3, 0
	loop:
	li $v0, 5	#syscall to read int
	syscall
	sw $v0, ($t1)	#stgore in the array
	add $t1, $t1, 4
	addi $t3, $t3, 1
	bne $t3, $t0, loop	#unitl the end of the array size
	
	#sorted array complete
	li $t3, 0
	reset_pointer_array:
	sub $t1, $t1, 4
	add $t3, $t3, 1
	bne $t3, $t0, reset_pointer_array
	
	#syscall to print the string
	li $v0, 4
	la $a0, ask_val
	syscall
	
	#read int 
	li $v0, 5
	syscall 
	
	move $t4, $v0 	#the element to find 
	li $t7, 4
	mult $t7, $t8	#adjusting the pointers
	mflo $t7
	sub $t7, $t7,4
	add $t1, $t1, $t7
	
	addiu $sp, $sp, -20	 #store in the stack
	sw $t0, 0($sp) #size of the array
	sw $t1, 4($sp) #right of the array
	sub $t1, $t1, $t7
	sw $t1, 8($sp) #left of the array
	sw $t4, 12($sp) #element to search for
	
	
	
	jal binarysearch	#jump to the function of binary search
	#current ra
	addiu $sp, $sp, 20	#restore the stack
	
	#checking the values to print
	li $t8, -1
	beq $t9, $t8, notf
	j foundf
	notf:
	li $v0, 1
	move $a0, $t9
	syscall
	li $v0, 10		#exitting the program
	syscall
	
	foundf:
	li $v0, 1		#printing the int
	move $a0, $t9
	syscall
	
	
	li $v0, 10		#exitting the program
	syscall
	
	binarysearch:
	sw $ra , 16($sp)	#storing the ra value that was in the first jal
	binarySearch:
	blt $s1, $s2, notFound	#base cae if the right pointer is less than the left pointer
	lw $s0, 0($sp) #size of the array in the s0
	lw $s1, 4($sp) #right of the array
	lw $s2, 8($sp) #left of the array (at first it will be the first element)
	lw $s3, 12($sp) #element to search for in s3
	beq $s1, $s3, found	#checking the middle element retreived 
	beq $s2, $s3, found	#checking if the left right element is equal to the value 
	
	add $s4, $s2, $s1 	#add the two pointers 
	sra $s4, $s4, 1  #divide the number by two ($s4 has the middle element)
	li $s6, 4	
	div $s4, $s6	#divide the total number by 4
	mfhi $s7	#getting the remainder
	beqz $s7, continue	#if equal to zero go to continue
	bnez $s7, edit_first	#else then add to it 2 to fix the pointer
	edit_first:
		add $s4, $s4, 2
	continue:
	lw $s5, ($s4)	#chekcing id the pointer is pointing to the value we want
	beq $s5, $s3, found
	
	bgt $s5, $s3, leftSearch
	b rightSearch
	
	leftSearch:
	sub $s1, $s4, 4
	sra $s0, $s0, 1
	sw $s0, 0($sp) #size of the array
	sw $s1, 4($sp) #right of the array
	sw $s2, 8($sp) #left of the array
	sw $s3, 12($sp) #element to search for
	jal binarySearch
	#current ra

	rightSearch:
	add $s2, $s4, 4
	sw $s0, 0($sp) #size of the array
	sw $s1, 4($sp) #right of the array
	sw $s2, 8($sp) #left of the array
	sw $s3, 12($sp) #element to search for
	jal binarySearch

	found:
	li $t0, 268500992 #reference to the first address in the array
	sub $s4, $s4, $t0 #subtract from the current address
	sra $s4, $s4, 2	#divide by 4
	mfhi $t9	#get the remainder and store it in t9
	lw $ra, 16($sp)	#retreive the ra from the stack
	jr $ra		#jump to the ra refister
	
	notFound:
	li $t8, -1	#load the -1 in the t9
	move $t9, $t8
	lw $ra, 16($sp)	#retreive the ra register
	jr $ra		#jump to the ra again
	
	
	
	
	