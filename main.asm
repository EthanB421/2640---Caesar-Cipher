# CS 2640 Final Project
# Caesar Cipher
# Matthew Alcasabas, Josh Kim, Ethan Bautista, Renard Pascual
# To-do: fix output: need to ignore spaces

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
	
	# get user string
	la $v0, 8		
	la $a0, userString 			# Load 256 bytes of space for the userInput
	la $a1, 254 				# Read from the first 254 bytes of the string inputted by user
	syscall
	
	# verify user string (call checkUserString here!)
	
	# reserve space for the result string
	la $a3, resString
	
	# prompt for key length
	la $a0, keyMsg
	li $v0, 4
	syscall
	
	# get key length
	li $v0, 5
	syscall
	move $s1, $v0				# $s1 = user key length
	
	# ask for encrypt or decrypt
	promptMode:
	la $a0, cipherPrompt
	li $v0, 4
	syscall
	
	# get user choice
	li $v0, 5
	syscall
	move $s0, $v0				# $s0 = user's choice
	
	# does user want to encrypt or decrypt?
	beq $s0, 1, enc				# if $s0 = 1, encrypt string
	beq $s0, 2, dec				# if $s0 = 2, decrypt string
	j promptMode				# if anything else, ask for choice again
	
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
	li $v0, 4 				# Prits the result message
	syscall

	# print the resulting string
	la $a0, resString
	li $v0, 4				# print_string
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
	lb $t0, ($a0)				# load nth byte from userString (byte = current ascii char)
	beq $t0, $zero, endStrEncrypt		# if byte == 0, end loop (0 = null, end of string)
	move $t1, $t0				# copy current byte to $t1
	add $t1, $t1, $s1 			# Increments ascii by specified key length
	# to-do: add function call here to ensure that ascii value is between 65 and 90 (only uppercase A-Z)
	sb $t1, 0($a3)				# store the current byte into the resString
	addi $a3, $a3, 1			# increment resString address (reserve more space for string?)
	addi $a0, $a0, 1 			# Increments position in the array
	j strEncrypt				# loop back to beginning of function
	endStrEncrypt:
	jr $ra					# return control to caller

strDecrypt:
	lb $t0, ($a0)				# load nth byte from userString
	beq $t0, $zero, endStrDecrypt		# if byte == 0, end loop (0 = null, end of string)
	move $t1, $t0				# copy current byte to $t1
	sub $t1, $t1, $s1 			# decrements ascii by spevified key length
	# to-do: add function call here to ensure that ascii value is between 65 and 90 (only uppercase A-Z)
	sb $t1, 0($a3)				# store current byte into the resString
	addi $a3, $a3, 1			# increment resString address (reserve more space for string?)
	addi $a0, $a0, 1 			# Increments position in the array
	j strDecrypt				# loop back to beginning of function
	endStrDecrypt:
	jr $ra					# return control to caller

checkUserString:
	# this function will check userString to ensure:
	# 1. ascii values stay between 65 and 90 (i.e. all uppercase chars)
	#	if it finds a lowercase char, convert it to uppercase (subtract 32)
	# 2. no illegal chars are inputted (e.g. { } | \ , . / ? etc.)
	#	if it finds something that isn't a letter, print an error msg and have user try again
	
	# iterate thru usrString at $a0 to check each character
	# no need to check resString, because resString should not have any illegal chars after running it thru checkBounds
	
checkBounds:
	# this function will check the ascii value and ensure that it is between 65(A) and 90(Z)
	# this ensures that no weird chars are printed in the encrypted/decrypted output
	# renard already has the algorithm for this, he just needs to implement it in MIPS asm
	
	
	