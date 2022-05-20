# CS 2640 Final Project
# Caesar Cipher
# Matthew Alcasabas, Josh Kim, Ethan Bautista, Renard Pascual

.data
userString:	.space 	256
resString: 	.space	256
greetMsg:	.asciiz "Please enter the message you would like to encrypt/decrypt: "
cipherPrompt:	.asciiz "Press '1' to encrypt or '2' to decrypt: "
keyMsg:		.asciiz "Please input your desired key length: "
resMsg:		.asciiz "Result: "
contMsg:	.asciiz "\nPress '1' to continue or '0' to exit: "

.text
main:
	# Prints out the greeting message that prompts the user for input
	la $a0, greetMsg
	li $v0, 4
	syscall
	
	# Get user string
	la $v0, 8		
	la $a0, userString 			# Load 256 bytes of space for the userInput
	la $a1, 254 				# Read from the first 254 bytes of the string inputted by user
	syscall
	
	# Reserve space for the result string
	la $a3, resString
	
	# Prompt for key length
	la $a0, keyMsg
	li $v0, 4
	syscall
	
	# Get key length
	li $v0, 5
	syscall
	move $s1, $v0				# $s1 = User key length
	
	# Ask for encrypt or decrypt
	promptMode:
	la $a0, cipherPrompt
	li $v0, 4
	syscall
	
	# Get user choice
	li $v0, 5
	syscall
	move $s0, $v0				# $s0 = User's choice
	
	# Does user want to encrypt or decrypt?
	beq $s0, 1, enc				# If $s0 = 1, encrypt string
	beq $s0, 2, dec				# If $s0 = 2, decrypt string
	j promptMode				# If anything else, ask for choice again
	
	enc:
		la $a0, userString 		# Load address of space into a0
		jal strEncrypt
		
		j print
		
	dec:
		la $a0, userString 		# Load address of space into a0
		jal strDecrypt
		
		j print

print:
	# print "result: "
	la $a0, resMsg
	li $v0, 4 				# Prints the result message
	syscall

	# print the resulting string
	la $a0, resString
	li $v0, 4				# print_string
	syscall
	
	# Ask user if they want to run the program again
	promptContinue:
	la $a0, contMsg
	li $v0, 4
	syscall
	
	# Get user choice
	li $v0, 5
	syscall
	move $s4, $v0
	
	# Does user want to continue?
	beq $s4, 0, exit
	beq $s4, 1, main
	j promptContinue
	
exit:	
	# Gracefully exit program
	li $v0, 10
	syscall
	
strEncrypt:
	lb $t0, ($a0)				# Load n'th byte from userString (byte = current ascii char)
	beq $t0, $zero, endStrEncrypt		# If byte == 0, end loop (0 = null, end of string)
	move $t1, $t0				# Copy current byte to $t1
	beq $t1, 32, skipEncrypt		# If the char is a space (ascii 32), don't do anything to the ascii value
	beq $t1, 0, skipEncrypt			# If the char is a null (ascii 0), don't do anything to the ascii value
	add $t1, $t1, $s1 			# Increments ascii by specified key length
	skipEncrypt:				# Char is a space/null; Leave the ascii value alone
	sb $t1, 0($a3)				# Store the current byte into the resString
	addi $a3, $a3, 1			# Increment resString address (reserve more space for string)
	addi $a0, $a0, 1 			# Increments position in the array
	j strEncrypt				# Loop back to beginning of function
	endStrEncrypt:
	jr $ra					# Return control to caller

strDecrypt:
	lb $t0, ($a0)				# Load nth byte from userString
	beq $t0, $zero, endStrDecrypt		# If byte == 0, end loop (0 = null, end of string)
	move $t1, $t0				# Copy current byte to $t1
	beq $t1, 32, skipDecrypt		# If the char is a space (ascii 32), don't do anything to the ascii value
	beq $t1, 0, skipDecrypt			# If the char is a null (ascii 0), don't do anything to the ascii value
	sub $t1, $t1, $s1 			# Decrements ascii by specified key length
	skipDecrypt:				# Char is a space; Leave the ascii value alone
	sb $t1, 0($a3)				# Store current byte into the resString
	addi $a3, $a3, 1			# Increment resString address (reserve more space for string)
	addi $a0, $a0, 1 			# Increments position in the array
	j strDecrypt				# Loop back to beginning of function
	endStrDecrypt:
	jr $ra					# Return control to caller
