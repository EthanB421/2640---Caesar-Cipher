# CS 2640 Final Project
# Caesar Cipher
# Matthew Alcasabas, Josh Kim, Ethan Bautista, Renard Pascual

.data
userString:	.space 	256
resString: 	.space	256
greetMsg:	.asciiz "Please enter the message you would like to encrypt/decrypt: "
cipherPrompt:	.asciiz "Would you like to (1: Encrypt) or (2: Decrypt)? "
keyMsg:		.asciiz "Please input your desired key length: "
resMsg:		.asciiz "Result: "
contMsg:	.asciiz "\nPress '1' to continue or '0' to exit: "

.text
main:
	# Prints out the greeting message that prompts the user for input
	la $a0, greetMsg
	li $v0, 4
	syscall
	
	# get user string
	la $v0, 8
	la $a0, userString 	# Load 256 bytes of space for the userInput
	la $a1, 254 		# Read from the first 254 bytes of the string inputted by user
	syscall
	
	# reserve space for the result string
	la $a3, resString
	
	# prompt for key length
	la $a0, keyMsg
	li $v0, 4
	syscall
	
	# get key length
	li $v0, 5
	syscall
	move $s1, $v0		# $s1 = user key length
	
	# ask for encrypt or decrypt
	promptMode:
	la $a0, cipherPrompt
	li $v0, 4
	syscall
	
	# get user choice
	li $v0, 5
	syscall
	move $s0, $v0		# $s0 = user's choice
	
	# does user want to encrypt or decrypt?
	beq $s0, 1, enc		# if $s0 = 1, encrypt string
	beq $s0, 2, dec		# if $s0 = 2, decrypt string
	j promptMode		# if anything else, ask for choice again
	
	enc:
		la $a0, userString 	# Load address of space into a0
		jal strEncrypt
		
		j print
		
	dec:
		la $a0, userString 	# Load address of space into a0
		jal strDecrypt
		
		j print

print:
	# print "result: "
	la $a0, resMsg
	li $v0, 4 		# Prits the result message
	syscall

	# print the resulting string
	la $a0, resString
	li $v0, 4		# print_string
	syscall
	
	# ask user if they want to run the program again
	promptContinue:
	la $a0, contMsg
	li $v0, 4
	syscall
	
	# get user choice
	li $v0, 5
	syscall
	move $s4, $v0
	
	# does user want to continue?
	beq $s4, 0, exit
	beq $s4, 1, main
	j promptContinue
	
exit:	
	# gracefully exit program
	li $v0, 10
	syscall
	
strEncrypt:
	lb $t0, ($a0)
	beq $t0, $zero, endStrEncrypt
	move $t1, $t0
	add $t1, $t1, $s1 #Increments ascii
	sb $t1, 0($a3)
	addi $a3, $a3, 1
	addi $a0, $a0, 1 #Increments position in the array
	j strEncrypt
	endStrEncrypt:
	jr $ra

strDecrypt:
	lb $t0, ($a0)
	beq $t0, $zero, endStrDecrypt
	move $t1, $t0
	sub $t1, $t1, $s1 #Increments ascii
	sb $t1, 0($a3)
	addi $a3, $a3, 1
	addi $a0, $a0, 1 #Increments position in the array
	j strDecrypt
	endStrDecrypt:
	jr $ra